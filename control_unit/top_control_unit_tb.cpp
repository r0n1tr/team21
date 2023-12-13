#include "Vtop_control_unit.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>
#include <vector> 

void printTopState(const Vtop_control_unit* top, std::string instr_name)
{
    std::cout << instr_name << "   ";
    std::cout << "0x" << std::setfill('0') << std::setw(8) << std::hex << top->instr << std::dec << "   ";
    std::cout << "ZERO = " << ((top->zero) ? "1":"0") << ":  ";

    std::cout << (std::bitset<3>(top->funct3))     << "    ";
    std::cout << (std::bitset<3>(top->resultsrc))  << "       ";
    std::cout << (std::bitset<1>(top->memwrite))   << "        ";
    std::cout << (std::bitset<1>(top->alusrc))     << "      ";
    std::cout << (std::bitset<3>(top->immsrc))     << "    ";
    std::cout << (std::bitset<1>(top->regwrite))   << "        "; 
    std::cout << (std::bitset<4>(top->alucontrol)) << "       ";
    std::cout << (std::bitset<1>(top->branch))     << "      ";
    std::cout << (std::bitset<1>(top->jump))       << "    ";
    std::cout << (std::bitset<1>(top->jalr))       << std::endl;

}

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vtop_control_unit* top = new Vtop_control_unit;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top_control_unit.vcd");

    // init memory contents
    std::vector<std::string>  instr_names  = {"addi  x5, x6, 10", "slli  x5, x6, 10", "slti  x5, x6, 10", "sltiu x5, x6, 10", "xori  x5, x6, 10", "srli  x5, x6, 10", "srai  x5, x6, 10", "ori   x5, x6, 10", "andi  x5, x6, 10", "add   x5, x6, x7", "sub   x5, x6, x7", "sll   x5, x6, x7", "slt   x5, x6, x7", "sltu  x5, x6, x7", "xor   x5, x6, x7", "srl   x5, x6, x7", "sra   x5, x6, x7", "or    x5, x6, x7", "and   x5, x6, x7", "beq   x5, x6, 16", "bne   x5, x6, 16", "blt   x5, x6, 16", "bge   x5, x6, 16", "bltu  x5, x6, 16", "bgeu  x5, x6, 16", "jalr  x1, x5, 16", "jal   x1, 16    "};
    std::vector<unsigned int> mem_contents = { 0x00a30293,         0x00a31293,         0x00a32293,         0x00a33293,         0x00a34293,         0x00a35293,         0x40a35293,         0x00a36293,         0x00a37293,         0x007302b3,         0x407302b3,         0x007312b3,         0x007322b3,         0x007332b3,         0x007342b3,         0x007352b3,         0x407352b3,         0x007362b3,         0x007372b3,         0x00628863,         0x00629863,         0x0062c863,         0x0062d863,         0x0062e863,         0x0062f863,         0x010280e7,         0xf91ff0ef       };

    ///////////// TODO: removed lw, sw from testing. re-add these alongside the rest of the load/store instructions once you implement them  ///////////// 

    /*
        Here are the memory contents in an easier to read way:

            addi  x5, x6, 10     00a30293
            slli  x5, x6, 10     00a31293          
            slti  x5, x6, 10     00a32293            
            sltiu x5, x6, 10     00a33293            
            xori  x5, x6, 10     00a34293            
            srli  x5, x6, 10     00a35293            
            srai  x5, x6, 10     40a35293            
            ori   x5, x6, 10     00a36293            
            andi  x5, x6, 10     00a37293  

            add   x5, x6, x7     007302b3            
            sub   x5, x6, x7     407302b3            
            sll   x5, x6, x7     007312b3            
            slt   x5, x6, x7     007322b3            
            sltu  x5, x6, x7     007332b3            
            xor   x5, x6, x7     007342b3            
            srl   x5, x6, x7     007352b3            
            sra   x5, x6, x7     407352b3            
            or    x5, x6, x7     007362b3            
            and   x5, x6, x7     007372b3  

            beq   x5, x6, 16     00628863          
            bne   x5, x6, 16     00629863           
            blt   x5, x6, 16     0062c863           
            bge   x5, x6, 16     0062d863            
            bltu  x5, x6, 16     0062e863            
            bgeu  x5, x6, 16     0062f863   

            jalr  x1, x5, 16     010280e7            
            jal   x1, 16         f91ff0ef
    */

<<<<<<< HEAD
    std::cout << std::endl << "                                           funct3 resultsrc memwrite alusrc immsrc regwrite alucontrol branch jump jalr" << std::endl << std::endl;
                                                                           
=======
    std::cout << std::endl << "                                            pcsrc resultsrc memwrite alusrc immsrc regwrite alucontrol" << std::endl << std::endl;

>>>>>>> origin/base_dev
    // run simulation for 2 clock cycles per instruction; once for flag ZERO = 0 and again for ZERO = 1.
    for (int i = 0; i < mem_contents.size()*2; i++)
    {
        // set simulation inputs
        top->instr = mem_contents[i / 2];
        top->zero = (i % 2 != 0);

        // dump variables into VCD file and evaluate simulation for clock low then high
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2*i+clk);
            top->eval();
        }

        // print current state of top
        printTopState(top, instr_names[i / 2]);
        if (i % 2 == 1) std::cout << std::endl;

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}