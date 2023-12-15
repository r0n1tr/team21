#include "Valu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <vector>
#include <iostream>
#include <iomanip>

/*
 NOTE: This testbench is for module alu, not top_alu 
 (top_alu just adds a mux to change the operand source, 
  but the operands are being set manually in this testbench
  so testing top_alu is unnecessarily complex)
*/

void printaluop(int alucontrol, int aluop, int maxaluopwidth)
{   
    // print z or u to indicate signed/unsigned less than
    if      (alucontrol == 8) std::cout << "z(";
    else if (alucontrol == 9) std::cout << "u(";
    else std::cout << "  ";  // print two blank characters to align all other lines with the two characters printed in the other parts of this if statement
    
    // print aluop itself (the longest simulation input is e.g. 11 for aluop1 characters so setw(11) to align all aluop1 vals)
    std::cout << std::setfill(' ') << std::setw(maxaluopwidth) << aluop;

    // print closing bracket on "z(" or "u(" if needed, else just a blank character for alignment
    if (alucontrol == 8 || alucontrol == 9) std::cout << ")"; // print blank character to align all other lines with the last line as it prints ")"
    else std::cout << " ";
}

void printInputState(Valu* top, std::string aluop_symbol)
{
    // print alucontrol
    std::cout << "alucontrol = " << (int)(top->alucontrol) << ":       ";

    // print aluop1
    std::cout << "aluresult = ";
    printaluop((int)(top->alucontrol), (int)(top->aluop1), 11);

    // print operation symbol
    std::cout << aluop_symbol;

    // print aluop2
    printaluop((int)(top->alucontrol), (int)(top->aluop2), 3);
}

void printOutputState(Valu* top)
{
    std::cout << " = ";
    std::cout << std::setfill(' ') << std::setw(6) << (int)(top->aluresult);
    std::cout << "         zero = " << (int)(top->zero) << std::endl;
}

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Valu* top = new Valu;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("alu.vcd");

    // simulation data
    std::vector<long int>     aluop1_vals       = {100    , 100    , 100    , 85     , 2147483648 , -2147483648 , 8      , 6      , 2147483648 , 2147483648 };           
    std::vector<int>          aluop2_vals       = {200    , 200    , 2      , 15     , 15         , 15          , 3      , 12     , 100        , 100        }; 
    std::vector<unsigned int> alu_control       = {0      , 1      , 2      , 3      , 4          , 5           , 6      , 7      , 8          , 9          };
    std::vector<std::string>  aluop_symbols     = {"  +  ", "  -  ", " <<  ", "  ^  ", " >>  "    , " >>> "     , "  |  ", "  &  ", "  <  "    , "  <  "    };
    
    // std::vector<int>          expected_aluouts  = {300    , -100   , 400    , 90     , 65536      , -65536      , 11     , 4      , 1          , 0          };
    // std::vector<int>          expected_zeroouts = {0      , 0      , 0      , 0      , 0          , 0           , 0      , 0      , 0          , 1          };

    /*
      The above simulation data is for the followng calculations:

      0:     100         +   200  =  300        zero = 0
      1:     100         -   200  = -100        zero = 0
      2:     100        <<   2    =  400        zero = 0
      3:     85          ^   15   =  90         zero = 0
      4:     2147483648 >>   15   =  65536      zero = 0
      5:    -2147483648 >>>  15   = -65536      zero = 0
      6:     8           |   3    =  11         zero = 0           
      7:     6           &   12   =  4          zero = 0               
      8:   z(2147483648) < z(100) =  1          zero = 0             
      9:   u(2147483648) < u(100) =  0          zero = 1            
    */

    // run simulation for many clock cycles
    for (int i = 0; i < alu_control.size(); i++)
    {
        // update simulation inputs
        top->aluop1     = aluop1_vals[i];
        top->aluop2     = aluop2_vals[i];
        top->alucontrol = alu_control[i];
        
        // print input state
        printInputState(top, aluop_symbols[i]);

        // dump variables into VCD file and toggle clock
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2 * i + clk);
            top->eval();
        }

        // print output state
        printOutputState(top);
       
        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}
