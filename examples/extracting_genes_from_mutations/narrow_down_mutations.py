'''
This is a script that will show you how to narrow down
mutation data to only genes that you might care about
'''

from argparse import ArgumentParser
import pandas as pd

def parse_args():
    '''
    Add the arguments so that you can call this script like:

        python narrow_down_mutations.py -m <mutation file> -gs <gene_list_file>
    '''
    parser = ArgumentParser()
    parser.add_argument('-m', '--mutations', required=True, type=str)
    parser.add_argument('-gs', '--gene_list', required=True, type=str)
    parser.add_argument('-o', '--output_file', required=True, type=str)
    return parser.parse_args()

def read_gene_list(filepath):
    '''
    Read genes from a file that looks like:

    gene_1
    gene_2
    gene_3

    and return a list
    '''
    
    # Initialize an empty list
    genes = []

    with open(filepath, 'r') as IN:
        # Iterate over the lines in the file
        for line in IN:
            # For each line, a string, in the file, 
            # append it to the genelist

            # Remove the last character in the line which is a newline
            # (tip: the index -1, is the last element in the list)
            # (tip: list[:-1] indexes from 0 to -1)
            line = line[:-1]

            genes.append(line)
    
    return genes 

def main():
    '''

    '''
    # Call our defined function to parse the command line arguments
    args = parse_args()
    genes = read_gene_list(args.gene_list)

    # Load the tab-separated mutations file as a DataFrame
    # (A DataFrame is an array which you can index by row and column names)
    df = pd.read_csv(args.mutations, 
                     sep='\t',
                     header=0, # Use 0-th line of the file as the 'header', the column names
                     index_col=0) # Use the 0-th column of the file as the 'index', the row names)
    
    # We can index the dataframe by name!
    # df[['col1','col7']] returns a dataframe containing columns named 'col1' and 'col7'
    df = df[genes]

    # We can save the dataframe with easy class method
    df.to_csv(args.output_file, sep='\t', header=True, index=True)

# The lines below tell python to run the 'main()' function when you run
#   python narrow_down_mutations.py ...
if __name__ == '__main__':
    main()