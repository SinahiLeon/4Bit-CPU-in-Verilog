// This module stores a 4-bit value from the BUS.
// New data is loaded when enable = 1
// Maintain last value when enable = 0
// When reset = 1, clear register

module cpu_register (
	input clk,	// clock
	input reset,	// set register to 0000
	input enable,	// controls when to load new data
	input [3:0] inputD,	// D: value from the bus
	output reg [3:0] outputQ 	// Q: stored register value
	);
	
	// Sequential logic
	always @(posedge clk) begin
		if (reset)
			outputQ <= 4'b0000;
		else if (enable)
			outputQ <= inputD;	// load new BUS value
		// defaults to retain Q if else
	end
	
endmodule