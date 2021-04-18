module speedupspeeddown(clk, speed_up, speed_down, reset, divider);
	parameter base = 32'd4545;
	
	input logic speed_up, speed_down, reset;
	input logic clk;

	
	output logic [31:0] divider = base;
	
	always @(posedge clk)
	begin
			if (speed_up)			 	divider <= divider - 1;
			else if(speed_down) 		divider <=divider + 1;
			else if(reset)				divider <= base;
	end
		
endmodule	