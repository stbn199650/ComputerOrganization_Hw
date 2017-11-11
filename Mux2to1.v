// 2X1 multiplixer

module Mux2to1( select,
				In1,
				In2,			
				out);
				
	parameter bit_size=32;
	
	input [bit_size-1:0] In1;
	input [bit_size-1:0] In2;
	input select;	
	output [bit_size-1:0] out;		
	
	assign out = select?In2:In1;	
				
endmodule

