import argparse
import pandas as pd

class CCLE_Info(object):
    def __init__(self, ccle_meta_file):
        self.fp = ccle_meta_file
        self.df = pd.read_csv(ccle_meta_file, header=0)

    def broad_id_2_ccle_name(broad_id):
        pass
    def ccle_name_2_broad_id(ccle_name):
        pass
    
    def get_ccle_name_info(ccle_name):
        '''
        Return dictionary of info given ccle_name
        '''
        raise NotImplemented
    
    def get_broad_id_name_info(broad_id):
        '''
        Return dictionary of info given ccle_name
        '''
        raise NotImplemented
        