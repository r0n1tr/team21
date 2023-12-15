#include "Vtop_pc.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <vector>
#include <iostream>
#include <iomanip>

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vtop_pc* top = new Vtop_pc;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top_pc.vcd");

    // simulation data
    std::vector<int>          rst_vals   = {1,          0,          0,          0,          0,          0,          0,          0,          0,          1,          1};           // assert reset at beginning and end
    std::vector<int>          pcsrc_vals = {0,          0,          0,          0,          0,          1,          1,          1,          1,          1,          1};           // PC+4 for first four clock cycles of rst!=1, then PC+ImmOP for last four clock cycles of rst!=1
    std::vector<unsigned int> immop_vals = {0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFC, 0xFFFFFFF4, 0x00000008, 0x00000010, 0xFFFFFFFF, 0xFFFFFFFF};  // immop valuess for when pcsrc = 1 (set to 0xFFFFFFFF for when pcsrc = 0)

    // run simulation for many clock cycles
    for (int i = 0; i < immop_vals.size(); i++)
    {
        // update simulation inputs
        top->rst   = rst_vals[i];
        top->PCsrc = pcsrc_vals[i];
        top->ImmOp = immop_vals[i];

        // print input state
        std::cout << "rst = "   << ((top->rst)   ? "1":"0") << "   ";
        std::cout << "pcsrc = " << ((top->PCsrc) ? "1":"0") << "   ";
        std::cout << "0x" << std::setfill('0') << std::setw(8) << std::hex << top->ImmOp << std::dec << "   ";

        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump (2 * i + clk);
            top->clk = !top->clk;
            top->eval ();
        }
        std::cout << "--> pulse clock -->   " ;
        
        // print output state
        std::cout << (unsigned int)(top->pc) << std::endl;
       
        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
