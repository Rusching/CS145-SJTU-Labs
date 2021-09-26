`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 10:03:46
// Design Name: 
// Module Name: Registers
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


module Registers(
    input [25:21] ReadReg1,
    input [20:16] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input RegWrite,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2,
    input Clk
    );
    reg [31:0] RegFiles[31:0];
    
    integer i;
    
    always @(ReadReg1 or ReadReg2 or WriteReg)
        begin
            if (ReadReg1)
                ReadData1 = RegFiles[ReadReg1];
            else
                ReadData1 = 32'b0;
            if (ReadReg2)
                ReadData2 = RegFiles[ReadReg2];
            else
                ReadData2 = 32'b0;
        end
    always @(negedge Clk)
        begin
            if(RegWrite == 1 && WriteReg != 0)
                RegFiles[WriteReg] = WriteData;
        end 
    initial begin
        for(i=0;i<32;i=i+1)
        begin
            RegFiles[i]=32'b0;
        end
    end
endmodule