#!/usr/bin/python
# -*- coding: koi8-r -*-
import sys
import ConfigParser
import argparse
from collections import OrderedDict
from parse_params import * 
from random import *
from py_crc32.hash_cnt_crc32 import chash
import sys

HASH_CNT       = 10
MAX_HASH_VALUE = 4095

ch = chash( [ '04C11DB7'  , 'EDB88321', '82608EDB', '1EDC6F41' ] )

default_params_d = {

  'str_fname'    : False,
  'data_fname'   : False,
  'output_fname' : "filtered_data"

}

cmd_params_d = dict( )
usage = 'Reference model for Bloom pattern match'

cmd_params_d[ 'str_fname' ]  = ( '-s', '--str_fname' , 'str_fname', \
                                '<FILE>', 'store', \
                                'File with patterns to search.' )
cmd_params_d[ 'data_fname' ] = ( '-d', '--data_fname', 'data_fname', \
                                '<FILE>', 'store', \
                                'File with lines for search.' )
cmd_params_d[ 'output_fname' ]  = ( '-o', '--output_fname', 'output_fname', \
                                '<FILE>', 'store', \
                                'Output file name.' )

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
  params_d = parse_all_params( default_params_d, cmd_params_d, sys.argv[1:], usage )

  if( params_d[ 'str_fname' ] ):
    SIGN_FNAME = params_d[ 'str_fname' ] 

  else:
    print( "No file with pattern given!" )
    print( "Use -h for help" )
    sys.exit( 0 ) 

  if( params_d[ 'data_fname' ] ):
    DATA_FNAME = params_d[ 'data_fname' ]
  else:
    print( "No data file given!" )
    print( "Use -h for help" )

  if( params_d[ 'output_fname' ] ):
    OUT_FNAME = params_d[ 'output_fname' ]

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

  write_out_file( data_without_pattern, OUT_FNAME )
  print "FAIR RESULT: Strings found in %d lines" % ( fair_match_cnt )
  print "BLOOM RESULT: Strings found in %d lines" % ( bf_match_str )
