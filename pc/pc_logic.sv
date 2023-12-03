module pc_logic(
    input logic jump,
    input logic branch,
    input logic zeroe,

    output logic pcsrce
);
    assign pcsrce = (branch & zeroe) | jump;
    
endmodule
