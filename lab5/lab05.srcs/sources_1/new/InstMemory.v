`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/26 08:22:03
// Design Name: 
// Module Name: InstMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstMemory(
    input [31:0] ReadAddress,
    output reg [31:0] Inst
    );
    reg [31:0] MemFile[0:63];
    initial begin
        $readmemb("mem_inst.txt",MemFile);
    end
    
    always @(ReadAddress)
        begin
            Inst = MemFile[ReadAddress>>2];
        end

endmodule
