# Pipelining registers

Added Files:
- pipe_fetch.sv
- pipe_decode.sv
- pipe_execute.sv
- pipe_memory.sv
- hazard_unit.sv


We implemented 4 synchronous registers with implicit signals omitted. This is to show the logic within each register at each stage of the pipeline in order to reduce time taken for programs to run, there is an always_ff at the posedge of a clock that upadtes output with input. We have also added a 'clear' signal to our first two registers as they are controlled by the hazard unit to either stall or flush the register of its information stored. (control and Data Hazards)


```verilog 
// pipe fetch
always_ff @ (posedge clk) begin
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
end

// pipe decode
always_ff @ (posedge clk) begin
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
end

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
We implemented 4 synchronous registers with implicit signals omitted. This is to show the logic within each register at each stage of the pipeline in order to reduce time taken for programs to run. We have added a 'clear' signal to our first two registers as they are controlled by the hazard unit to either stall or flush the register of its information stored.
