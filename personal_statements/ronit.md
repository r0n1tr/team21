# Things I did

## ALU

During our project I was predominantly in charge with the ALU and register file. In the beginning the ALU was relatively straight forward as the reduced RISCV only required ```add``` and ```bne```. However when we began developing the full CPU alongside pipelining and jump instructions we had to incorporate multiple instructions such a shifting and SLT as well as extending the control signals to hold all the case statements for the instructions shown in the ALU breakdown. A unique difference in the ALU that did not come up anywhere else was the use of the keyword ```$signed/unsigned``` which is self-explanatory in its usage but was something that was required in order to have the two different types of SLT.
## Register File

The register file was largely based on the RAM/ROM designs from previous labs and lectures except the array layout was slightly different in terms of its bit-widths and having to ensure register ```x0``` was immutable as that had caused several debugging errors due to the fact we had assumed x0 could not change and it did in fact not for the first instruction but had been overwritten consecutively afterwards causing undefined behaviour. 

## Pipeline Registers

Pipelining was a very interesting application to improving the efficiency of our single cycle CPU although at times the improvement was negligible for certain cases. The use of registers in between each state was interesting in theory as well as writing code for it. 

Even though, it had looked straightforward to have "flip-flops" for our relevant signals in each stage it turned out to be rather confusing and difficult to debug due to the reading and decoding of the instructions happening one after the other but the executing and actual processing of the instruction to be several cycles later at times, making the debugging somewhat cryptic for longer programs.

Additionally, I foolishly attempted to implement pipelining without the hazard unit but quickly realized that they are in fact complimentary and would have saved a lot of time debugging and finding each control/data hazard cycle by cycle by hand. This also sparked an interest in using NOP's initially to test pipelining without an integrated hazard unit but that turned out to make development more tedious and frustrating. In hindsight ensuring they were both implemented in the same time-scale would have been extremely beneficial and time effective. 

## F1 Program

There were several iterations for the F1 Program from individuals within the group but by the end of the functioning ```BaseRISCV32I CPU``` we had collectively decided to go forward with my version that is listed under ![F1 Program](single_cycle/f1_program.md) which used the ```add``` function instead of ```slli``` due to simplicity and pre-existing instructions. I also added a jump function so that it could repeat the program for as many cycles as the test bench ran for.

# Things I learnt

Through this coursework I developed my coding expertise with System Verilog and have found it to be an exceptionally enjoyable language to learn and use to describe hardware and can't wait to use it in real applications. 

I also developed my debugging and verification skills by building testbenches in C++ for Verilator and using GTKWave to analyze signals to ensure correct functionality and timing. Many hours were spent staring at lines, but proved to be a tedious but highly rewarding task when everything worked out in the end.  When it came to debugging, ensuring we had more than one person looking at waveforms ensure that we would be prone to less errors and oversights as well as reducing time, analyzing diagrams.

I learned source/version control software through Git/Github and learning commands from VSCode as well as natively through the terminal was an interesting but difficult process as it was a complete new area of coding that I did not really use as much. Transitioning to being more comfortable with Linux commands and using the terminal to edit and commit files is an important skill to have and I am glad I learnt it quickly and was able to use it efficiently . 

Working with like minded individuals intent on having a high quality and functional project outcome was appreciated too.
# Things I would do next time

##### Development Process

Of course in hindsight there are many things that could be done better, points such as using Github in a more industry-standard nature rather than creating separate branches to do everything and trying to merge or rebase and having to sit through several merge conflicts could have been avoidable. Additionally, perhaps taking the initial steps more slowly rather than rushing in would have saved time in the long run due to the oversights in developing code in a range of areas such as ALU/Control instructions, control signals and the entire pipelining/hazard detection development. Instead trying to break it down and organize it with more clarity initially would have been a better alternative. 
##### Communication Strategies

Addition to this, ensuring all teammates had a sufficient understanding of the overall CPU before implementing their part of it as this would have made all the difference when it came to design of individual blocks and bringing it all into the top file. 
##### Team Collaboration

Improved communication between fellow teammates would have been beneficial too, as at times communication was limited and information was assumed which caused some discourse through the group which could have been easily avoided. Having a summary meeting after each "development session" to set achievements and next steps would have boosted productivity and reduced time spent on certain areas that did not require so much of an input. 
# Summary

All in all, it has been a thoroughly enjoyable project to work on as I feel I truly have a deeper understanding of the inner-workings of a CPU after having to break it down and code it from scratch. It has been a large learning curve from learning a new language to understanding Verilator and reading timing diagrams to understanding Git and using Linux natively as well as unexpected hurdles that inevitably come up in group work. Through all the long hours spent writing and sifting through code to debugging signals it has been time well spent and happy to have accomplished this task to the furthest extent. My skills yet sharpened, I am eager to hone my skills in this field even further.

