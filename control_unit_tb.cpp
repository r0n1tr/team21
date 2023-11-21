#include "Vcontrol_unit.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vcontrol_unit* top = new Vcontrol_unit;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("control_unit.vcd");

    // init mem contentts
    std::vector<unsigned int> mem_contents = {0x0FF00313,0x00000513,0x00000593,0x00058513,0x00158593,0xFE659CE3,0xFE0318E3};

    // initialise simulation inputs
    top->instr = mem_contents[0];
    top->EQ  = 0;

    // run simulation for many clock cycles
    for (int i = 0; i < mem_contents.size(); i++)
    {
        // dump variables into VCD file
        for (int clk = 0; clk < 2; clk++)
        {
         tfp->dump(2*i+clk);
         top->eval ();
        }

        top->instr = mem_contents[i];
        top->EQ = 0x0;
        std::cout << top->instr <<  " ";
        std::cout << "i = " << i << ", EQ = 0:   " << top->EQ;
        std::cout << top->RegWrite << " ";
        std::cout << top->ALUctrl  << " ";
        std::cout << top->ALUsrc   << " ";
        std::cout << top->ImmSrc   << " ";
        std::cout << top->PCsrc    << std::endl;

        top->EQ = 0x1;
        std::cout << top->instr <<  " ";
        std::cout << "i = " << i << ", EQ = 1:   " << top->EQ;
        std::cout << top->RegWrite << " ";
        std::cout << top->ALUctrl  << " ";
        std::cout << top->ALUsrc   << " ";
        std::cout << top->ImmSrc   << " ";
        std::cout << top->PCsrc    << std::endl;

       // if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
