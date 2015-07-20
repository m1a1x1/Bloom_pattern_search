# BLOOM FILTER PATTERN SEARCH

![bloom](https://github.com/m1a1x1/Bloom_pattern_search/blob/master/doc/bloom.jpg)

### _FPGA Implementation of pattern search based on Bloom algorithm._


## About

  Verilog model of Bloom filter pattern search with opportunity to test
it on your text files!

## Additonal code

  Python utilits in this project using *pycrc* module for calculating
  crc. You can find one here:

  https://github.com/tpircher/pycrc

  In py_utils/README you will find instuction, how to add it in
  project.

#### Input:

1. File with long strings for cheking patterns there.
2. Spetial file for writing patterns in memory.

#### Output:

1. Transcript of ModelSim.
2. Special file with search results.


In every file you will finde detailed instructions
and descriptions.

## How to make it work:

1. Read ./doc/README for general information about project.
2. Follow the instructions ./py_utils/README and create settings file for simulation.
3. Follow the instructions ./testbench/README and run simulation. 

## The necessary software

1. ModelSim (See more in ./doc/README ).
2. Python 2.7.8

## P.S.

**Hope you will found it usefull!**
