`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 10:04:34
// Design Name: 
// Module Name: DataMemory_tb
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


module DataMemory_tb(
    
    );
    reg Clk;
    reg [31:0] address;
    reg [31:0] WriteData;
    reg MemWrite;
    reg MemRead;
    reg reset;
    wire [31:0] ReadData;
    DataMemory dataMemory(
        .Clk(Clk),
        .address(address),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .reset(reset),
        .ReadData(ReadData)
    );
    parameter PERIOD=100;
    always # PERIOD Clk=!Clk;
    initial begin
        Clk = 1'b0;
        reset = 1'b1;
        address = 32'b0;
        WriteData = 32'b0;
        MemWrite = 1'b0;
        MemRead = 1'b0;
        #185;
        MemWrite = 1'b1;
        address = 32'b00000000000000000000000000000111;
        WriteData = 32'b11100000000000000000000000000000;
        
        #100;
        MemWrite = 1'b1;
        WriteData = 32'hffffffff;
        address = 32'b00000000000000000000000000000110;
        
        #185;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        address = 7;
        
        #80;
        MemWrite = 1'b1;
        address = 8;
        WriteData = 32'haaaaaaa;
        
        #80;
        address = 6;
        MemWrite = 0;
        MemRead = 1;
        
    end
endmodule
