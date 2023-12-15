## Summary of My Contributions 

## Program Counter 
At the project's outset, my responsibility involved developing the Program Counter, wherein I integrated various components to achieve a fully operational PC. Following a team meeting, I proposed the incorporation of a systemwide trigger into the PC mux, enabling the program counter to reset to all zeros when the trigger was low. Initially, Tayaab and I attempted to implement this by introducing two new muxes. However, we later recognized the redundancy and opted to integrate it as a control signal into the existing PC mux.

For the jump and branch instructions, Ziean and I determined that expanding PcsRc to two bits would be logical for accommodating all instructions. Ziean conceptualized a module named pcsrc logic, positioned at the intersection of the control unit and its connection with the program counter. This module calculates the PCsrc value based on the control signals.

Upon completing the program counter, I collaborated with Ziean on the control unit. During the implementation of instructions, we discovered that the alucontrol, originally depicted as a 3-bit entity in the schematic, proved insufficient for incorporating all the required instructions within the CPU. Consequently, Ziean and I expanded it to 4 bits to accomodate all the instructions.
## Data Memory 

Initially, I was responsible for designing the data memory. During the initial implementation of the data memory, a question arose concerning whether it was necessary to assign "rd" during store word operations. After a thorough evaluation and a deeper understanding of the CPU, it became apparent that the control flags would handle this aspect, rendering the assignment of "rd" a non-issue.

Subsequently, we encountered the need to modify the data memory to support byte addressing. With Zieans idea , we utilized "memcontrol," which corresponds to funct3 in the lw and sw instructions. This approach determined the type of addressing being performed. For further details, please refer to the readme file.
## Pipelining 
Implementing the pipeline, our initial stretched goal, proved more challenging than anticipated.When Ronit and I designed the pipelining registers we did not think about its connection with the hazard unit but later understood that they synced together which would have saved us a lot of time. Adding the clear and enable signals to the registers after they were implemented meant debugging took much longer than expected. 



## Cache 

Cache proved to be one of the challenging tasks of this course but was my favorite part to do. When Tayaab and I first started working on the cache we were thinking about whether the cache would have to be clocked but then realized we need instant memory access therefore it would be counterproductive. There were many ways of implementing the cache but our Professor's analogy of taking books from a bookshelf is what helped us to visualize the code and implement it. We also decided to add a reset signal to make the v flag 0 but later realized we could assign 0 to the whole set as the data within it is not useful. Another challenge was how we were going to integrate the cache within the whole CPU so I designed how we would connect the cache to the data memory. If we had a hit we would skip the data memory but a miss would cause us to write that data to the cache. (schematic on read.me file)


## Two-way Cache
After making the one-way cache my curiosity led me to start implementing the two-way cache as well. Since there were now two ways in every set, this meant I had to come up with a consistent replacement policy on how the cache would be written. This is where I added an internal flag which would toggle between 1 and 0 depending on which data was most recently accessed therefore when writing data we would use that flag to determine which data was least recently used.




## Things I learned 

I realized the importance of planning when designing a new module, how it would fit in the whole CPU, and complement the rest of the components.
I learned the importance of working as a team and how important it is to discuss things with your teammates which would have saved a lot of time.

Not writing begin and end statements or missing syntax, I learned the System Verilog language in precise detail and what a lot of the warning errors meant. This learning experience was not an easy one however I enjoyed every moment of learning how to design hardware as V-Buddy always showed us it was worth it in the end. 

Not having used Github before, I was guided by Ronit's expertise, and I gained insights into effective version control, encompassing actions like pushing and pulling. Additionally, I delved into terminal usage,  writing meaningful commit messages, and acquired proficiency in Markdown,  while organizing my notes on Obsidian.

When we initially decided to do the CPU we did not come up with decisions on our naming and when debugging the base CPU it took us a long time to address issues such as case sensitivity so Ronit and I decided to fully change all the signals to simple case and coordinated with the group to thereafter use all simple letters in pipelining and cache. Sometimes rushing to do the coding part was not the best way to go about it but we should first come up with a thorough plan.

The experience increased my resilience in debugging, as I learned to anticipate that the initial code draft may not represent my best work. Understanding the iterative nature of writing efficient code, I embraced the notion that improvement is an ongoing process. Most significantly, I achieved a comprehensive understanding of how a pipelined cache RISC-V CPU operates, not only in the specific parts I contributed to but in the entirety of the RISC-V Processor.

## Things I would do differently 

Making sure the entire team had a good understanding of the entire CPU. To fully collaborate with your teammates I believe that next time I would try to fully understand how the whole CPU efficiently works and not just the modules we had responsibility for making, this would have made connecting the CPU easier as we could help each other with designing modules rather than learning it more deeply after it was implemented. 
In this way for pipelining and debugging, a different person could do something someone else had previously done .*

When debugging for long hours we should try to take breaks to regain focus as it would cause us to overcomplicate the simple errors. 

Coming up with a distinct set of practices for the whole group, When we had initially built our modules we all believed our modules worked correctly but after connecting it realized there were a lot of errors, and debugging straight for 8 hours was not ideal if we had all individually tested our components with individual test benches. It would have saved us a great deal of time. After this, we realized that working on campus together would be easier for the group so everyone was updated on the modules and we could collaborate more easily and debug the whole CPU on one member's machine. 

## Future Decisions
If I had more time I would have greatly liked to implement a working 4-way cache within the CPU as I believe it gives the best of both worlds. Since it has less conflict and capacity misses but also has a good block size which decreases the compulsory misses. I would have also loved to work on computer arithmetics and build upon my knowledge of Booth's algorithm from last year, perhaps I will do this as a personal project.
## Conclusion 
Overall I greatly enjoyed doing this Coursework as not only did I learn a lot from the technical aspect of things but also how to work in a group on projects. Now I look forward to further nourishing my skills and applying them to industry in the future.
