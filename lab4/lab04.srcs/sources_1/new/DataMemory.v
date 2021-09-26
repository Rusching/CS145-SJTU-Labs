`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 10:04:00
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] WriteData,
    input MemWrite,
    input MemRead,
    input reset,
    output reg [31:0] ReadData
    );
    reg [31:0] MemFile[0:63];
    integer i;
    always @(MemRead or address or MemWrite)
        begin
            if(MemRead)
                ReadData = MemFile[address];
            else
                ReadData = 32'b0;
        end
    always @(negedge Clk)
        begin
            if(MemWrite)
                MemFile[address]=WriteData;
        end
    always @(reset)
        begin
            if(reset)
                for(i=0;i<32;i=i+1)
                begin
                    MemFile[i]=64'b0;
                end
        end
endmodule

