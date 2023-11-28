#include "Vdata_mem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env){
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vdata_mem* top = new Vdata_mem;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("data_mem.vcd");

    // initialize simulation inputs
    top->clk = 0;
    top->WE = 0;

    // run simulation for many clock cycles
    for (i=0; i<300; i++){

        // dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++){
            tfp->dump  (2*i+clk);
            top->clk = !(top->clk);
            top->eval ();
            }

        top->A = 4*i;
        std::cout << "cycle " << i << "  " << (int) top->RD << std::endl;

        
        if (Verilated::gotFinish())     exit(0);
        
    }
      
    tfp->close();
    exit(0);
}
