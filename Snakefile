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

rule all:
    input:
        DATA_FILES,
        CELL_LINE_LIST

rule cell_lines:
    input:
        m = join(DATA_DIR, 'raw/CCLE_mutation_data.txt'),
        e = join(DATA_DIR, 'raw/CCLE_RNAseq_RPKM_data.gct'),
        dr = join(DATA_DIR, 'raw/gcsi_drug_response.csv'),

    output:
        CELL_LINE_LIST
    shell:
        '''
        python scripts/gen_cell_lines.py \
            -dr {input.dr} \
            -m {input.m} \
            -e {input.e} \
            -o {output}
        '''

#### DOWNLOAD RAW DATA
rule download_one:
    output:
        DATA_TEMPLATE
    params:
        url = lambda w: FILES_TO_URLS[w['filename']]
    shell:
        'wget -O {output} {params.url}'

