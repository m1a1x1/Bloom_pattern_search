#! /usr/bin/python
# -*- coding: koi8-r -*-

import argparse

import sys

from math import *

#from parse_params import *

from hash_cnt_crc32 import chash

from pycrc.pycrc import *

import json

# Sim file - file for verilog simulation
# State file - file for saving configuration
SIM_FNAME       = "example_settings"
PM_STATE_FNAME  = "pm_state.json"

# Parameters of filter.
# If you change something, don't forgot to change it in
# bloom_top_tb file.

HASH_CNT        = 10
MIN_STR_LEN     = 4
MAX_STR_LEN     = 16
HASH_MAX        = 4096 # - this parameter better not change


# This numbers are polinoms for CRC32 using to calc hash from string.
# If you change them, you also should change functions for calculating
# CRC32 in verilog ( /rtl/hash/crc32_POL_<N>.sv )

ch = chash( [ '04C11DB7'  , 'EDB88321', '82608EDB', '1EDC6F41' ] )


######################################################
# Functions
######################################################

# \brief Initialization of sim_util and creating .json file with
#        information about bloom state.
#        Creating clear file for simulation.
#
def init( ):

  pm_state = dict( )
  pm_state[ 'strings'   ] = [ ]
  pm_state[ 'hash_state' ] = [ [ [ 0 for i in range( HASH_MAX ) ] for j in range( HASH_CNT  ) ] for k in range( MAX_STR_LEN + 1 ) ]
  pm_state[ 'RAM_state'  ] = [ [ [ 0 for i in range( HASH_MAX ) ] for j in range( HASH_CNT/2 ) ] for k in range( MAX_STR_LEN + 1 ) ]
  pm_state[ 'RAM_bits'  ] = 0
  update_state( pm_state )

  f = open( SIM_FNAME , 'w' )
  f.close( )
  print 'Initialization successfuly done!' 


# \brief Add string for serach. Run only after -init.
#        Changeing .json file.
#
def add_str( string, pm_state ):

  if( string in pm_state[ 'strings' ] ):
    print "String:   %s\nwas already added!" % ( string )
    return( pm_state )

  if( len( string ) > MAX_STR_LEN ):
    print "String:   %s\nis too long!" % ( string )
    return( pm_state )

  if( len( string ) < MIN_STR_LEN ):
    print "String:   %s\nis too short!" % ( string )
    return( pm_state )

  str_len = len( string )
  hashs_str = pm_hash( string )

  hashs_to_write = hashs_str
  data_val = [ 1 ] * HASH_CNT
  data_to_write = 1

  update_sim( str_len, hashs_to_write, data_val, data_to_write ) 

  new_hash_state = pm_state[ 'hash_state' ]

  for i in range( HASH_CNT ):
    new_hash_state[ str_len ][ i ][ hashs_str[ i ] ] += 1

  pm_state[ 'strings' ].append( string )

  pm_state[ 'hash_stat' ] = new_hash_state

  pm_state = update_RAM_state( pm_state, str_len )

  update_state( pm_state )

  print "String:   %s\nadded." % ( string )

  return ( pm_state )

# \brief Count hash from string.
#        Return list of results of hash-functions from
#        string
#
def pm_hash( string ):
  hash_str = ch.calc_hashes( string )
  return( hash_str )

# \brief Make .json file with new state.
#
def update_state( pm_state ):
  with open( PM_STATE_FNAME, 'w' ) as f:
    json.dump( pm_state, f )

# \brief Updating file for simulation, add a new line there 
#
def update_sim( str_len, hashs_to_write, data_val, data_to_write ):
  hashs_str    = ''
  data_val_str = ''
  for i in range( HASH_CNT ):
    hashs_str     = hashs_str + ' ' + hex( hashs_to_write[ i ] )[2:]
    data_val_str = data_val_str + ' ' + str( data_val[ i ] ) 

  with open( SIM_FNAME, 'a' ) as f:
    f.write( str( str_len ) + hashs_str + data_val_str + ' ' + str(data_to_write) + '\n' )

# \brief Countig memory spent in FPGA for strings.
#
def update_RAM_state( pm_state, str_len ):
  #в модуле 1 память на каждые 2 хэш-функции
  new_RAM_state = pm_state[ 'RAM_state'  ]
  hash_state    = pm_state[ 'hash_state' ]

  cnt_bits_in_RAM = 0
  for k in range( MAX_STR_LEN ):
    for i in range( HASH_CNT/2 ):
      for j in range( HASH_MAX ):
        if( hash_state[ k ][ 2*i ][ j ] or hash_state[ k ][ 2*i+1 ][ j ] ):
          cnt_bits_in_RAM += 1
          if( k == str_len ):
            new_RAM_state[ k ][ i ][ j ] = 1
        new_RAM_state[ k ][ i ][ j ] = 0

  pm_state['RAM_state'] = new_RAM_state
  pm_state['RAM_bits'] = cnt_bits_in_RAM

  return( pm_state )

# \brief Adding strings from file.
#        If file does not exist - error will appear.
#   
def add_str_f( fname, pm_state ):

  strings = set( )
  
  try:
    with open( fname, 'r' ) as f1:
      for line in f1:
        strings.add( line[:-1] )
  except IOError as error:
    print( "Wrong file name!", error )
    sys.exit( -1 )

  strings = list( strings )
  Total_str = len( strings )
  cnt = 0
  print "Total strings in file: %s" % ( Total_str )
  for string in strings:
    print "Left to add: %s" % ( Total_str - cnt )  
    pm_state = add_str( string, pm_state )

    cnt = cnt + 1


# \brief Deleting one string.
# 
def rm_str( string, pm_state ):
  if( not( string in pm_state[ 'strings' ] ) ):
    print "String:   %s\nwas not added!" % ( string )
    return( pm_state )
  
  hashs_str = pm_hash( string )

  str_len = len( string )
  data_val = [0]*HASH_CNT
  hashs_to_write = hashs_str
  data_to_write = 0

  new_hash_state = pm_state[ 'hash_state' ]
  for i in range( HASH_CNT ):
    if( new_hash_state[ str_len ][ i ][ hashs_str[ i ] ] == 1 ):
      new_hash_state[ str_len ][ i ][ hashs_str[ i ] ] = 0
      data_val[ i ] = 1
    elif( new_hash_state[ str_len ][ i ][ hashs_str[ i ] ] > 1 ):
      new_hash_state[ str_len ][ i ][ hashs_str[ i ] ] -= 1

  update_sim( str_len, hashs_to_write, data_val, data_to_write ) 

  pm_state[ 'strings' ].remove( string )
  pm_state[ 'hash_state' ] = new_hash_state

  pm_state = update_RAM_state( pm_state, str_len )

  update_state( pm_state )
  
  print "String: %s removed!" % ( string )
  return ( pm_state )

# \brief Get pm_state from .json file.
#        Return pm_state (dict) if file exist.
# 
def open_state( ):
  try:
    with open( PM_STATE_FNAME, 'r' ) as f:
      pm_state = json.load( f )
  except IOError as error:
    print( "Initialization file not fount! Run '-init' first!", error )
    sys.exit( -1 )
  return( pm_state )

# \brief Print strings for search now.
# 
def show_state( pm_state ):
  print( "%5s %7s" % ( 'String len |', 'String' ) )

  pm_state[ 'strings' ].sort( key = len ) 
  for string in pm_state[ 'strings' ]:
    print( "%9d %10s" % ( len( string ), string  ) )

  print "Bits occupied for strings: %d" % ( pm_state['RAM_bits'] )

def print_welcom( ):
  print( '____________________' )
  print( 'Available commands: ' )
  print( 'WARNING: You can type only one command at a time' )
  print( '-a <STRING> ---- add sring \n' \
         + '-A <FILE>   ---- add strings from file\n' \
         + '-r <STRING> ---- delete string\n' \
         + '-S          ---- show strings added' )
  print( '____________________' )


if __name__ == "__main__":


  parser = argparse.ArgumentParser( description='Util for setting Bloom pattern search.', prefix_chars='-')

  parser.add_argument('-i','--init', action='store_true',
                         help='Prepare module.')

  parser.add_argument('-a','--add_str', type=str,
                         help='Add new string for search.')

  parser.add_argument('-A','--add_str_f', type=str,
                         help='Add strings for search from file.')

  parser.add_argument('-r','--rm_str', type=str,
                         help='Remove string.')

  parser.add_argument('-S','--show_state', action='store_true',
                         help='Show current configuration.')

  args = parser.parse_args()
  params_d = vars(args)

  if( params_d[ 'init' ] ):
    init( )
    print_welcom( ) 
    sys.exit( 0 )

  if( params_d[ 'add_str' ] ):
    pm_state = open_state( )
    add_str( params_d[ 'add_str' ], pm_state )
    sys.exit( 0 )

  if( params_d[ 'add_str_f' ] ):
    pm_state = open_state( )
    add_str_f( params_d[ 'add_str_f' ], pm_state )
    sys.exit( 0 )

  if( params_d[ 'rm_str' ] ):
    pm_state = open_state( )
    rm_str( params_d[ 'rm_str' ], pm_state )
    sys.exit( 0 )

  if( params_d[ 'show_state' ] ):
    pm_state = open_state( )
    show_state( pm_state )
    sys.exit( 0 )

  print( 'Wrong argument!\nUse -h for help\nRun -i to start working with bloom' )
