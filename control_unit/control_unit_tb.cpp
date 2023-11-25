#include "Vcontrol_unit.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>
#include <vector> 

void printTopState(const Vcontrol_unit* top)
{
    std::cout << "0x" << std::setfill('0') << std::setw(8) << std::hex << top->instr << std::dec << "   ";
    std::cout << "EQ = " << ((top->EQ) ? "1":"0") << ":   ";

    std::cout << ((top->RegWrite) ? "1":"0");
    std::cout << ((top->ALUctrl ) ? "1":"0");
    std::cout << ((top->ALUsrc  ) ? "1":"0");
    std::cout << ((top->ImmSrc  ) ? "1":"0");
    std::cout << ((top->PCsrc   ) ? "1":"0") << std::endl;
}

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc,argv);

    // init top verilog instance
    Vcontrol_unit* top = new Vcontrol_unit;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("control_unit.vcd");

    // init memory contents
    std::vector<unsigned int> mem_contents = {0x0FF00313,0x00000513,0x00000593,0x00058513,0x00158593,0xFE659CE3,0xFE0318E3};

    // run simulation for 2 clock cycles per instruction; once for EQ = 0 and agaiin for EQ = 1.
    for (int i = 0; i < mem_contents.size()*2; i++)
    {
        // set simulation inputs
        top->instr = mem_contents[i / 2];
        top->EQ = (i % 2 != 0);

        // dump variables into VCD file and evaluate simulation for clock low then high
        for (int clk = 0; clk < 2; clk++)
        {
            tfp->dump(2*i+clk);
            top->eval();
        }

        // print current state of top
        printTopState(top);

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}