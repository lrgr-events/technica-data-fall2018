from os.path import join
DATA_DIR = 'data'
FILES_TO_URLS = \
{
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

rule all:
    input:
        DATA_FILES

rule download_one:
    output:
        DATA_TEMPLATE
    params:
        url = lambda w: FILES_TO_URLS[w['filename']]
    shell:
        'wget -O {output} {params.url}'
