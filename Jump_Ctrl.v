// Jump_Ctrl

module Jump_Ctrl( Zero,		//beq,bne
				  Branch,
				  Jump,
				  Jump_Addr,	
                  JumpOP
				  // write your code in here			  			  
				  );

    input Zero, Branch, Jump, Jump_Addr;	
	
	output [1:0] JumpOP;
	reg [1:0] JumpOP;
	// write your code in here
	
	always @(*)
	begin		
		if(Zero && Branch)		//beq , bne	
			JumpOP <= 2'b01;			
		else if(Jump_Addr)		//jr
			JumpOP <= 2'b10;		
		else if(Jump)			//jump
			JumpOP <= 2'b11;	
		else
			JumpOP <= 2'b00;
	end
	
endmodule

