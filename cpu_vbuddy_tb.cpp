#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) 
{
  Verilated::commandArgs(argc, argv);

  // init top verilog instance
  Vcpu* top = new Vcpu;
  VerilatedVcdC* tfp = new VerilatedVcdC;

  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);

  // init trace dump
  Verilated::traceEverOn(true);
  top->trace(tfp, 99);
  tfp->open("cpu.vcd");
 
  // init Vbuddy
  if (vbdOpen() != 1) return(-1);
  vbdHeader("cpu");

  // initialize simulation input 
  top->clk = 1;
  top->rst = 0;
  top->trigger = 1;
  
  // run simulation for many clock cycles
  for (int i = 0; i >= 0; i++)
  {
    // dump variables into VCD file and toggle clock
    for (int tick = 0; tick<2; tick++)
    {
      tfp->dump (2*i+tick);
      top->clk = !top->clk;
      top->eval ();
    }
      //std::cout << "cycle = "<< std::setfill('0') << std::setw(3) << i     << "     " << std::endl;

    if (i > 600000) // 8 instructions in build loop * (4096x16 bytes) is appxox 600k cycles needed for calcuating pdf. Don't output anything til then
    {
      if ((int)(top->a0)==0) 
      {
        std::cout << "cycle = "<< std::setfill('0') << std::setw(3) << i     << "     ";
        std::cout << "a0 = "   << std::setfill('0') << std::setw(3) << (std::bitset<32>(top->a0)) << std::endl;
      }
      
      // plot a0
      vbdPlot((int)(top->a0), 0, 255);
      vbdCycle(i);
    }

    // either simulation finished, or 'q' is pressed
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) exit(0);
  }

  vbdClose();
  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}
   
