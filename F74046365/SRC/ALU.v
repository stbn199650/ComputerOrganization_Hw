// ALU

module ALU ( ALUOp,
			 src1,
			 src2,
			 shamt,
			 ALU_result,
			 Zero);	//beq,bne
	
	parameter bit_size = 32;
	
	input [3:0] ALUOp;
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;
	
	output [bit_size-1:0] ALU_result;
	output Zero;
	
	reg	[bit_size-1:0] ALU_result; 	
	reg	Zero;
			
	// write your code in here
	always @(*)
	begin	
		ALU_result=0;
		case (ALUOp)
		//4'b0000: no operation
		4'b0001: ALU_result = src1+src2;		//add
		4'b0010: ALU_result = src1-src2;		//sub
		4'b0011: ALU_result = src1&src2;		//and
		4'b0100: ALU_result = src1|src2;		//or
		4'b0101: ALU_result = src1^src2;		//xor
		4'b0110: ALU_result = ~(src1|src2);		//nor
		4'b0111: ALU_result = (src1<src2)?1:0;	//slt
		4'b1000: ALU_result = src2<<shamt;		//shift left
		4'b1001: ALU_result = src2>>shamt;		//shift right
		4'b1010: Zero = (src1 == src2)?1:0;		//beq
		4'b1011: Zero = (src1 != src2)?1:0;		//bne		
		default: ALU_result <= 4'b0000;		
		endcase		
		Zero = (ALU_result==0)?1:0;
	end
	
endmodule

