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
    std::cout << "ZERO = " << ((top->zero) ? "1":"0") << ":   ";

    std::cout << ((top->RegWrite ) ? "1":"0")  << "        ";
    std::cout << (std::bitset<2>(top->ImmSrc)) << "     ";
    std::cout << ((top->ALUSrc   ) ? "1":"0")  << "      ";
    std::cout << ((top->MemWrite ) ? "1":"0")  << "        ";
    std::cout << ((top->ResultSrc) ? "1":"0")  << "         ";
    std::cout << ((top->PCsrc    ) ? "1":"0")  << "     ";
    std::cout << (std::bitset<3>(top->ALUControl)) << std::endl;;
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
    std::vector<std::string>  instr_names  = {"addi",     "lw  ",     "sw  ",     "or  ",     "beq "};
    std::vector<unsigned int> mem_contents = {0x0FF00313, 0xFFC4A303, 0x0064A423, 0x0062E233, 0xFE420AE3};

    std::cout << std::endl << "                                RegWrite ImmSrc ALUSrc MemWrite ResultSrc PCsrc ALUControl" << std::endl << std::endl;

    // run simulation for 2 clock cycles per instruction; once for EQ = 0 and agaiin for EQ = 1.
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