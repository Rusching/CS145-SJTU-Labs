`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 10:04:10
// Design Name: 
// Module Name: Signext
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


module Signext(
    input [15:0] inst,
    output [31:0] data
    );
    
    assign data = (inst[15])?(inst|32'hffff0000):(inst|32'h00000000);
endmodule
