from hash_cnt_crc32 import *

ch = chash( [ '04C11DB7' ] )# ['04C11DB7', 'EDB88321', '82608EDB', '1EDC6F41' ] )
hash_res = ch.calc_hashes( 'abcdefghijklmno' )

print( " Hash result: ", hash_res )
