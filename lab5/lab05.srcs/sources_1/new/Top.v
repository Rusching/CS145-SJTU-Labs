`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/26 08:19:52
// Design Name: 
// Module Name: Top
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


module Top(
    input Clk,
    input reset
    );
    //PC
    reg [31:0] PC;
    // initial PC to zero
    initial begin
        PC <= 0;
    end
    wire [31:0] PC_plus4, PC_next;
    // PC_plus4 is PC  4
    assign PC_plus4 = PC + 4;
    
    // InstMemory module
    wire [31:0] inst;
    InstMemory inst_memory(.ReadAddress(PC),
            .Inst(inst));
    
    // Ctr module
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    wire [3:0] alu_op; 
    Ctr ctr(.OpCode(inst[31:26]),
            .RegDst(reg_dst),
            .ALUSrc(alu_src),
            .MemToReg(mem_to_reg),
            .RegWrite(reg_write),
            .MemRead(mem_read),
            .MemWrite(mem_write),
            .Branch(branch),
            .ALUOp(alu_op),
            .Jump(jump));
    
    // ALUCtr module
    wire [3:0] alu_ctr_out;
    ALUCtr alu_ctr(.ALUOp(alu_op),
            .Funct(inst[5:0]),
            .ALUCtrOut(alu_ctr_out));
    
    // Mux for write_reg        
    wire [4:0] write_reg_origin, write_reg;
    Mux5 write_reg_mux(.Select(reg_dst),
            .input1(inst[15:11]),
            .input2(inst[20:16]),
            .out(write_reg_origin));
    
    
    // select write_reg for jal instruction
    assign write_reg = (inst[31:26] == 6'b000011) ? 31 : write_reg_origin;
    wire [31:0] write_data_reg_origin, read_data_reg1, read_data_reg2, write_data_reg;
    // select write content for jal instruction
    assign write_data_reg = (inst[31:26] == 6'b000011) ? PC : write_data_reg_origin;
    
    // Registers module
    Registers registers(.ReadReg1(inst[25:21]),
            .ReadReg2(inst[20:16]),
            .WriteReg(write_reg),
            .WriteData(write_data_reg),
            .RegWrite(reg_write),
            .ReadData1(read_data_reg1),
            .ReadData2(read_data_reg2),
            .Clk(Clk));
    
    // Signext module
    wire [31:0] imm_ext; 
    Signext signext(.inst(inst[15:0]),
            .data(imm_ext));
    
    // Mux for alu_src
    wire [31:0] alu_src_b;
    Mux32 alu_src_mux(.Select(alu_src),
            .input1(imm_ext),
            .input2(read_data_reg2),
            .out(alu_src_b));
            
    // determine whether there is a left shift or a right shift
    reg shift_flag;
    wire [4:0] shamt;
    assign shamt = inst[10:6];
    
    // set the shift flag
    always @ (inst or shift_flag)
    begin
        if(inst[31:26] == 6'b000000)
            if(inst[5:0] == 6'b000000)
                shift_flag <= 1;
            else if(inst[5:0] == 6'b000010)
                shift_flag <= 1;
            else 
                shift_flag <= 0;    
        else
            shift_flag <= 0;
    end
    
    // ALU module
    wire [31:0] alu_res, input_alu1;
    assign input_alu1 = (shift_flag==0)?read_data_reg1:shamt;
    wire zero;
    ALU alu(.ALUCtr(alu_ctr_out),
            .input1(input_alu1),
            .input2(alu_src_b),
            .zero(zero),
            .ALURes(alu_res));
    
    // DataMemory module
    wire [31:0] read_data_memory;
    DataMemory data_memory(.Clk(Clk),
            .address(alu_res),
            .WriteData(read_data_reg2),
            .MemWrite(mem_write),
            .MemRead(mem_read),
            .ReadData(read_data_memory));
    
    // Mux for reg_write
    Mux32 reg_write_mux(.Select(mem_to_reg),
            .input1(read_data_memory),
            .input2(alu_res),
            .out(write_data_reg_origin));
    
    // Mux for branch
    wire [31:0] jump_address;
    assign jump_address = {PC_plus4[31:28], inst[25:0]<<2};
    
    wire [31:0] branch_address;
    Mux32 branch_mux(.Select(branch&zero),
            .input1((imm_ext<<2)+PC_plus4),
            .input2(PC_plus4),
            .out(branch_address));
    
    // Mux for jump
    wire [31:0] PC_next_origin;
    Mux32 jump_mux(.Select(jump),
            .input1(jump_address),
            .input2(branch_address),
            .out(PC_next_origin)
    );
    
    // select which value for next PC, considered instruction jr
    assign PC_next = ({inst[31:26], inst[5:0]} == 12'b000000_001000) ? read_data_reg1 : PC_next_origin;  
    
    // updata PC
    always @ (posedge Clk)
    begin
        if(reset)
            PC <= 0; 
        else    
            PC <= PC_next;
    end    
endmodule
