#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <iomanip>
#include "vbuddy.cpp"

#define MAX_SIM_CYC 200
#define ADDRESS_WIDTH 8
#define RAM_SZ pow(2,ADDRESS_WIDTH)


int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);

  Vcpu* top = new Vcpu;
  VerilatedVcdC* tfp = new VerilatedVcdC;

  top->trace(tfp, 99);
  tfp->open("cpu.vcd");

  if (vbdOpen() != 1) exit(-1);
  vbdHeader("L3T3Ch: cpu");
   top->clk = 0;
   top->rst = 1;
   top->trigger = 0;
  std::cout << "Starting sim" << std::endl;

  for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++) {
    for (tick = 0; tick < 2; tick++) {
      tfp->dump(2*simcyc+tick);
      top->clk = !top->clk;
      top->eval();
    }
    if(simcyc < 2){
      top->rst = 0;
      top->trigger = 1;
    }
    
        std::cout << "cycle = "<< std::setfill('0') << std::setw(3) << simcyc     << "     ";
        std::cout << "a0 = "   << std::setfill('0') << std::setw(3) << (std::bitset<32>(top->a0)) << std::endl;
        vbdHex(1, top->a0 & 0xF);
        vbdBar(top->a0 & 0xFF);
        vbdCycle(simcyc);



    if ((Verilated::gotFinish()) || (vbdGetkey() == 'q')) exit(0);
  }

  vbdClose();
  tfp->close();
  exit(0);
}




  // print output state
   

