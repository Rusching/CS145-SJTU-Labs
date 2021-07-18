`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 10:04:46
// Design Name: 
// Module Name: Signext_tb
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


module Signext_tb(

    );
    reg [15:0] inst;
    wire [31:0] data;
    Signext signext(
        .inst(inst),
        .data(data)
    );
    initial begin
        inst = 16'h0000;
        
        #100; inst=16'h0001;
        
        #100; inst=16'hffff;
        
        #100; inst=16'h0002;
        
        #100; inst=16'hfffe;
        
    end
    
endmodule
