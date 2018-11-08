from CCLE import CCLE_Info
import unittest

class TestALL(unittest.TestCase):
    '''
    Class for simple unit tests
    '''
    def setUp(self):
        pass

    def test_CCLE_info(self):
        ccle_info = CCLE_Info('../data/raw/CCLE_metadata.csv')
        self.assertEqual(ccle_info.split_ccle_name('NIHOVCAR3_OVARY'), ('NIHOVCAR3','OVARY'))
        self.assertEqual(ccle_info.broad_id_2_ccle_name('ACH-000001'), 'NIHOVCAR3')
        self.assertEqual(ccle_info.ccle_name_2_broad_id('NIHOVCAR3'),'ACH-000001' )    

if __name__ == '__main__':
    unittest.main()