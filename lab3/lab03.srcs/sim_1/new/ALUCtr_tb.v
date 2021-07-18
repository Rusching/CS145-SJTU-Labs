`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 08:57:56
// Design Name: 
// Module Name: ALUCtr_tb
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


module ALUCtr_tb(
    
    );
    reg [1:0] ALUOp;
    reg [5:0] Funct;
    wire [3:0] ALUCtrOut;
    ALUCtr aluCtr(
        .ALUOp(ALUOp),
        .Funct(Funct),
        .ALUCtrOut(ALUCtrOut)
    );
    initial begin
        ALUOp = 0;
        Funct = 0;
        #100;
        
        #100 ALUOp = 2'b00; Funct = 6'bxxxxxx;
        
        #100 ALUOp = 2'b00; Funct = 6'bxxxxxx;
        
        #100 ALUOp = 2'b01; Funct = 6'bxxxxxx;
        
        #100 ALUOp = 2'b10; Funct = 6'b100000;
        
        #100 ALUOp = 2'b10; Funct = 6'b100010;
        
        #100 ALUOp = 2'b10; Funct = 6'b100100;
        
        #100 ALUOp = 2'b10; Funct = 6'b100101;
        
        #100 ALUOp = 2'b10; Funct = 6'b101010;
      
    end
endmodule
