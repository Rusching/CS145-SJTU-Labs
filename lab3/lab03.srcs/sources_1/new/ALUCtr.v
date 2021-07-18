`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 08:57:17
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [1:0] ALUOp,
    input [5:0] Funct,
    output reg [3:0] ALUCtrOut
    );
    always @(ALUOp or Funct)
    begin
        casex ({ALUOp, Funct})
            8'b00xxxxxx : ALUCtrOut = 4'b0010;
            8'bx1xxxxxx : ALUCtrOut = 4'b0110;
            8'b1xxx0000 : ALUCtrOut = 4'b0010;
            8'b1xxx0010 : ALUCtrOut = 4'b0110;
            8'b1xxx0100 : ALUCtrOut = 4'b0000;
            8'b1xxx0101 : ALUCtrOut = 4'b0001;
            8'b1xxx1010 : ALUCtrOut = 4'b0111;
            default: ALUCtrOut = 4'b0000;
        endcase
    end
endmodule
