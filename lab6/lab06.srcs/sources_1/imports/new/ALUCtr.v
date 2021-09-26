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
    input [3:0] ALUOp,
    input [5:0] Funct,
    output reg [3:0] ALUCtrOut
    );
    always @(ALUOp or Funct)
    begin
        casex ({ALUOp, Funct})
            // R
            10'b1000100000: ALUCtrOut = 4'b0010; //add
            10'b1000100010: ALUCtrOut = 4'b0110; //sub
            10'b1000100100: ALUCtrOut = 4'b0000; //and
            10'b1000100101: ALUCtrOut = 4'b0001; //or
            10'b1000101010: ALUCtrOut = 4'b0111; //slt
            10'b1000000000: ALUCtrOut = 4'b0100; //sll
            10'b1000000010: ALUCtrOut = 4'b0101; //srl
            // I
            10'b0001xxxxxx: ALUCtrOut = 4'b0010; //addi
            10'b0010xxxxxx: ALUCtrOut = 4'b0000; //andi
            10'b0011xxxxxx: ALUCtrOut = 4'b0001; //ori
            10'b0100xxxxxx: ALUCtrOut = 4'b0010; //lw
            10'b0101xxxxxx: ALUCtrOut = 4'b0010; //sw
            10'b0110xxxxxx: ALUCtrOut = 4'b0110; //beq
            //j, jr, jal don't need alu operate

            default: ALUCtrOut = 4'b0000;
        endcase
    end
endmodule
