#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vcpu* top = new Vcpu;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("cpu.vcd");

    // initialise cpu
    top->clk = 0;
    top->rst = 1;
    top->trigger = 0;
    
    // run simulation for enough cycles for the CPU to reach 255
    for (int i = 0; i < 775; i++)
    {
        // stop resetting clock after cycle 0
        // cpu will take a few cycles to enter the loop, aftwe which there will be an increment every 3 cycles
        if(i >= 1) {
            top->rst = 0;
            top->trigger = 1;
        }
        
        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump (2 * i + clk);
            top->clk = !top->clk;
            top->eval ();
        }
  
        // print output state
        std::cout << "cycle = "<< std::setfill('0') << std::setw(3) << i       << "     ";
        std::cout << "a0 = "   << std::setfill('0') << std::setw(3) << top->a0 << std::endl;
        
        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
