#include "Vinstr_mem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vinstr_mem* top = new Vinstr_mem;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("instr_mem.vcd");

    // init memory contents
    const int memory_size = std::pow(2,8);

    // run simulation for each possible input address
    for (int i = 0; i < 20; i++)
    {
        // set simulation input
        top->a = i;

        // dump variables into VCD file and evaluate simulation for clock low then high
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2*i+clk);
            top->eval();
        }

        // print current state of top
        std::cout << "A = " << std::setfill('0') << std::setw(2) << std::hex << i << "    RD = 0x" << std::setw(8) << top->rd << std::dec << std::endl;

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}

