# Ziean's personal statement

## What I did

### Testbenches

### Control unit

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

However, having multiple people work on the CPU did allow us to get more done in a reasonable amount of time
Also, working with other people allowed me to absorb great deals of information. Different people think differently. When they are more productive at certain tasks, I found it helpful to sit down with them to see how they did things. This was something I benefitted most from with my use of GTKWave and SystemVerilog.

## Mistakes made and what I would do differently

started on other stuff too early - parity checks were annoying


Found help in textbook and riscv manual




The control unit is tasked with taking in an instruction, and putting forth the relevant 
control signals to other parts of the CPU. Hence, the creation of the control unit requires
good understanding of the functions of other parts of the


