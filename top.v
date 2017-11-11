// top
`include "Add.v"
`include "ALU.v"
`include "Controller.v"
`include "Jump_Ctrl.v"
`include "Mux2to1.v"
`include "Mux4to1.v"
`include "PC.v"
`include "Regfile.v"
`include "Sign_Extend.v"

module top ( clk,
             rst,
			 // Instruction Memory
			 IM_Address,
             Instruction,
			 // Data Memory
			 DM_Address,
			 DM_enable,
			 DM_Write_Data,
			 DM_Read_Data);

	parameter data_size = 32;
	parameter mem_size = 16;	

	input  clk, rst;
	
	// Instruction Memory
	output [mem_size-1:0] IM_Address;	
	input  [data_size-1:0] Instruction;

	// Data Memory
	output [mem_size-1:0] DM_Address;
	output DM_enable;
	output [data_size-1:0] DM_Write_Data;	
    input  [data_size-1:0] DM_Read_Data;
	
	// write your code here
	
	// ALU
	wire [3:0] ALUOp;
	wire [data_size-1:0] src;
	wire [4:0] shamt;
	wire [data_size-1:0] ALU_out;
	wire Zero;
	
	// PC
	parameter PC_size=18;
	wire [PC_size-1:0] PCin;
	wire [PC_size-1:0] PC_add1;
	wire [PC_size-1:0] PC_add2;
	wire [PC_size-1:0] PCout;
	wire [PC_size-1:0] PCout2;
	
	// Sign_Extend
	wire [mem_size-1:0]imm_ins;			//16 bit	
	wire [data_size-1:0] imm_Extend; 	//32 bit
	
	// Controller
	wire [5:0] opcode;
	wire [5:0] funct;	
	wire Branch;	
	wire Jr;	
	wire Jump;	
	wire Jal;	
	wire MemWrite;
	wire MemtoReg;
	wire RegWrite;	
	wire RegDst;
	wire Extend_h;
	
	// Regfile
	wire [4:0] Rs;	
	wire [4:0] Rt;	
	wire [4:0] Rd;
	wire [4:0] R_out;
	wire [data_size-1:0] Rs_data;	
	wire [data_size-1:0] Rt_data;	
	wire [4:0] Write_addr;
	wire [data_size-1:0] Write_data;	
	
	// Jump_Ctrl	
	wire [1:0] JumpOP;	
	
	wire [data_size-1:0] Write_Back;
	
	/*************************************************************************/
	////// Connect Wire //////		
	
	// ALU
	assign opcode = Instruction[31:26];
	assign shamt = Instruction[10:6];		//shift
	assign funct = Instruction[5:0];		
	// Register
	assign Rs = Instruction[25:21];
	assign Rt = Instruction[20:16];
	assign Rd = Instruction[15:11];		
	assign imm_ins = Instruction[15:0];		//immediate
	// IM
	assign IM_Address = PCout[17:2];	
	//DM
	assign DM_Address = ALU_out[17:2];	
	assign DM_enable = MemWrite;
	assign DM_Write_Data = Rt_data;		
	
	/*************************************************************************/
	////// Single Cycle CPU //////
	
	PC#(PC_size) PC( .clk(clk), 		//PC
					 .rst(rst),
					 .PCin(PCin), 
					 .PCout(PCout));	
	
	Add#(PC_size) Add4_1( .In1(PCout),		//PC+4
						  .In2(18'd4),
						  .out(PC_add1));
	
	Add#(PC_size) Add4_2( .In1(PC_add1),	//PC+4
						  .In2(18'd4),
						  .out(PC_add2));
	
	Controller control( .opcode(opcode),
						.funct(funct),
						.ALUOp(ALUOp),			//controller's output,ALU's input
						.Branch(Branch),
						.Jr(Jr),
						.Jump(Jump),
						.Jal(Jal),						
						.MemWrite(MemWrite),
						.MemtoReg(MemtoReg),
						.RegWrite(RegWrite),	//controller's output,regfile's input
						.RegDst(RegDst),
						.Extend_h(Extend_h));		
						
	//choose Rt or Rd to write
	Mux2to1#(5) mux_Reg1( .select(RegDst),		//if RegDst==1,write in Rd , else write in Rd
						  .In1(Rt),
						  .In2(Rd),
						  .out(R_out));
	
	//Jal==1,write in register[31], else write in register[Rt] or register[Rd]
	Mux2to1#(5) mux_Reg2( .select(Jal),			
						  .In1(R_out),
						  .In2(5'd31),
						  .out(Write_addr));	
	
	Mux2to1#(data_size) mux_Reg_WD( .select(Jal),			//Jal==1,PC+4
									.In1(Write_Back),
									.In2({14'b0,PC_add2}),
									.out(Write_data));	

	//register
	Regfile register( .clk(clk),			
					  .rst(rst),
					  .Read_addr_1(Rs),
					  .Read_addr_2(Rt),
					  .Read_data_1(Rs_data),
					  .Read_data_2(Rt_data),
					  .RegWrite(RegWrite),	
					  .Write_addr(Write_addr),	//mux2's output
					  .Write_data(Write_data));
	
	Sign_Extend extend( .in(imm_ins),			//for I-type, imm_ins is 16 bit,but ALU is 32 bit
						.out(imm_Extend));
						
	//RegDst==1,R-type=>Rs+Rt, RegDst==0,I-type=>Rs+imm
	Mux2to1#(data_size) mux_ALU( .select(RegDst),
								 .In1(imm_Extend),	
								 .In2(Rt_data),	
								 .out(src));  
								 
	ALU alu( .ALUOp(ALUOp),
			 .src1(Rs_data),
			 .src2(src),
			 .shamt(shamt),
			 .ALU_result(ALU_out),
			 .Zero(Zero));	
	//lw or lh
	Mux2to1#(data_size) mux_DM_WD( 	.select(Extend_h && MemWrite),
									.In1(Rt_data),
									.In2({{16{Rt_data[15]}},Rt_data[15:0]}),
									.out(DM_Write_Data));
	
	//sw or sh
	Mux2to1#(data_size) mux_DM_RD(	.select(Extend_h && MemtoReg),
									.In1(DM_Read_Data),
									.In2({{16{DM_Read_Data[15]}},DM_Read_Data[15:0]}),
									.out(DM_Read_Data));
									
	//take sign_extend[15:0],and add 2 zero in the last(shift left 2 bits)	
	Add#(PC_size) add_mux4to1( 	.In1({imm_Extend[15:0],2'b0}),	//PC=PC+4
								.In2(PC_add1),
								.out(PCout2));	//Branch Address
	
	Jump_Ctrl jump( .Zero(Zero),
					.Branch(Branch),
					.Jump(Jump),
					.Jump_Addr(Jr),
					.JumpOP(JumpOP));	
	
	Mux4to1#(PC_size) mux4( .select(JumpOP),	
							.In1(PC_add1),
							.In2(PCout2),
							.In3(Rs_data[PC_size-1:0]),
							.In4({{imm_ins},2'b0}),
							.out(PCin));		
	
	// Write data back 
	Mux2to1#(data_size) mux_ALU_DM( .select(MemtoReg),		//MemtoReg==1,
									.In1(ALU_out),
									.In2(DM_Read_Data),
									.out(Write_Back));
	
endmodule





