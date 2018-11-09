from argparse import ArgumentParser
from CCLE import CCLE_Info
import pandas as pd
import numpy as np
from scipy.sparse import csr_matrix

def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-i', '--input', required=True)
    parser.add_argument('-ccle', '--ccle_metadata', required=True)
    parser.add_argument('-cl', '--cell_lines', required=True)
    parser.add_argument('-o', '--output', required=True)
    return parser.parse_args()

def main():
    args = parse_args()
    df = pd.read_csv(args.input, header=0, sep='\t')

    # Extract missense and nonsense mutations only
    df = df[(df['Variant_Classification'] == 'Missense_Mutation') | 
            (df['Variant_Classification'] == 'Nonsense_Mutation')]
    
    # Extract two column list of mutated gene to Broad ID
    df = df[['Hugo_Symbol', 'Broad_ID']]

    ccle = CCLE_Info(args.ccle_metadata)

    # Map Broad, DepMap IDs to Cell_line names
    df['Broad_ID'] = df['Broad_ID'].map(ccle.broad_id_2_ccle_name)
    df = df.rename(columns={'Broad_ID': 'Cell_line',
                            'Hugo_Symbol': 'Gene'})
    cell_lines = CCLE_Info.read_cell_lines(args.cell_lines)
    cell_line_set = set(cell_lines)
    
    # Extract rows for which the cell line is in given cell line set
    df = df[df['Cell_line'].isin(cell_line_set)]
    print(df.head())

    # Turn this two column list into a csr matrix
    genes = list(set(df['Gene'].values))
    gene2idx = dict((g, i) for i, g in enumerate(genes))
    cl2idx = dict((c, i) for i, c in enumerate(cell_lines))

    ccle_rows = [cl2idx[c] for c in df['Cell_line']]
    mut_cols = [gene2idx[g] for g in df['Gene']]
    data = np.ones_like(ccle_rows)
    mut_matrix = csr_matrix((data,(ccle_rows, mut_cols)), 
                             shape=(len(cell_lines), len(genes)) )
    print('* mutation matrix shape:', mut_matrix.shape)

    # Turn csr matrix into dense matrix and dataframe
    mut_matrix = mut_matrix.todense()
    mut_matrix = np.where(mut_matrix > 0, 1, mut_matrix)
    mut_df = pd.DataFrame(mut_matrix,
                          index=cell_lines,
                          columns=genes)
    
    # Save the dataframe
    mut_df.to_csv(args.output, sep='\t', header=True, index=True)

    ### some sanity checks...
    test_genes = 'UBE4B ATP13A2 KLHDC7A MAST2 IFRG15'.split()
    test_cell_line = 'A673'
    for g in test_genes:
        i = cl2idx[test_cell_line]
        j = gene2idx[g]
        assert(mut_matrix[i,j] == 1)
        assert(mut_df.loc[test_cell_line, g] == 1)

if __name__ == '__main__':
    main()