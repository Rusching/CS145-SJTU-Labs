`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 08:56:47
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] ALUCtr,
    input [31:0] input1,
    input [31:0] input2,
    output reg zero,
    output reg [31:0] ALURes
    );
    always @ (ALUCtr or input1 or input2)
    begin
        case(ALUCtr)
            4'b0010:
            //add
                begin
                    ALURes = input1 + input2;
                end
            4'b0110:
            //sub
                begin
                    ALURes = input1 - input2;
                    if (ALURes == 0)
                        zero = 1;
                    else
                        zero = 0;
                end
            4'b0000:
            //and
                begin
                    ALURes = input1 & input2;
                    if (ALURes == 0)
                        zero = 1;
                    else
                        zero = 0;
                end
            4'b0001:
            //or
                begin
                    ALURes = input1 | input2;
                    if (ALURes == 0)
                        zero = 1;
                    else
                        zero = 0;
                end
            4'b0111:
            //slt
                begin
                    if(input1<input2)
                        ALURes=1;
                    else
                        ALURes=0;
                    if (ALURes == 0)
                        zero = 1;
                    else
                        zero = 0;
                end
            4'b1100:
            //nor
                begin
                    ALURes=~(input1|input2);
                    if (ALURes == 0)
                        zero = 1;
                    else
                        zero = 0;
                end
        endcase
    end
endmodule
