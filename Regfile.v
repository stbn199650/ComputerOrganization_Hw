// Regfile	//lw

module Regfile ( clk, 
				 rst,
				 Read_addr_1,	//Rs
				 Read_addr_2,	//Rt
				 Read_data_1,
                 Read_data_2,
				 RegWrite,
				 Write_addr,	//WR
				 Write_data);	//WD
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1;
	input  [4:0] Read_addr_2;
	
	output [bit_size-1:0] Read_data_1;
	output [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr;
	input  [bit_size-1:0] Write_data;	
	
    // write your code in here	
	reg [bit_size-1:0] register[0:31];	
	
	// Read from register
	assign Read_data_1 = register[Read_addr_1];	
	assign Read_data_2 = register[Read_addr_2];
	
	// Write to register
	integer i=0;
	always @(posedge clk or posedge rst)
	begin
		if(rst)		//rst==1,reset register to 0
			for(i=0;i<bit_size;i=i+1)
				register[i] <= 0;
		else if(RegWrite)	
			register[Write_addr] <= Write_data;
	end	
	
endmodule


