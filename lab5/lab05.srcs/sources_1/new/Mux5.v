`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/26 08:20:51
// Design Name: 
// Module Name: Mux5
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


module Mux5(
    input Select,
    input [4:0] input1,
    input [4:0] input2,
    output [4:0] out
    );
    assign out = Select?input1:input2;
endmodule
