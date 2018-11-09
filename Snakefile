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

rule all:
    input:
        CELL_LINE_LIST,
        ONCOGENES,
        ONCOKB_SUMMARY,
        EXPRESSION

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

#### DOWNLOAD RAW DATA
rule download_one:
    output:
        DATA_TEMPLATE
    params:
        url = lambda w: FILES_TO_URLS[w['filename']]
    shell:
        'wget -O {output} {params.url}'

