from os.path import join
DATA_DIR = 'data'
FILES_TO_URLS = \
{
    'raw/CCLE_metadata.csv':
        'https://depmap.org/portal/download/api/download/external?file_name=processed_portal_downloads%2Fdepmap-public-cell-line-metadata-183e.1%2FDepMap-2018q4-celllines.csv',
    'raw/CCLE_mutation_data.txt' :
        'https://data.broadinstitute.org/ccle/CCLE_DepMap_18q3_maf_20180718.txt',
    'raw/CCLE_RNAseq_RPKM_data.gct' :
        'https://data.broadinstitute.org/ccle/CCLE_DepMap_18q3_RNAseq_RPKM_20180718.gct',
    'raw/gcsi_drug_response.csv' :
        'https://obj.umiacs.umd.edu/xcl/drug-response-analysis/data_5_Genentech_Cell_Line_Screening_Initiative_%28gCSI%29.csv',
    'raw/oncoKB/level_info.json':
        'http://oncokb.org/api/v1/levels',
    'raw/oncoKB/allAnnotatedVariants.txt':
        'http://oncokb.org//utils/allAnnotatedVariants.txt',
}

DATA_TEMPLATE = join(DATA_DIR, '{filename}')
DATA_FILES = expand(DATA_TEMPLATE, filename=FILES_TO_URLS.keys())

#### OUTPUTS
OUTPUT_DIR = join(DATA_DIR, 'processed')
CELL_LINE_LIST = join(OUTPUT_DIR, 'cell_line_list.tsv')
ONCOKB_SUMMARY = join(OUTPUT_DIR, 'oncoKB_summary.txt')
ONCOGENES = join(OUTPUT_DIR, 'oncogenes.tsv')
EXPRESSION = join(OUTPUT_DIR, 'gene_expression.tsv')
BOTH_MUTATIONS = join(OUTPUT_DIR, 'nonsense_and_missense_mutations.tsv')
MISSENSE_MUTATIONS = join(OUTPUT_DIR, 'missense_mutations.tsv')
NONSENSE_MUTATIONS = join(OUTPUT_DIR, 'nonsense_mutations.tsv')


DR_DIR = join(OUTPUT_DIR, 'drug_response')
DRUG_NAMES = [
    'doxorubicin', 
    'erlotinib', 
    'gemcitabine', 
    'bid1870', 
    'bortezomib', 
    'irinotecan', 
    'lapatinib', 
    'gdc0941', 
    'rapamycin', 
    'pd0325901', 
    'docetaxel', 
    'ms275', 
    'vorinostat', 
    'thapsigargin', 
    'paclitaxel', 
    'crizotinib']
DR_TEMPLATE = join(DR_DIR, '{drug}.tsv')
DRUG_RESPONSE_FILES = expand(DR_TEMPLATE, drug=DRUG_NAMES)

rule all:
    input:
        CELL_LINE_LIST,
        ONCOGENES,
        ONCOKB_SUMMARY,
        EXPRESSION,
        BOTH_MUTATIONS,
        MISSENSE_MUTATIONS,
        NONSENSE_MUTATIONS,
        DRUG_RESPONSE_FILES

rule download:
    input:
        DATA_FILES
rule cell_lines:
    input:
        m = join(DATA_DIR, 'raw/CCLE_mutation_data.txt'),
        e = join(DATA_DIR, 'raw/CCLE_RNAseq_RPKM_data.gct'),
        dr = join(DATA_DIR, 'raw/gcsi_drug_response.csv'),
        ccle = join(DATA_DIR, 'raw/CCLE_metadata.csv')

    output:
        CELL_LINE_LIST
    shell:
        '''
        python scripts/gen_cell_lines.py \
            -dr {input.dr} \
            -m {input.m} \
            -e {input.e} \
            -ccle {input.ccle} \
            -o {output}
        '''
rule expression:
    input:
        cell_lines=CELL_LINE_LIST,
        rpkm=join(DATA_DIR, 'raw/CCLE_RNAseq_RPKM_data.gct'),
    output:
        EXPRESSION
    shell:
        '''
        python scripts/gen_expression_data.py \
            -i {input.rpkm} \
            -cl {input.cell_lines} \
            -o {output}
        '''
rule oncogenes:
    input:
        join(DATA_DIR, 'raw/oncoKB/allAnnotatedVariants.txt')
    output:
        summary=ONCOKB_SUMMARY,
        tsv=ONCOGENES
    shell:
        '''
        python scripts/gen_oncogenes.py \
            -i {input} -o {output.tsv} -s {output.summary}
        '''

rule mutations:
    input:
        mut=join(DATA_DIR, 'raw/CCLE_mutation_data.txt'),
        cell_lines=CELL_LINE_LIST,
        ccle = join(DATA_DIR, 'raw/CCLE_metadata.csv')
    output:
        combined=BOTH_MUTATIONS,
        nonsense=NONSENSE_MUTATIONS,
        missense=MISSENSE_MUTATIONS
    shell:
        '''
        python scripts/gen_mutation_data.py \
            -i {input.mut} \
            -cl {input.cell_lines} \
            -ccle {input.ccle} \
            -co {output.combined} \
            -no {output.nonsense} \
            -mo {output.missense}
        '''

rule drug_responses:
    input:
        cell_lines=CELL_LINE_LIST,
        drug_response_data=join(DATA_DIR,'raw/gcsi_drug_response.csv')
    params:
        drugs = DRUG_NAMES
    output:
        DRUG_RESPONSE_FILES
    shell:
        '''
        python scripts/gen_drug_response.py \
            -i {input.drug_response_data} \
            -cl {input.cell_lines} \
            -os {output} \
            -ds {params.drugs}
        '''


#### DOWNLOAD RAW DATA
rule download_one:
    output:
        DATA_TEMPLATE
    params:
        url = lambda w: FILES_TO_URLS[w['filename']]
    shell:
        'wget -O {output} {params.url}'

