#include "Vdata_mem.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <vector>
#include <iostream>
#include <iomanip>

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vdata_mem* top = new Vdata_mem;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("data_mem.vcd");

    // simulation data
    std::vector<int> a_vals                  = {0,          4,          7,          9,          9,          9,          6,          5,          1          };           
    std::vector<int> we_vals                 = {1,          1,          1,          1,          0,          0,          0,          0,          0          };           
    std::vector<unsigned int> writedata_vals = {0x12345678, 0x00008421, 0x00001357, 0x00000089, 0xFFFFFFFA, 0xFFFFFFFB, 0xFFFFFFFC, 0xFFFFFFFD, 0xFFFFFFFE };  
    std::vector<int> memcontrol_vals              = {0b010,      0b001,      0b001,      0b000,      0b000,      0b100,      0b001,      0b101,      0b010      };        

    std::vector<std::string> instr_text = {"sw:  a = 0, d = 0x12345678", "sh:  a = 4, d = 0x00008421", "sh:  a = 7, d = 0x00001357", "sb:  a = 9, d = 0x00000089", "lb:  a = 9 --> should give 0xFFFFFF89", "lbu: a = 9 --> should give 0x00000089", "lh:  a = 6 --> should give 0x00001357", "lhu: a = 5 --> should give 0x00008421", "lw:  a = 1 --> should give 0x12345678"};
    
    /*
        Simulation data carries out the following (requires 16 bytes of memory) (the write data when we = 0 should not matter):

            sw:  a = 0, d = 0x12345678 --> should place 0x12 in 3, 0x34 in 2, 0x56 in 1, 0x78 in 0
            sh:  a = 4, d = 0x00008421 --> should place 0x84 in 5, 0x21 in 4
            sh:  a = 7, d = 0x00001357 --> should place 0x13 in 7, 0x57 in 6
            sb:  a = 9, d = 0x00000089 --> should place 0x89 in 9

            lb:  a = 9 --> should give 0xFFFFFF89
            lbu: a = 9 --> should give 0x00000089
            lh:  a = 6 --> should give 0x00001357
            lhu: a = 5 --> should give 0x00008421
            lw:  a = 1 --> should give 0x12345678
    */

   // init clock
   top->clk = 1;

    // run simulation for many clock cycles
    for (int i = 0; i < writedata_vals.size(); i++)
    {
        // update simulation inputs
        top->a         =         a_vals[i];
        top->we        =        we_vals[i];
        top->writedata = writedata_vals[i];
        top->memcontrol     =     memcontrol_vals[i];

        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2 * i + clk);
            top->clk = !top->clk;
            top->eval();
        }
        
        // print input state
        std::cout << instr_text[i] << "   -->   ";
        
        // print output state (do it for store instructions as well; even though it doesnt actually show what exactly was written its still an indicator)
        // outputs of importance are those given by load instructions, as these show the data was stored *and* retrieved successfully
        std::cout << "readdata = 0x" << std::setfill('0') << std::setw(8) << std::hex << (unsigned int)(top->readdata) << std::dec << std::endl;
       
        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
