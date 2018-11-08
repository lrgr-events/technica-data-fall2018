from CCLE import CCLE_Info
import unittest

class TestALL(unittest.TestCase):
    '''
    Class for simple unit tests
    '''
    def setUp(self):
        pass

    def CCLE_info(self):
        self.ccle_info = CCLE_Info('../data/raw/CCLE_metadata.csv')
        self.assertTrue(True)

if __name__ == '__main__':
    unittest.main()