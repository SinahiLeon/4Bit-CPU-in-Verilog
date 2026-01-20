// Hex to 7-seg module + A-F

module seven_segment(
    input wire [3:0] bcd,      // 4-bit input (0–F)
    output reg [6:0] seven_seg // 7-segment output pattern (active low)
);
    always @(*) begin
        case (bcd)
            0: seven_seg = ~7'b0111111;   // Displays 0
            1: seven_seg = ~7'b0000110;   // Displays 1
            2: seven_seg = ~7'b1011011;   // Displays 2
            3: seven_seg = ~7'b1001111;   // Displays 3
            4: seven_seg = ~7'b1100110;   // Displays 4
            5: seven_seg = ~7'b1101101;   // Displays 5
            6: seven_seg = ~7'b1111101;   // Displays 6
            7: seven_seg = ~7'b0000111;   // Displays 7
            8: seven_seg = ~7'b1111111;   // Displays 8
            9: seven_seg = ~7'b1100111;   // Displays 9
				
				10: seven_seg = ~7'b1110111;   // Displays A
            11: seven_seg = ~7'b1111100;   // Displays b
            12: seven_seg = ~7'b0111001;   // Displays C
            13: seven_seg = ~7'b1011110;   // Displays d
            14: seven_seg = ~7'b1111001;   // Displays E
            15: seven_seg = ~7'b1110001;   // Displays F
            default: seven_seg = ~7'b0000000; // Blank (invalid digit)
        endcase
    end
endmodule

/*
PIN ASSIGNMENTS
seven_seg[0] Output PIN_C14
seven_seg[1] Output PIN_E15
seven_seg[2] Output PIN_C15
seven_seg[3] Output PIN_C16
seven_seg[4] Output PIN_E16
seven_seg[5] Output PIN_D17
seven_seg[6] Output PIN_C17
*/
