// 4-bit BUS
// Selects one of 4-bit sources onto the BUS using an opcode

module cpu_bus (
	input [2:0] bus_selector,	// BUS opcode
	input [3:0] switch_input,
	input [3:0] rout_out,
	output reg [3:0] bus_value
);

// Combinational logic multiplexer
    always @(*) begin
        case (bus_selector)
            3'b000: bus_value = switch_input;
            3'b011: bus_value = rout_out;
				3'b101: bus_value = 4'b0011;	// hard code 3 in binary
            default: bus_value = 4'b0000;
        endcase
    end

endmodule