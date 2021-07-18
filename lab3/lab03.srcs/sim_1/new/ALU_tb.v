`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 08:57:36
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );
    reg [3:0] ALUCtr;
    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] ALURes;
    wire zero;
    ALU alu(
        .ALUCtr(ALUCtr),
        .input1(input1),
        .input2(input2),
        .ALURes(ALURes),
        .zero(zero)
    );
    initial begin
        ALUCtr = 0;
        input1 = 0;
        input2 = 0;
        #100; input1=15;input2=10;
        #100; ALUCtr=4'b0001;
        #100; ALUCtr=4'b0010;
        #100; ALUCtr=4'b0110;
        #100; input1=10;input2=15;
        #100; ALUCtr=4'b0111;input1=15;input2=10;
        #100; input1=10;input2=15;
        #100; ALUCtr=4'b1100;input1=1;input2=1;
        #100;input1=16;
        
    end    
endmodule
