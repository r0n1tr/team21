# Ziean's personal statement

## What I did

### Testbenches

I created testbenches for many modules. The aim of each was to:

- be able to easily verify if a module is working as intended
- be an easy way to check if any updates to a module were doing what they were meant to
- print the output in such a way as to be readable to somebody who had not read the testbench code

I feel that I have acheived these goals in all the testbenches I wrote. The task became easier over time as I saw each testbench as simply:

1. Set the input
2. Evaluate module
3. Read the outputs

which are easy to reproduce steps.

### Control unit

The control unit is tasked with taking in an instruction, and putting forth the relevant 
control signals to other parts of the CPU. Hence, the creation of the control unit requires
good understanding of the functions of other parts of the CPU as well as the control unit itself. This allowed greater interaction by myself with other modules.

### Data memory

### Instruction memory

### Sign extend

### 
Talk about what you did
    link to github commits / comments
    inc. testbenches
    helped considerably in the integration and bug fixing of pipeliing but not in the initial development as you were preoccupied with the base Link to your comments, parity updates



## What I learned

### Git

Git was something I had not used prior to this project. However, I feel diving straight into using it in a group setting meant that my learning to use Git progressed much faster. The potential for things to go 'wrong' or unexpectedly is much higher. This, in turn, meant that I had more oppoertunitues to solve various issues, which made me learn more. At this stage, I feel fairly confident on common Git commands.

I also learned to work a lot more with the terminal, and would primarily execute whatever I wanted to from there. I found it to be faster for most common tasks (file navigation, working with Git, quickly editing a file, etc.).

### SystemVerilog

SystemVerilog is core to our CPU. Working with it over the course of this project gave me a better idea of how real hardware design might work. Prior to this, ISSIE and other digital logic teaching efforts mainly used drag-and-drop schematics, which now clearly feels like a much slower way of building complex logic.

### GTKWave 

GTKwave is an excellent debugging tool, but it takes a while to become comfortable with it. For myself, it took a a different way of thinking about the CPU in order to use it effectively.
For myself, it was easy when working with SystemVerilog to forget that the code we are writing is supposed to be defining hardware rather than a typical software program. Translating this faulty mindset
over to GTKWave made it much harder to work with initially. 

However, once I started treating it as a tool to see signals and work with waveforms, things made much more sense. I could read values off more easily, point out errors, and make better judgement
about what I *should* and *should not* be paying attention to at some point in a given system (e.g. when choosing what signals to trace through). Being able to isolate where a problem might be faster meant shorter debugging times, which in turn translated to greater productivity as a group. 

### Documentation

All our efforts across this project had to be documented, in the form of comments, commits and markdown files. Learning to make legitimately useful documentation in a group setting was helpful. If someone in our group didn't understand something I did, I knew that I could likely explain it in a better way than I already had through my prior writings. It also incentivised the use of clear and clean code, as this
allowed better understanding of what I had contributed.

### Team work

Working with other people both offered hindrances and chances of development, as in any group setting. It can be difficult to communicate ideas (both in speech and writing), as well as keep track of ideas when sorting who implements what and how. Paving ways to share work load was sometimes difficult, as people were working at different paces through the project. 

However, having multiple people working on the CPU meant we were, overall, able to work much faster. While not the ideal 4x productivity boost, which is likely unrealisitic in any group setting, we did acheive a lot more than anyone of us could acheive individually.

Also, having multiple people work on the CPU did allow us to get more done in a reasonable amount of time
Also, working with other people allowed me to absorb great deals of information. Different people think differently. When they are more productive at certain tasks, I found it helpful to sit down with them to see how they did things. This was something I benefitted most from with my use of GTKWave and SystemVerilog.

## Mistakes made and what I would do differently

started on other stuff too early - parity checks were annoying


Found help in textbook and riscv manual





