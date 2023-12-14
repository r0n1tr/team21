# Pipelining registers

Added Files:
- pipe_fetch.sv
- pipe_decode.sv
- pipe_execute.sv
- pipe_memory.sv

Here we have our four pipeline registers that all synchronously work to clock data from the input to the output for relevant signals between each stage.



```verilog 
// pipe fetch
    if(clr) begin
        instrd   <= 32'b0;
        pcd      <= 32'b0;
        pcplus4d <= 32'b0;
    end
    else if(~en_b) begin
        instrd   <= instrf;
        pcd      <= pcf;
        pcplus4d <= pcplus4f;
    end
```
The fetch register required two control signals ```Clear``` and ```Enable``` to either ```Flush``` or ```Stall``` the program counter register to avoid hazards.

```verilog
// pipe decode
    if(clr) begin
        regwritee   <= 1'b0;
        resultsrce  <= 2'b0;
        memwritee   <= 1'b0;
        jumpe       <= 1'b0;
        branche     <= 1'b0;
        alucontrole <= 3'b0;
        alusrce     <= 1'b0;
        jalre       <= 1'b0;
  
        rd1e     <= 32'b0;
        rd2e     <= 32'b0;
        rs1e     <=  5'b0;
        rs2e     <=  5'b0;
        pce      <= 32'b0;
        rde      <=  5'b0;
        immexte  <= 32'b0;
        pcplus4e <= 32'b0;
    end
    else begin
        regwritee   <= regwrited;
        resultsrce  <= resultsrcd;
        memwritee   <= memwrited;
        jumpe       <= jumpd;
        branche     <= branchd;
        alucontrole <= alucontrold;
        alusrce     <= alusrcd;

        rd1e     <= rd1d;
        rd2e     <= rd2d;
        rs1e     <= rs1d;
        rs2e     <= rs2d;
        pce      <= pcd;
        rde      <= rdd;
        jalre    <= jalrd;
        immexte  <= immextd;
        pcplus4e <= pcplus4d;
    end
```
The first two pipeline registers have a ```clear``` signal to act as our ```flush``` signal to avoid any ```Data``` or ```Control``` hazards which will be further explained in the hazard unit page.
```verilog

// pipe execute
always_ff @(posedge clk) begin
    regwritem  <= regwritee;
    resultsrcm <= resultsrce;
    memwritem  <= memwritee;
    
    aluresultm <= aluresulte;
    writedatam <= writedatae;
    rdm        <= rde;
    pcplus4m   <= pcplus4e;
end

// pipe memory
always_ff @(posedge clk) begin  
    regwritew  <= regwritem;
    resultsrcw <= resultsrcm;

    aluresultw <= aluresultm;
    readdataw  <= readdatam;
    rdw        <= rdm;
    pcplus4w   <= pcplus4m;
end
```
Unlike the initial two registers, the final two do not required any control signals but simply acted a flip flop but for multiple signals of different lengths. 