#include "Vsign_extend.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vsign_extend* top = new Vsign_extend;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sign_extend.vcd");

    // init input data
    std::vector<unsigned int> instruction_words = {0x0FF00313,0x00000513,0x00000593,0x00058513,0x00158593,0xFE659CE3,0xFE0318E3};
    std::vector<int> corresponding_ImmSrc_value = {0,0,0,0,0,1,1};

    // run simulation for each possible input address
    for (int i = 0; i < instruction_words.size(); i++)
    {
        // set simulation input
        top->instr  = instruction_words[i];
        top->ImmSrc = corresponding_ImmSrc_value[i];

        // dump variables into VCD file and evaluate simulation for clock low then high
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2*i+clk);
            top->eval();
        }

        // print current state of top
        std::cout << "instr = "  << std::setfill('0') << std::setw(8) << std::hex << top->instr  << "   ";
        std::cout << "immsrc = " << (top->ImmSrc ? "1":"0") << "   ";
        std::cout << " -->    immop = "  << std::setfill('0') << std::setw(8) << std::hex << top->ImmOp  << "   " << std::endl;

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}

