`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/09 12:16:39
// Design Name: 
// Module Name: Top_tb
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


module Top_tb(

    );
    reg clk, reset;
    always #20 clk = !clk;
    Top top(
        .Clk(clk),
        .reset(reset)
    );
    initial begin
        clk = 1;
        reset = 1;
        #40 reset = 0;
        #3000 reset = 1;
    end
endmodule
