`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 10:04:22
// Design Name: 
// Module Name: Registers_tb
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


module Registers_tb(

    );
    reg [25:21] ReadReg1;
    reg [20:16] ReadReg2;
    reg [4:0] WriteReg;
    reg [31:0] WriteData;
    reg RegWrite;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    reg Clk;
    reg reset;
    Registers registers(
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .RegWrite(RegWrite),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .Clk(Clk),
        .reset(reset)
    );
    parameter PERIOD=100;
    always # PERIOD Clk=!Clk;
    initial begin
        Clk = 1'b0;
        reset = 1'b1;
        WriteReg = 5'b0;
        WriteData = 32'b0;
        RegWrite = 1'b0;
        ReadReg1 = 5'b0;
        ReadReg2 = 5'b0;
        
        
        #285;
        RegWrite = 1'b1;
        WriteReg = 5'b10101;
        WriteData = 32'b11111111111111110000000000000000;
        
        #200;
        WriteReg = 5'b01010;
        WriteData = 32'b00000000000000001111111111111111;
        
        #200;
        RegWrite = 1'b0;
        WriteReg = 5'b00000;
        WriteData = 32'b00000000000000000000000000000000;
        
        #50;
        ReadReg1 = 5'b10101;
        ReadReg2 = 5'b01010;     
    end 
endmodule
