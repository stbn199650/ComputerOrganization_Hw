// Controller

module Controller ( opcode,
					funct,
					// write your code in here					
					ALUOp,		//select ALU					
					Branch,		//beq,bne
					Jr,
					Jump,
					Jal,					
					MemWrite,	//write data into memory
					MemtoReg,	//read data from memory 
					RegWrite,	//Result=1,go to Regfile	
					RegDst,		//RegDst==1,write in rd,else write in rt										
					Extend_h);	//lh,sh

	input  [5:0] opcode;
    input  [5:0] funct;

	// write your code in here
	output [3:0] ALUOp;	
	output Branch, MemWrite, MemtoReg, RegWrite, Jr, Jump, Jal, RegDst, Extend_h;
	
	reg [3:0] ALUOp;	
	reg Branch, MemWrite, MemtoReg, RegWrite, Jr, Jump, Jal, RegDst, Extend_h;		
	
	always @ (*)
	begin		
		RegDst <= 0;
		Extend_h <= 0;
		Branch <= 0; 
		MemWrite <= 0;
		MemtoReg <= 0;
		RegWrite <= 1;
		Jr <= 0;
		Jump <= 0;
		Jal <= 0;
		case(opcode)		
			6'b000000:	//R-type MIPS
			begin			
			case(funct)				
				6'b100000:					//add
				begin
					ALUOp = 4'b0001;
					RegDst <= 1;					
				end
				6'b100010:					//sub
				begin
					ALUOp = 4'b0010;					
					RegDst <= 1;
				end
				6'b100100:					//and
				begin
					ALUOp = 4'b0011;	
					RegDst <= 1;
				end
				6'b100101:					//or
				begin
					ALUOp = 4'b0100;
					RegDst <= 1;
				end
				6'b100110:					//xor
				begin
					ALUOp = 4'b0101;
					RegDst <= 1;
				end	
				6'b100111:					//nor
				begin
					ALUOp = 4'b0110;	
					RegDst <= 1;
				end
				6'b101010:					//slt
				begin
					ALUOp = 4'b0111;
					RegDst <= 1;
					Branch <= 1;
				end
				6'b000000:					//shift left
				begin
					ALUOp = 4'b1000;	
					RegDst <= 1;
				end
				6'b000010:					//shift right
				begin
					ALUOp = 4'b1001;	
					RegDst <= 1;
				end	
				6'b001000:					//jr
				begin						
					RegWrite <= 0;
					Jr <= 1;										
				end
				6'b001001:					//jalr
				begin						
					Jr <= 1;					
					Jal <= 1;
				end
			endcase	
			end		
			
			//I-type MIPS
			6'b001000:		//addi
			begin			
				ALUOp <= 4'b0001;
				RegDst <= 0;
			end
			6'b001100:		//andi
			begin
				ALUOp <= 4'b0011;
				RegDst <= 0;
			end
			6'b001010:		//slti
			begin
				ALUOp <= 4'b0111;
				RegDst <= 0;
				Branch <= 1;				
			end
			6'b000100:		//beq
			begin
				ALUOp <= 4'b1010;
				RegDst <= 0;
				Branch <= 1;	
				RegWrite <= 0;			
			end
			6'b000101:		//bne
			begin
				ALUOp <= 4'b1011;	
				RegDst <= 0;
				Branch <= 1;
				RegWrite <= 0;				
			end
			6'b100011:		//lw
			begin	
				ALUOp <= 4'b0001; 	
				MemtoReg <= 1;				
				RegDst <= 0;
			end
			6'b100001:		//lh
			begin
				ALUOp <= 4'b0001; 				
				MemtoReg <= 1;				
				RegDst <= 0;
				Extend_h <= 1;
			end			
			6'b101011:		//sw
			begin		
				ALUOp <= 4'b0001; 
				MemWrite <= 1;				
				RegWrite <= 0;	
			end
			6'b101001:		//sh
			begin	
				ALUOp <= 4'b0001;				
				MemWrite <= 1;				
				RegWrite <= 0;				
				Extend_h <= 1;
			end
			
			//J-type MIPS
			6'b000010:		//j
			begin					
				RegWrite <= 0;	
				Jump <= 1;		
			end
			6'b000011:		//jal
			begin					
				Jump <= 1;
				Jal <= 1;					
			end	
		endcase
	end
	
endmodule




