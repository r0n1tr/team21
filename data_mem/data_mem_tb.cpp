#include "Vdata_mem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env){

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
    for (int i = 0; i<512; i++){
    
        // dump variables into VCD file and toggle clock
        for(int clk=0; clk<2; clk++){
            tfp->dump  (2*i+clk);
            top->clk = !(top->clk);
            top->eval ();
        }

        // print output
        std::cout << "cycle " << i << "  " << (int) top->RD << std::endl;

        top->A = 4 * i;
        if (i >= 384) // write 0s to test writing data
        {
            top->WE = 1;
            top->WD = 0;
        }
        
        if (Verilated::gotFinish()) exit(0);
        
    }
      
    tfp->close();
    exit(0);
}
