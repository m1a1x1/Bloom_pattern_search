vlib work

# compiling verilog files
# in my dir is no verilog files, so I commented this line

#vlog *.v


# compiling systemerilog files
vlog bloom_top_tb.sv

vlog ../rtl/top_bloom.sv
vlog ../rtl/hash/crc32_POL_1.sv
vlog ../rtl/hash/crc32_POL_2.sv
vlog ../rtl/hash/crc32_POL_3.sv
vlog ../rtl/hash/crc32_POL_4.sv
vlog ../rtl/hash/crc32_hash.sv

vlog ../rtl/interface/bloom_data_if.sv
vlog ../rtl/interface/bloom_setting_if.sv

vlog ../rtl/memory/bloom_mem.sv
vlog ../rtl/memory/true_dual_port_ram_single_clock.sv

vlog ../rtl/rx/bloom_rx.sv

# t_tb is name for your testbench module
vsim -novopt bloom_top_tb

#adding all waveforms in hex view
add wave -r -hex *

# running simulation for 1000 nanoseconds
# you can change for run -all for infinity simulation :-)
run 30000ns
