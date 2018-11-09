import argparse
import pandas as pd
from CCLE import CCLE_Info
from os.path import join

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i','--input', required=True)
    parser.add_argument('-cl','--cell_lines', required=True)
    parser.add_argument('-ds','--drugs', nargs='*', required=True)
    parser.add_argument('-os','--outputs', nargs='*', required=True)

    return parser.parse_args()

def get_drug_response_df(df, drug, cell_lines):
    '''
    Returns dataframe, indexed by given cell line order
    of responses of given drug.

    Note: df has colimns, 'Cell_Line', 'Drug', ... etc.
    '''
    df = df[df.Drug == drug]
    df = df.set_index('Cell_Line')
    return df
        
def main():
    args = parse_args()
    df = pd.read_csv(args.input,header = 0)
    cell_lines =  CCLE_Info.read_cell_lines(args.cell_lines)

    df = df[['Cell_Line', 'Tissue', 'Perturbagen', 'GRinf', 'GR_AOC']]
    df = df.rename(columns={'Perturbagen':'Drug'})

    # restrict to cell line
    df = df[df.Cell_Line.isin(cell_lines)]

    print('* Number of drugs:', len(args.drugs))
    print('\tDrugs:', args.drugs)


    for drug, output in zip(args.drugs, args.outputs):
        dr_df = get_drug_response_df(df, drug, cell_lines)
        dr_df.to_csv(output, sep='\t', header=True, index=True)

if __name__ == '__main__':
    main()