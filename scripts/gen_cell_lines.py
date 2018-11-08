from argparse import ArgumentParser
import pandas as pd

def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-dr', '--drug_response_data')
    parser.add_argument('-e', '--expression_data')
    parser.add_argument('-m', '--mutation_data')
    parser.add_argument('-o','--output')
    return parser.parse_args()

def drug_response_genes(fp):
    
    return set()

def expression_genes(fp):
    return set()

def mutation_genes(fp):
    return set()

def main():
    args = parse_args()
    dr_genes = drug_response_genes(args.drug_response_data)
    e_genes = expression_genes(args.expression_data)
    m_genes = mutation_genes(args.mutation_data)

    genes = dr_genes
    genes &= e_genes
    genes &= m_genes

    with open(args.output, 'w') as OUT:
        OUT.write('\n'.join(genes))

if __name__ == '__main__':
    main()