// Add

module Add( In1,
			In2,
			out);
			
	parameter bit_size = 18;
	
	input [bit_size-1:0] In1;
	input [bit_size-1:0] In2;	
	output [bit_size-1:0] out;	
		
	assign out = In1+In2;		
			
endmodule