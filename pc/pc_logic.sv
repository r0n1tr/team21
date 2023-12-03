module pc_logic(
    input logic jump,
    input logic branch,
    input logic zeroe,

    output logic pcsrce
);
    assign pcscre = (branch & zeroe) | jump;
    
endmodule
