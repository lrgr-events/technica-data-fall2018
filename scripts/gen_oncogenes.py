from argparse import ArgumentParser
from CCLE import CCLE_Info
import pandas as pd

def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-i', '--input', required=True)
    parser.add_argument('-o', '--output', required=True)
    parser.add_argument('-s', '--summary', required=True)
    return parser.parse_args()

def main():
    args = parse_args()
    onco_df = pd.read_csv(args.input, sep='\t', header=0, encoding='ISO-8859-1')
    onco_df.to_csv(args.output, sep='\t', index=False)
    print(onco_df.head())

    onco_counts = onco_df['Oncogenicity'].value_counts()
    onco_counts.to_csv(args.summary, sep='\t')

    print(onco_counts)

if __name__ == '__main__':
    main()