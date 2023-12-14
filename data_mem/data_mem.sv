// verilator lint_off UNUSED
module data_mem #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32,
              MEM_SIZE = 131080,  // in bytes
              BYTE_WIDTH = 8
)(   
    input  logic                     clk,        // only for writing to data_mem
    
    input  logic [ADDRESS_WIDTH-1:0] a,          // the address that comes from ALUResult irrespective we are loading or storing
    input  logic                     we,         // write enable flag
    input  logic [DATA_WIDTH-1:0]    writedata,  // data to write to memoory
    input  logic [2:0]               memcontrol, // describes exact load/store instruction to execute (is from funct3 of load/store instructionss)

    output logic [DATA_WIDTH-1:0] readdata // data read from the memory
);   

logic [BYTE_WIDTH-1:0] data_memory [MEM_SIZE-1:0]; // ram array

logic [ADDRESS_WIDTH-1:0] baseaddress_half;
logic [ADDRESS_WIDTH-1:0] baseaddress_word;

assign baseaddress_half = a & ~(ADDRESS_WIDTH'('b1));
assign baseaddress_word = a & ~(ADDRESS_WIDTH'('b11));

// program ram with contents of .mem file
initial begin
    $display("Loading ram...");
    //$readmemh("data_mem.mem", data_memory); // NOTE: include a blank line after final line of data (otherwise the last byte is not read- at least that's what the testbench for this module implies)
    $readmemh("mem_files/sine.mem", data_memory, 20'h10000);
end;

// synchronously write data
always_ff @(posedge clk) begin
    if (we) begin
        case (memcontrol)
            3'b000: data_memory[a] <= writedata[BYTE_WIDTH-1 : 0];                // store byte          
            
            3'b001: begin                                                         // store half
                { data_memory[baseaddress_half + 1] , data_memory[baseaddress_half] } <= writedata[2*BYTE_WIDTH-1 : 0];
            end
            
            3'b010: begin                                                         // store word
                { data_memory[baseaddress_word + 3] , data_memory[baseaddress_word + 2] , data_memory[baseaddress_word + 1] , data_memory[baseaddress_word] } <= writedata[31:0];
            end
            
            default: data_memory[MEM_SIZE-1] <= {BYTE_WIDTH{1'b1}};  // (should never execute) write all 1s to byte in highest memory address
        endcase
    end

end

// asynchronously load data 
always_comb begin
    case (memcontrol)
        3'b000: readdata = { {(BYTE_WIDTH*3){data_memory[a][BYTE_WIDTH-1]}}  ,  data_memory[a]}; // load byte

        3'b100: readdata = { {(BYTE_WIDTH*3){1'b0}}                          ,  data_memory[a]}; // load byte unsigned

        3'b001, 3'b101: begin                                                                    // load half, load half unsigned
            readdata = (memcontrol[2]) ?
                       { {(BYTE_WIDTH*2){1'b0}},                                            data_memory[baseaddress_half + 1], data_memory[baseaddress_half] } :
                       { {(BYTE_WIDTH*2){data_memory[baseaddress_half + 1][BYTE_WIDTH-1]}}, data_memory[baseaddress_half + 1], data_memory[baseaddress_half] };
        end

        3'b010: begin                                                                           // load word
            readdata = { data_memory[baseaddress_word + 3] , data_memory[baseaddress_word + 2] , data_memory[baseaddress_word + 1] , data_memory[baseaddress_word] };           
        end

        default readdata = 32'hdeadbeef; // (should never execute) output deadbeef
    endcase
end

endmodule
// verilator lint_on UNUSED
