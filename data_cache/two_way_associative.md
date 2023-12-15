## Two-way Associative Cache

We also attempted to make a two-way cache but due to time constraints, we were unable to implement this within our CPU as debugging took longer than expected.
This design was very similar to the One way Cache however we now had half the number of sets but could now store two ways in each set which reduced the number of conflicts. Each set being a 122 bits we initialized them as below : 


```Verilog

logic [121:0] cache_set = cache_memory[din_set];

logic V_way_1 = cache_set[121];
logic [27:0] cache_way_1_tag = cache_set[120:93];   
logic [31:0] cache_way_1_data = cache_set[92:61];

logic V_way_0 = cache_set[60];
logic [27:0] cache_way_0_tag = cache_set[59:32];
logic [31:0] cache_way_0_data = cache_set[31:0];

logic hit_1;
logic hit_0;

assign hit_1 = V_way_1 & (din_tag == cache_way_1_tag);
assign hit_0 = V_way_0 & (din_tag == cache_way_0_tag);

assign hit = hit_0 | hit_1;
```

The only difference now is the replacement policy which relies on an internal flag called u which changes based on which data was most recently retrieved :

```Verilog

else if(hit_1) begin
    dout = cache_way_1_data;
    u = 1'b0;       // least recently used in set is way 0 
 end
 else if(hit_0) begin
    dout = cache_way_0_data;
    u = 1'b1;
 end
 else begin
    dout = din;
    if (u) begin 
        cache_set [121:61] = {1'b1,din[31:4], rd}; 
        cache_memory[din_set] = cache_set;
    end 
    else begin
    cache_set [60:0] = {1'b1,din[31:4], rd};
    cache_memory[din_set] = cache_set;
    end 
 end

```


