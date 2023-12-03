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

    // init input data (these are the instructions used in lecture 7, except addi which is from lab 4)
    std::vector<std::string>  instr_names       = {"addi",     "lw  ",     "sw  ",     "or  ",     "beq "};
    std::vector<unsigned int> instruction_words = {0x0FF00313, 0xFFC4A303, 0x0064A423, 0x0062E233, 0xFE420AE3};
    std::vector<int> corresponding_immsrc_value = {0,          0,          1,          3,          2};

    std::cout << std::endl;

    // run simulation for each possible input address
    for (int i = 0; i < instruction_words.size(); i++)
    {
        // set simulation input
        top->instr  = instruction_words[i];
        top->immsrc = corresponding_immsrc_value[i];

        // dump variables into VCD file and evaluate simulation for clock low then high
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2*i+clk);
            top->eval();
        }

        // print current state of top
        std::cout << "instr = "  << std::setfill('0') << std::setw(8) << std::hex << top->instr  << " (" << instr_names[i] << ")    ";
        std::cout << "immsrc = " << ((int)top->immsrc)  << "   ";
        std::cout << " -->    immext = "  << std::setfill('0') << std::setw(8) << std::hex << top->immext  << "   " << std::endl;

        if (Verilated::gotFinish()) exit(0);
    }

    std::cout << std::endl;

    tfp->close();
    exit(0);
}

