
# Team 21 Reduced RISCV CPU 

### Team 21 Participants and responsibilities

- Mohammed Tayyab Khalid - Test bench 
- Ziean Ahmad Sheikh - Control unit, instruction memory and sign extend block
- Ronit Ravi - ALU and register file block
- Daniel Dehghan - Program counter block

![pseudo](https://github.com/r0n1tr/team21/assets/133985295/e29c542d-82f2-4a47-8b40-2c780f645c3d)

Based on the instruction set above, a0 will increment by 1 every 3 clock cycles.

<img width="157" alt="lab_4_working" src="https://github.com/r0n1tr/team21/assets/133985295/c1b69727-355c-4f1a-904b-c68c3ec88ac5">

As you can see, a0 is incrementing my 1 every clock cycles as expected


### Challenges Encountered

After dividing the tasks, it was agreed that everyone would regroup after they finished with their part of the CPU. We did just that, except everyone's System Verilog files had some issues.
No one tested their part of the CPU, so when we put everything together, we ran into multiple errors on Ubuntu. 
Everyone reviewed the top file of the CPU to try and fix the errors. We only got to work after everyone came together and worked on it in-person as opposed to using WhatsApp.

### What we would do differenty if we started again

- Have everyone test their components before assembling the CPU, if possible.
- Have more in-person meetings
- Be more careful about our understanding the spec. I made mistakes on:
  - control unit: set pcsrc high when EQ was high when it should have been pcsrc high if EQ low (for the bne instruction)
  - sign extension: didn't acknowledge bne used a 13 bit immediaten where the lsb always = 0

