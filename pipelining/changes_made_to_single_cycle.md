# Changes made to Single Cycle
#### PC updates

Added an ```Enable``` signal to stall the PC counter in case of control or data hazards as sometimes data would not be ready for the next instruction after being processed for the current one. (For more information on Hazards please refer to ![Hazard Unit](pipelining/hazard_unit.md))
####  ALU updates

Within the pipeline implementation due to the forwarding signals ```forwardae``` and ```forwardbe``` this  allowed the ALU to access the data immediately rather than having to go through several stages which meant it would cause a data hazard. As a result we added two input muxes to the ALU that took in the RD outputs from the execute register as well as ```aluresult``` and ```immexte```.
#### Added stage names appended to all control and data signals

As pipelining was implemented we had to ensure a universal naming scheme for different signals along the pipeline stages as if they were all named the same it would be difficult to wire up as well as debug in GTK, as a result we added the pipeline stage suffix to the end of a variable name for example ```control_signalf``` or ```control_signalfm``` to define the signal for the fetch and the memory stage respectively.
### Register file write cycle changed on Negative Edge

Changed Register File write logic from ```always_ff @(posedge clk)``` to ```always_ff @(negedge clk)```. This was made so that rather than waiting for the next leading edge of the clock to write to the register when the instruction had been processed we could write any data to any register within the same cycle. In essence this proved to be useful as it reduced overall cycle time by one cycle. 

### PCSrc Logic and Branch Decoder

Unlike in the single cycle base CPU the ```PCSrc``` logic was calculated within the control unit and the required case outputs would be sent to the input mux of the PC however when pipelining was implemented due to the registers delaying certain signals by clock cycles we had to remove the logic that calculated ```PCSrc``` from within the control unit to the output of the execute register so that the sequential logic was in the correct clock cycle for the correct corresponding instruction.

The control unit had to be amended as PCSrc was not an output of combinational logic from two signals but rather just a case statement for the control signal of the PC input mux. As a result the main decoder file within the control unit folder had to be amended to incorporate the ```jump``` and ```branch``` signals to correctly propagate through the pipeline registers, as such. 

```verilog
7'b000_0000: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b00000_0000_00000; 
```
Another change that is shown in the code block above is the added case ```7'b000_0000```, this was added because on initial startup the control unit would read in an undriven signal from the decode register which caused it to run through all the case statements which met none of the given criteria resulting in the use of the default case which sets all control signals to all high. This cause undefined behaviour for our CPU which resulted in us implementing a "startup" case where the undriven signal does not change any of the control signals. 




