# Changes made to single cycle components

- The register file has been modified to write on the negative half cycle
- pcsrc logic and branch decoder separated from main control unit. these were moved from the decode stage to the execute stage, since they relied on results of the execute stage to carry out their operations. btanch decoder has been moved into the pcsrc folder and it is part of the decision making of the next value of pcsrc. this also meant adding signals jump, jalr, branch to the output of the top control unit so that they could go through the execute piepline register into pcsrc logic/branch decoder
- in main decoder, added this line:

```verilog
7'b000_0000: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b00000_0000_00000;  // memory is blank --> do nothing (important as decode pipeline register is all 0s when the pipelines are filling up at start up, so main decoder has to be able to handle that)
```

-Moved 
