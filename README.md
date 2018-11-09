# Technica data - Computational Discovery of Molecular Markers for Drug Response in Cancer

## About
This repo contains scripts to download and process data from the  [Cancer Cell Line Encyclopedia](https://portals.broadinstitute.org/ccle/) and the [Genentech Cell Line Screening Initiative](http://www.grcalculator.org/grbrowser/) for the 'Computational Discovery of Molecular Markers for Drug Response in Cancer' workshop at Tech + Research at [Technica 2018](https://gotechnica.org/).

## Usage
This repo requires `conda`.
Install and activate the conda environment with:

	conda env create -f environment.yml
	conda activate technica-data

Download and process raw data from [Cancer Cell Line Encyclopedia](https://portals.broadinstitute.org/ccle/):

	snakemake all
	 
## Data
Please find processed data in `data/processed/` which will contain:
- `cell_line_list.tsv` : a list of cell lines from [Cancer Cell Line Encyclopedia](https://portals.broadinstitute.org/ccle/) used for our workshop
- `gene_expression.tsv`: gene expression data for each of the cell lines
- `mutations.tsv`: gene mutation data for each of the cell lines
- `drug_response/`: drug response data for each of the cell lines for each of the 16 drugs