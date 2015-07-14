#!/usr/bin/python
# -*- coding: koi8-r -*-
import argparse
from random import *
from py_crc32.hash_cnt_crc32 import chash
import sys

HASH_CNT       = 10
MAX_HASH_VALUE = 4095

ch = chash( [ '04C11DB7'  , 'EDB88321', '82608EDB', '1EDC6F41' ] )

class bf( ):
  def __init__( self, _byte_width, all_sign, _max_hash_value ):

    self.byte_width     = _byte_width
    self.max_hash_value = _max_hash_value
    
    self.my_signatures = list( )
    self.extract_signature( all_sign )

    self.prepare_ram( )
  
  def extract_signature( self, all_sign ):
    for i in all_sign:
      if len ( i ) == self.byte_width:
        self.my_signatures.append( i )

  def prepare_ram( self ):
    self.bf_ram = list( )
    # одна память на 2 хэш-функции
    for i in range( HASH_CNT/2 ):
      self.bf_ram.append( [0] * ( self.max_hash_value + 1 ) )

    for s in self.my_signatures:
      s_hash = self.calc_hash( s )
      for i in range( HASH_CNT/2 ):
        self.bf_ram[ i ][ s_hash[ 2*i ] ] = 1
        self.bf_ram[ i ][ s_hash[ 2*i+1 ] ] = 1

  def calc_hash( self, string ):
    hash_str = ch.calc_hashes( string )

    return( hash_str )
  

  def check_match( self, string ):
    hash_res = self.calc_hash( string )
    for i in range( HASH_CNT/2 ):
      if ( ( self.bf_ram[ i ][ hash_res[2*i] ] or self.bf_ram[ i ][ hash_res[2*i+1] ] ) == 0 ):
        return False

    return True

  def check_match_long_string ( self, long_string ):
    for i in range( len( long_string ) - self.byte_width + 1):
      send_to_check = long_string[ i : ( self.byte_width + i ) ]

      if self.check_match( send_to_check ):
        return True

    return False

def write_out_file( all_data, OUT_FNAME ):
  f = open( OUT_FNAME, 'w' )
  for data in all_data:
    f.write( data + "\n" )
  f.close()


if __name__ == "__main__":

  parser = argparse.ArgumentParser( description='Reference model of Bloom pattern search.', prefix_chars='-')

  parser.add_argument('-s', metavar='str_fname', type=str,
                         help='File with patterns to search.')

  parser.add_argument('-d', metavar='data_fname', type=str,
                         help='File with data for search in.')

  parser.add_argument('-o', metavar='output_fname', type=str,
                         help='Output file name (Only data without patterns). Default: data_fname + _no_patterns')

  args = parser.parse_args()
  parsed_args = vars(args)

  if( parsed_args[ 's' ] ):
    SIGN_FNAME = parsed_args[ 's' ] 

  else:
    print( "No file with pattern given!" )
    print( "Use -h for help" )
    sys.exit( 0 ) 

  if( parsed_args[ 'd' ] ):
    DATA_FNAME = parsed_args[ 'd' ]
  else:
    print( "No data file given!" )
    print( "Use -h for help" )
    sys.exit( 0 ) 

  if( parsed_args[ 'o' ] ):
    OUT_FNAME = parsed_args[ 'o' ]
  else:
    OUT_FNAME = DATA_FNAME + "_no_patterns"

  signs = [line.strip() for line in open(SIGN_FNAME)] 
  all_data = [line.strip() for line in open(DATA_FNAME)] 
  bf_widths = set()

  for i in signs:
     bf_widths.add( len( i ) )

  MAX_BYTE_WIDTH = max( bf_widths ) 
  HASH_CNT       = 10
  MAX_HASH_VALUE = 4095

  bf_l = list( )

  for i in bf_widths:
    bf_l.append( bf( i, signs, MAX_HASH_VALUE ) )
  
  total_str      = len(all_data)
  bf_match_str   = 0

  data_without_pattern = list()

  print "Total lines to search = %d" % ( total_str )
  cnt = 0
  fair_match_cnt = 0

  for data in all_data:
    match_flag = False
    print "Left lines to search = %d" % ( total_str - cnt )
    cnt += 1
    for bf_j in bf_l:
      if bf_j.check_match_long_string( data ):
        match_flag = True
        break

    if match_flag == True:
      bf_match_str += 1
    else:
      data_without_pattern.append( data )

    for sign in signs:
      if sign in data:
        fair_match_cnt += 1

  print( "Writing data without patterns in file: %s" ) % ( OUT_FNAME )
  write_out_file( data_without_pattern, OUT_FNAME )

  print "FAIR RESULT: Strings found in %d lines" % ( fair_match_cnt )
  print "BLOOM RESULT: Strings found in %d lines" % ( bf_match_str )
