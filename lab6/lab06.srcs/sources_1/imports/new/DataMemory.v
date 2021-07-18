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
    output reg [31:0] ReadData
    );
    reg [31:0] MemFile[31:0];
    initial
    begin 
        $readmemb("mem_data.txt",MemFile);  
    end
    
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
      
endmodule
