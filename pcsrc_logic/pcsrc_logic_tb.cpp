#include "Vpcsrc_logic.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <vector>
#include <iostream>
#include <iomanip>

int main(int argc, char **argv, char **env) {

	///////           TODO: UPDATE THIS TO UPDATED PCSRC LOGIC MODULE ///////////

    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vpcsrc_logic* top = new Vpcsrc_logic;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("pcsrc_logic.vcd");

    // simulation data
    std::vector<int> should_jalr_vals   = {0, 0, 0, 0, 1, 1, 1, 1};        
    std::vector<int> should_jal_vals    = {0, 0, 1, 1, 0, 0, 1, 1};        
    std::vector<int> should_branch_vals = {0, 1, 0, 1, 0, 1, 0, 1};

    std::cout << std::endl << "should_jalr should_jal should_branch  |  pcsrce" << std::endl;
    std::cout              << "------------------------------------------------" << std::endl;
    
    // run simulation for many clock cycles
    for (int i = 0; i < should_jalr_vals.size(); i++)
    {
        // update simulation inputs
        top->should_jalr   =   should_jalr_vals[i];
        top->should_jal    =   should_jal_vals[i];
        top->should_branch = should_branch_vals[i];
        
        // print input state
        std::cout << ((top->should_jalr)   ? "1":"0") << "           ";
        std::cout << ((top->should_jal)    ? "1":"0") << "          ";
        std::cout << ((top->should_branch) ? "1":"0") << "                 ";

        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump (2 * i + clk);
            top->eval ();
        }
        
        // print output state       
        std::cout << std::setfill('0') << std::setw(2) << (std::bitset<2>(top->pcsrce)) << std::endl;
       
        if (Verilated::gotFinish()) exit(0);
    }

    std::cout << std::endl;

    tfp->close();
    exit(0);
}
