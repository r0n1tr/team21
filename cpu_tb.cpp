#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vcpu* top = new Vcpu;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("cpu.vcd");

    // run simulation for 10 clock cycles; program itself is 7 clock cycles and we can reset for the first 
    for (int i = 0; i < 10; i++)
    {
        // update simulation inputs
        if (i == 0 || i == 9 || i == 10) 
        { 
            top->rst = 1;
        }
        else
        {
            top->rst = 0;
        }

        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump (2 * i + clk);
            top->clk = !top->clk;
            top->eval ();
        }
        
        // print output state
        std::cout << (unsigned int)(top->a0) << std::endl;
       
        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
