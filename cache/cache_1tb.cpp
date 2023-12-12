#include "Vmemory.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env){
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vmemory* top = new Vmemory;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("memory.vcd");

    // initialize simulation inputs
    top->clk = 1;
    top->we = 0;
    top->rst = 0;
    top->alu_result = 0x00000000;
    top->lw_en = 0;
    // run simulation for many clock cycles
    for (i=0; i<50; i++){

        // dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++){
            tfp->dump  (2*i+clk);
            top->clk = !(top->clk);
            top->eval ();
            }
        top->alu_result = 0x00000004;
        top->rst = (i == 3);

        
        if (Verilated::gotFinish())     exit(0);
        
    }
      
    tfp->close();
    exit(0);
}
