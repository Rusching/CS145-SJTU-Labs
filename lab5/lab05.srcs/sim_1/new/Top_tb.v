`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 14:52:51
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
    reg Clk, reset;
    Top top(.Clk(Clk),
            .reset(reset));
    
    always #50 Clk = !Clk;
    
    initial begin
        Clk = 0;
        reset = 1;
        #50
        reset = 0;
        
        
    end
endmodule
