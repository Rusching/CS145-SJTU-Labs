`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 15:25:48
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
    
    // inst
    reg [31:0] inst, inst_id;  
    reg [31:0] mem_inst[35:0];       

    // registers for idex
    reg [3:0] alu_ctr_out_idex;
    reg [31:0] reg_read_data1_ex, reg_read_data2_ex, imm_ext_idex;
    reg [4:0] dst_reg_idex, shamt_idex, reg_rs_ex, reg_rt_ex;
    reg mem_read_idex, mem_write_idex, mem_to_reg_idex, reg_write_idex, alu_src_idex, shift_flag_idex;
    
    // registers for exmem
    reg [31:0] reg_read_data2_exmem, alu_res_exmem;
    reg [4:0] dst_reg_exmem;
    reg mem_read_exmem, mem_write_exmem, mem_to_reg_exmem, reg_write_exmem, zero_exmem;

    // registers for memwb
    reg [31:0] alu_res_memwb, mem_read_data_memwb;
    reg [4:0] dst_reg_memwb;
    reg mem_to_reg_memwb, reg_write_memwb;

    // PC
    reg [31:0] PC, PC_ifid, PC_idex, PC_exmem, PC_memwb;
    
    // jal instruction
    reg jal_idex, jal_exmem, jal_memwb;
    
    // read instruction to InstMemory
    initial begin
        $readmemb("mem_inst.txt", mem_inst ,0);
        PC <= 0;
        inst = 0;
    end
    
    // reset
    always @ (Clk)
    begin
        if(reset)
        begin
            PC <= 0; inst_id <= 0; inst <= 0;
            mem_read_idex <= 0; mem_write_idex <= 0; mem_to_reg_idex <= 0; reg_write_idex <= 0; alu_src_idex <= 0; 
            imm_ext_idex <= 0; dst_reg_idex <= 0; shamt_idex <= 0; reg_rs_ex <= 0; reg_rt_ex <= 0; jal_idex <= 0;
            mem_read_exmem <= 0; mem_write_exmem <= 0; mem_to_reg_exmem <= 0; reg_write_exmem <= 0; jal_exmem <= 0;
            mem_to_reg_memwb <= 0; reg_write_memwb <= 0; jal_memwb <= 0; mem_read_data_memwb <= 0; alu_res_memwb <= 0; dst_reg_memwb <= 0;
        end
    end
    
    // instruction fetch
    wire [31:0] jump_address, branch_res, PC_plus4, PC_next_origin, PC_next;
    reg stall, flush; 
    always@ (posedge Clk)  
    begin
        if(reset)
            PC<=0;
        else
            if(!stall && !flush)
                PC <= PC_next; 
            else PC <= PC_plus4; 
        inst <= mem_inst[PC>>2];
    end

    // instruction decode
    wire [31:0] reg_read_data1, reg_read_data2, imm_ext, write_data_reg, write_data_reg_origin;
    wire [4:0] write_reg;
    wire [3:0] alu_op, alu_ctr_out;
    wire reg_dst, jump, mem_read, mem_to_reg, mem_write, alu_src, reg_write_id, reg_write, branch;
    
    // instantiate Ctr module
    Ctr ctr(
        .OpCode(inst_id[31:26]),
        .RegDst(reg_dst),
        .ALUSrc(alu_src),
        .MemToReg(mem_to_reg),
        .RegWrite(reg_write_id),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .Branch(branch),
        .ALUOp(alu_op),
        .Jump(jump)
    );
    
    // instantiate Registers module
    Registers registers(
        .reset(reset),
        .ReadReg1(inst_id[25:21]),
        .ReadReg2(inst_id[20:16]),
        .WriteReg(write_reg),    
        .WriteData(write_data_reg),          
        .RegWrite(reg_write),
        .ReadData1(reg_read_data1),
        .ReadData2(reg_read_data2),
        .Clk(Clk)
    );

    // instantiate Signext module
    Signext signext(
        .inst(inst_id[15:0]),
        .data(imm_ext)
    );

    // instantiate ALUCtr module
    ALUCtr aluCtr(
        .ALUOp(alu_op),
        .Funct(inst_id[5:0]),
        .ALUCtrOut(alu_ctr_out)
    );

    // detect stall for competition
    wire load_flag = mem_to_reg_idex & reg_write_idex;  
    always @(inst_id or load_flag or reg_write_idex)
    begin
        stall <= 0;
        if(load_flag  && inst_id[31:26] == 6'b000000)
            if(inst_id[25:21] == dst_reg_idex || inst_id[20:16] == dst_reg_idex)
                stall <= 1;
    end

    // detect shift for srl, sll instruction
    reg shift_flag;
    always @ (inst)
    begin
        shift_flag <= 0;
        if(inst_id[31:26] == 6'b000000)
            if(inst_id[5:0] == 6'b000000)
                shift_flag <= 1;
            else if(inst_id[5:0] == 6'b000010)
                shift_flag <= 1;
    end
    
    // determin whether rs == rt
    wire rs_rt_qual_flag, jal;
    assign rs_rt_qual_flag = reg_read_data1==reg_read_data2 ? 1:0;
    
    // jal instruction
    assign jal = (inst_id[31:26] == 6'b000011) ? 1:0;   
    assign write_data_reg = jal_memwb? PC_memwb : write_data_reg_origin; 
    assign reg_write = reg_write_memwb;
    assign write_reg = jal_memwb? 31 : dst_reg_memwb;

    assign PC_plus4 = PC + 4;
    assign jump_address = {PC_plus4[31:28],inst_id[25:0]<<2};
    // beq instruction
    assign branch_res =(branch == 1 & rs_rt_qual_flag) ? (imm_ext<<2)+PC_plus4 : PC_plus4;       
    
    // jump instruction
    assign PC_next_origin = jump ? jump_address : branch_res;                              
    
    // jr instruction
    assign PC_next = ({inst_id[31:26], inst_id[5:0]} == 12'b000000_001000) ? reg_read_data1 : PC_next_origin;

    // detect flush for predict not taken
    always@(inst_id or rs_rt_qual_flag)
    begin
        flush <= 0;
        if(inst_id[31:26] == 6'b000010)
            flush <= 1;
        else if(inst_id[31:26] == 6'b000011)
            flush <= 1;
        else if(inst_id[31:26] == 6'b000000 && inst_id[5:0] == 6'b001000)
            flush <= 1;
        else if(inst_id[31:26] == 6'b000100 && rs_rt_qual_flag)
            flush <= 1;
        else if(inst_id[31:26] == 6'b000101 && !rs_rt_qual_flag)
            flush <= 1;
    end

    

    // forward part
    always@(reg_rs_ex or dst_reg_exmem or reg_write_exmem or mem_to_reg_exmem or reg_rt_ex or dst_reg_memwb or reg_write_memwb or mem_to_reg_memwb)
    begin
        if(reg_rs_ex == dst_reg_exmem && reg_write_exmem && !mem_to_reg_exmem) 
            reg_read_data1_ex <= alu_res_exmem;
        else if(reg_rt_ex == dst_reg_exmem && reg_write_exmem && !mem_to_reg_exmem)
            reg_read_data2_ex <= alu_res_exmem;
        else if(reg_rs_ex == dst_reg_memwb && reg_write_memwb && !mem_to_reg_memwb) 
            reg_read_data1_ex <= alu_res_memwb;
        else if(reg_rt_ex == dst_reg_memwb && reg_write_memwb && !mem_to_reg_memwb)
            reg_read_data2_ex <= alu_res_memwb;
        else if(reg_rs_ex == dst_reg_memwb && reg_write_memwb && mem_to_reg_memwb) 
            reg_read_data1_ex <= mem_read_data_memwb;
        else if(reg_rt_ex == dst_reg_memwb && reg_write_memwb && mem_to_reg_memwb) 
            reg_read_data2_ex <= mem_read_data_memwb;
    end

    // instantiate ALU module
    wire [31:0] alu_res, input1, input2;
    wire zero;
    assign input1 = !shift_flag_idex ? reg_read_data1_ex : shamt_idex;
    assign input2 = alu_src_idex? imm_ext_idex : reg_read_data2_ex;
    ALU alu(
        .ALUCtr(alu_ctr_out_idex),
        .input1(input1),
        .input2(input2),
        .zero(zero),
        .ALURes(alu_res)
    );

    // instantiate DataMemory module
    wire [31:0] mem_read_data;
    DataMemory datamemory(
        .Clk(Clk),
        .address(alu_res_exmem),
        .WriteData(reg_read_data2_exmem),
        .MemWrite(mem_write_exmem),
        .MemRead(mem_read_exmem),
        .ReadData(mem_read_data)
    );

    // write back
    assign write_data_reg_origin = mem_to_reg_memwb? mem_read_data_memwb : alu_res_memwb;
    
    // pass back pipline registers
    
    // registers -> ifid
    always@ (posedge Clk)  
    begin
        if(flush)
            inst_id <= 0;
        else if(!stall) begin
            PC_ifid <= PC;
            inst_id <= inst;
        end
    end
    
    // ifid -> idex
    always@ (posedge Clk)  
    begin
        if(stall == 0)
        begin
            mem_read_idex <= mem_read;
            mem_write_idex <= mem_write;
            mem_to_reg_idex <= mem_to_reg;
            reg_write_idex <= reg_write_id;
            dst_reg_idex <= reg_dst ? inst_id[15:11] : inst_id[20:16];
            reg_read_data1_ex <= reg_read_data1;
            reg_read_data2_ex <= reg_read_data2;
            alu_src_idex <= alu_src;
            reg_rs_ex <= inst_id[25:21];
            reg_rt_ex <= inst_id[20:16];
            shift_flag_idex <= shift_flag;
            shamt_idex <= inst_id[10:6];
            imm_ext_idex <= imm_ext;
            alu_ctr_out_idex <= alu_ctr_out;
            jal_idex <= jal;
            PC_idex <= PC_ifid;
        end
        else begin
            reg_write_idex <= 0;
            mem_to_reg_idex <= 0;
            mem_write_idex <= 0;
            shift_flag_idex <= 0;
            jal_idex <= 0;
        end
    end
    
    // idex -> exmem
    always@ (posedge Clk)  
    begin
        mem_read_exmem <= mem_read_idex;
        mem_write_exmem <= mem_write_idex;
        mem_to_reg_exmem <= mem_to_reg_idex;
        reg_write_exmem <= reg_write_idex;
        reg_read_data2_exmem <= reg_read_data2_ex;
        alu_res_exmem <= alu_res;
        zero_exmem <= zero;
        jal_exmem <= jal_idex;
        dst_reg_exmem <= dst_reg_idex;
        PC_exmem <= PC_idex;
    end
    
    // exmem -> memwb
    always@ (posedge Clk)  
    begin
        mem_to_reg_memwb <= mem_to_reg_exmem;
        reg_write_memwb <= reg_write_exmem;
        alu_res_memwb <= alu_res_exmem;
        mem_read_data_memwb <= mem_read_data;
        dst_reg_memwb <= dst_reg_exmem;
        jal_memwb <= jal_exmem;
        PC_memwb <= PC_exmem;
    end

endmodule
