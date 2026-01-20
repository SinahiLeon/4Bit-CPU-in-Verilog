// 4-Bit ALU supporting ADD, OR, XOR, NOT
// carry out is ignored

module cpu_alu (
	input [3:0] A, 
	input [3:0] B,
	input [1:0] alu_control,	//00=ADD 01=OR 10 XOR 11=NOT(A)
	output reg [3:0] result	
	);
	
	// using combinational logic
	always @(*) begin
		case (alu_control)
			2'b00: result = A + B;	//ADD
			2'b01: result = A | B;	//OR
			2'b10: result = A ^ B;	//XOR
			2'b11: result = ~A;		//NOT A
			default: result = 4'b0000;
		endcase
	end
endmodule