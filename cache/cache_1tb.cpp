#include "Vmemory.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env){

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vmemory* top = new Vmemory;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("memory.vcd");

    // initialize simulation inputs

    // run simulation for many clock cycles
    for (int i = 0; i<512; i++){
    
        // dump variables into VCD file and toggle clock
        for(int clk=0; clk<2; clk++){
            tfp->dump  (2*i+clk);
            top->clk = !(top->clk);
            top->eval ();
        }

        // print output
        std::cout << "cycle " << i << "  " << (int) top->dout << std::endl;



        if (Verilated::gotFinish()) exit(0);
        
    }
      
    tfp->close();
    exit(0);
}
