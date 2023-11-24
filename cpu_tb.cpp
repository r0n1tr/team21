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
    top->clk = 1;
    top->rst = 1;
    
    // run simulation for 10 clock cycles; program itself is 7 clock cycles and we can reset for the first 
    for (int i = 0; i < 775; i++)
    {
        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump (2 * i + clk);
            top->clk = !top->clk;
            top->eval ();
        }

         
        // print output state
        std::cout << "cycle = " << i << "       a0 = " << (int)(top->a0) << "   ";
        std::cout << "a1 = " << (int)(top->a1) << "    ";
        std::cout << "t1 = " << (int)(top->t1) << "    ";
        std::cout << "pc = " << (int)(top->pc) << std::endl;
        if(i == 1){
            top->rst = 0;
        }
        
        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
