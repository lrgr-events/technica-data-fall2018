#!/bin/bash
wget -O CCLE_mutation_data.txt https://data.broadinstitute.org/ccle/CCLE_DepMap_18q3_maf_20180718.txt
#wget -O CCLE_miRNA_expression_data.gct https://data.broadinstitute.org/ccle/CCLE_miRNA_20180525.gct
wget -O CCLE_RNAseq_RPKM_data.gct https://data.broadinstitute.org/ccle/CCLE_DepMap_18q3_RNAseq_RPKM_20180718.gct
#wget -O CCLE_DNA_methylation_CpG_data.tsv https://data.broadinstitute.org/ccle/CCLE_RRBS_TSS_CpG_clusters_20180614.txt
wget -O gcsi_drug_response.csv https://obj.umiacs.umd.edu/xcl/drug-response-analysis/data_5_Genentech_Cell_Line_Screening_Initiative_%28gCSI%29.csv
