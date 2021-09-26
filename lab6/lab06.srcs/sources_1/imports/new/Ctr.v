`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 08:13:01
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input [5:0] OpCode,
    output reg RegDst,
    output reg ALUSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] Branch,
    output reg [3:0] ALUOp,
    output reg Jump
    );
    always @(OpCode)
    begin
        case(OpCode)
        6'b000000:
        //R-type
        begin
            RegDst = 1;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b1000;
            Jump = 0;
        end
        6'b001000:
        //addi
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0001;
            Jump = 0;
        end
        6'b001100:
        //andi
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0010;
            Jump = 0;
        end
        6'b001101:
        //ori
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0011;
            Jump = 0;
        end
        
        
        6'b100011:
        //lw
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0100;
            Jump = 0;
        end
        6'b101011:
        //sw
        begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch= 0;
            ALUOp = 4'b0101;
            Jump = 0;
        end
        6'b000100:
        //beq
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch= 2'b10;
            ALUOp = 4'b0110;
            Jump = 0;
        end
        6'b000010:
        //j
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0000;
            Jump = 1;
        end
        6'b000011:
        //jal
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0000;
            Jump = 1;
        end
        
        default:
        //default
        begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch= 0;
            ALUOp = 4'b0000;
            Jump = 0;
        end      
    endcase
    end
endmodule
