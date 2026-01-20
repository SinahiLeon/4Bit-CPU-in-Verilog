// Top CPU wrapper
// Files: FSM, BUS, ALU, registers, and 7-seg display.

module cpu_top (
    input        CLK50,      
    input        RESET,      // active-high reset (push button)
    input  [3:0] SW,         // 4-bit external switches S3..S0
    output [6:0] HEX0        // 7-seg display segments
);

    // Internal wires for register outputs
    wire [3:0] r1_out;
    wire [3:0] r2_out;
    wire [3:0] rout_out;

    // BUS wire
    wire [3:0] bus_value;

    // ALU result
    wire [3:0] alu_out;

    // Control signals from FSM
    wire [2:0] bus_selector;
    wire [1:0] alu_control;
    wire       r1_enable;
    wire       r2_enable;
    wire       rout_enable;


    cpu_fsm instance_fsm (
        .clk         (CLK50),
        .reset       (RESET),
        .bus_selector(bus_selector),
        .alu_control (alu_control),
        .r1_enable   (r1_enable),
        .r2_enable   (r2_enable),
        .rout_enable (rout_enable)
    );

    // Register1
    cpu_register instance_r1 (
        .clk    (CLK50),
        .reset  (RESET),
        .enable (r1_enable),
        .inputD (bus_value),
        .outputQ(r1_out)
    );

    // Register2
    cpu_register instance_r2 (
        .clk    (CLK50),
        .reset  (RESET),
        .enable (r2_enable),
        .inputD (bus_value),
        .outputQ(r2_out)
    );

    // Rout
    cpu_register instance_rout (
        .clk    (CLK50),
        .reset  (RESET),
        .enable (rout_enable),
        //.inputD (bus_value),
		  .inputD(alu_out),
        .outputQ(rout_out)
    );

    // ALU
    cpu_alu instance_alu (
        .A          (r1_out),
        .B          (r2_out),
        .alu_control(alu_control),
        .result     (alu_out)
    );

    // -Bus
    cpu_bus instance_bus (
        .bus_selector(bus_selector),
        .switch_input(SW),        // external switches
        //.r1_out      (r1_out),
        //.r2_out      (r2_out),
        .rout_out    (rout_out),
        //.alu_out     (alu_out),
        .bus_value   (bus_value)
    );

    // 7 segment display -> Show Rout on HEX0
    seven_segment instance_hex0 (
        .bcd      (rout_out),
        .seven_seg(HEX0)
    );

endmodule
