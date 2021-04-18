module keyboard_cont(clock, reset, pressedkey, direction, pause, restart);
	input logic clock, reset;
	input logic [7:0] pressedkey;
	output logic direction, pause, restart;
	logic [3:0] state= 4'b1101;
	//state parameters
	parameter init = 			4'b1101;
	parameter forward_start = 	4'b1000;
	parameter forward_pause = 	4'b1100;
	parameter forward_restart = 4'b1001;
	parameter backward_start = 	4'b0000;
	parameter backward_pause = 	4'b0100;
	parameter backward_restart =4'b0001;
	//keyboard ascii codes
	parameter character_B = 8'h42;
	parameter character_D = 8'h44;
	parameter character_E = 8'h45;
	parameter character_F = 8'h46;
	parameter character_R = 8'h52;
	
	//outputs assigned from states
    always_comb
	begin
		direction <= state[3]; // 1 for forward 0 for backwards
		pause <= state[2];   
		restart <= state[0];
	end

	always_ff @(posedge clock or posedge reset)
	begin
		if (reset) begin
			 if (!direction)
					state <= backward_restart;
					else state <= forward_restart;
					end
		else
			begin
				case(state)
					
				init:	begin if (pressedkey == character_E)				
						state <= forward_start;
				 else if (pressedkey == character_B)
						state <= backward_start;
				 else
						state <= init;
					end
				forward_start:  if (pressedkey == character_R) begin 
                                                                state <= forward_restart;
                                                                end
								else if (pressedkey == character_D) begin 
                                                                state <= forward_pause; // continues playing from where we left off
                                                                    end 
								else if (pressedkey == character_B) begin 
                                                                state <= backward_start;
                                                                    end
								else state <= forward_start;
				forward_pause:  begin  if (pressedkey == character_E)   
                                                                state <= forward_start;
								//else if (pressedkey == character_F) state <= forward_start;
								else if (pressedkey == character_B) state <= backward_start;  //pauses at address we are playing
								else if (pressedkey == character_R) state <= forward_restart;
								else state <= forward_pause;
								end
				forward_restart: state <= forward_start;    //restarts from begining

				backward_start:	if (pressedkey == character_R) state <= backward_restart;
								else if (pressedkey == character_D) state <= backward_pause; // starts in the backwards direction
								else if (pressedkey == character_F) state <= forward_start;
								else state <= backward_start;
				backward_pause:	if (pressedkey == character_E) state <= backward_start;
								else if (pressedkey == character_F) state <= forward_start;
								else if (pressedkey == character_R) state <= backward_restart; //pauses in the backwards direction 
								else state <= backward_pause;
				backward_restart: state <= backward_start;             //restarts backwards
						
						default: state <= init;
					endcase
				end
		end
endmodule