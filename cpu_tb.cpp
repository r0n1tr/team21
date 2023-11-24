#include "vbuddy.cpp"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcpu.h" // change if sv file is named something else


int main(int argc, char **argv, char **env){
    std::cout << "WAZZUP";

    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop* top = new Vtop; // change if sv file is named something else
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("counter.vcd"); // change if sv file is named something else

    // init Vbuddy
    if (vbdOpen() != 1) return(-1);
    vbdHeader("IAC CW");

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    //top->en = 0;

    // run simulation for many clock cycles
    for (i=0; i<1000000; i++){

        // dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++){
            tfp->dump  (2*i+clk);
            top->clk = !top->clk;
            top->eval ();
        }
         top->rst = 0;
        if (Verilated::gotFinish())     exit(0);
    }

    vbdClose();     
    tfp->close();
    exit(0);
}
