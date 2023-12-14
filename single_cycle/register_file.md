# Register file

```verilog
always_ff @(posedge clk) begin
    if(we3 && ad3 != 5'b0) ram_array[ad3] <= wd3;
end

assign ram_array[5'b0] = 32'b0; // x0 is always zero
assign rd1 = ram_array[ad1];
assign rd2 = ram_array[ad2];
assign a0  = ram_array[5'd10];
```

The regfile was designed to have 3 read ports and two write ports as usual. However, an important design was overlooked which was making register 0 (x0) immutable and set to zero. As a result, this required hours of debugging when using that register as we could not deduce the root cause.