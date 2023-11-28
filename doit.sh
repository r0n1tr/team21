#!/bin/sh

# cleanup
rm -rf obj_dir
rm -f cpu.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -Wall --cc --trace cpu.sv --exe cpu_tb.cpp -y alu -y control_unit -y instr_mem -y pc -y sign_extend -y reg_file -y data_mem

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vcpu.mk Vcpu

# run executable simulation file
obj_dir/Vcpu
