from pycrc.pycrc import *


class chash ( ):
  def __init__( self, poly ):
    self.polinoms = poly  #[ '04C11DB7'  , 'EDB88321', '82608EDB', '1EDC6F41' ]
    self.crc32_opt_l = [ ]

    for pol in self.polinoms:
      argv = [ '--model', 'crc-32','--check-string', "abc", '--poly', str( int( pol, 16 ) ) ]
      opt = Options( )
      opt.parse( argv )
      alg = Crc(width = 32, poly = opt.Poly,
          reflect_in = False, xor_in = 0xffffffff,
          reflect_out = False, xor_out = 0x0,
          table_idx_width = opt.TableIdxWidth)
      self.crc32_opt_l.append( alg )
      #print( self.crc32_opt_l )

  def calc_hashes( self, s ):
    all_CRC = []
    cnt = 0
    for alg in self.crc32_opt_l:
      crc32 = alg.table_driven( s )
      cnt = cnt + 1
      all_CRC.append( format( crc32, '032b' ) )

    if( len( self.polinoms ) == 4 ):
      all_CRC_bin = "".join( all_CRC )
      hash_res = list( ) 
      for i in range( 10 ):
        hash_tmp = ''
        for j in range( 12 ):
          hash_tmp = hash_tmp + all_CRC_bin[ j + i*12 ]
        one_hash = int( hash_tmp, 2 )
        hash_res.append( one_hash )
      return( hash_res )

    else:
      return( "Wrong poly" )

