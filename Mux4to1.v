// 4X1 multiplixer , be used to jump address

module Mux4to1( select,					
				In1,
				In2,
				In3,
				In4,
				out);
				
	parameter bit_size=18;
	
	input [bit_size-1:0] In1;	
	input [bit_size-1:0] In2;
	input [bit_size-1:0] In3;
	input [bit_size-1:0] In4;
	input [1:0] select;
	
	output [bit_size-1:0] out;
	reg [bit_size-1:0] out;
	
	always @(*)
	begin		
		case(select)
			2'b00: out<=In1;
			2'b01: out<=In2;
			2'b10: out<=In3;
			2'b11: out<=In4;
		endcase	
	end						
				
endmodule


