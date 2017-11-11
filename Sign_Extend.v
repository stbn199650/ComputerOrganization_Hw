// Extend sign from 16 bits to 32 bits	
//ex. 1001=>1111 1001 extend 4 bit to 8 bit,the extended bits are all sign 
module Sign_Extend( in,
					out);
					
	input [15:0] in;
	output [31:0] out;
	
	//repeat in[15] 16 times , and connect with original in		
	assign out={{16{in[15]}},in};	
					
endmodule