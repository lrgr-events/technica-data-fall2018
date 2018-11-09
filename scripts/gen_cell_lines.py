from argparse import ArgumentParser
from CCLE import CCLE_Info
import pandas as pd

def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-ccle', '--ccle_info', required=True)
    parser.add_argument('-dr', '--drug_response_data', required=True)
    parser.add_argument('-e', '--expression_data', required=True)
    parser.add_argument('-m', '--mutation_data', required=True)
    parser.add_argument('-o','--output', required=True)
    return parser.parse_args()

def drug_response_cell(fp):
    df = pd.read_csv(fp,header = 0, sep = ',')
    return set(df.Cell_Line)

def expression_cell(fp, ccle):
    df = pd.read_csv(fp,sep = '\t', header=0, skiprows = range(0,2))
    cells = list(df.columns)
    cells.remove('Name')
    cells.remove('Description')
    cell_lines = [ccle.split_ccle_name(n)[0] for n in cells]
    return set(cell_lines)

def mutation_cell(fp, ccle):
    df = pd.read_csv(fp,sep = '\t', header=0)
    cells_converted = [ccle.broad_id_2_ccle_name(n) 
                        for n in df.Broad_ID]
    return set(cells_converted)

#tbd = whatever the name of the column containing cell line name 

def main():
    args = parse_args()
    ccle = CCLE_Info(args.ccle_info)
    dr_genes = drug_response_cell(args.drug_response_data, )
    e_genes = expression_cell(args.expression_data, ccle)
    m_genes = mutation_cell(args.mutation_data, ccle)

    genes = dr_genes
    genes &= e_genes
    genes &= m_genes

    with open(args.output, 'w') as OUT:
        OUT.write('\n'.join(genes))

if __name__ == '__main__':
    main()