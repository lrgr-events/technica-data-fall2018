import argparse
import pandas as pd
from CCLE import CCLE_Info

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i','--input')
    parser.add_argument('-cl','--cell_lines')
    parser.add_argument('-o','--output')
    return parser.parse_args()


def restrict_to_cell_lines(df,cell_lines):
    new_colname = [CCLE_Info.split_ccle_name(n)[0] for n in list(df.columns)]
    df.columns = new_colname
    df_truncated = df[['Description']+[cell_lines]]
    df_truncated = df_truncated.rename(columns={'Description':'Gene'})
    df_truncated = df_truncated.set_index('Gene')
    return df_truncated

def main():
    args = parse_args()
    rnaseq_raw = pd.read_csv(args.input,sep = '\t', header=0, skiprows = range(0,2))
    cell_lines = CCLE_Info.read_cell_lines(args.cell_lines)
    truncated = restrict_to_cell_lines(rnaseq_raw,cell_lines)
    truncated.to_csv(args.output, sep= '\t')
   

if __name__ == '__main__':

    main()