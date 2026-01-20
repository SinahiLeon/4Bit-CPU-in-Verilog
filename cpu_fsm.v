// CPU Control FSM

module cpu_fsm (
    input clk,                 // 50 MHz clock
    input reset,               // active-high reset

    output reg [2:0] bus_selector, // selects BUS source
    output reg [1:0] alu_control,  // 00=ADD, 01=OR, 10=XOR, 11=NOT

    output reg r1_enable,      // load enable for R1
    output reg r2_enable,      // load enable for R2
    output reg rout_enable     // load enable for Rout
);

    // States 0->9
    localparam S0 = 4'd0;  // Reset 
    localparam S1 = 4'd1;  // R1 <- external switches
    localparam S2 = 4'd2;  // R2 <- 3 
    localparam S3 = 4'd3;  // Rout <- R1 + R2
    localparam S4 = 4'd4;  // R2 <- Rout
    localparam S5 = 4'd5;  // Rout <- R1 OR R2
    localparam S6 = 4'd6;  // R1 <- Rout
    localparam S7 = 4'd7;  // Rout <- NOT R1
    localparam S8 = 4'd8;  // R1 <- Rout
    localparam S9 = 4'd9;  // Rout <- R1 XOR R2 (final state)

    reg [3:0] state;
    reg [3:0] next_state;

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= S0;       // on reset, go to S0
        else
            state <= next_state;
    end

    // Next-state and output logic (combinational)
    always @(*) begin
        // Safe defaults
        bus_selector = 3'b000; // default bus source (switches, but no register enabled)
        alu_control  = 2'b00;  // default ALU op = ADD
        r1_enable    = 1'b0;
        r2_enable    = 1'b0;
        rout_enable  = 1'b0;
        next_state   = state;

        case (state)

            // S0: Reset state
            // All enables are low; registers are cleared by global reset.
            // Once reset is de-asserted, move to S1.
            S0: begin
                next_state = S1;
            end

            // S1: R1 <- external switch data
            // Put switches on the bus and enable R1.
            S1: begin
                bus_selector = 3'b000;  // bus = switch_input
                r1_enable    = 1'b1;    // R1 <- bus at next clock
                next_state   = S2;
            end

            // S2: R2 <- 3 (LDI R2 4'b0011)
            // Put immediate 3 on the bus and enable R2.
            S2: begin
                bus_selector = 3'b101;  // bus = 4'b0011
                r2_enable    = 1'b1;    // R2 <- bus
                next_state   = S3;
            end

            // S3: Rout <- R1 + R2
            // Use ALU in ADD mode; Rout loads ALU output.
            S3: begin
                alu_control  = 2'b00;   // ADD
                rout_enable  = 1'b1;    // Rout <- R1 + R2
                next_state   = S4;
            end

            // S4: R2 <- Rout
            // Put Rout on bus and enable R2.
            S4: begin
                bus_selector = 3'b011;  // bus = rout_out
                r2_enable    = 1'b1;    // R2 <- Rout
                next_state   = S5;
            end

            // S5: Rout <- R1 OR R2
            S5: begin
                alu_control  = 2'b01;   // OR
                rout_enable  = 1'b1;    // Rout <- R1 | R2
                next_state   = S6;
            end

            // S6: R1 <- Rout
            S6: begin
                bus_selector = 3'b011;  // bus = rout_out
                r1_enable    = 1'b1;    // R1 <- Rout
                next_state   = S7;
            end

            // S7: Rout <- NOT R1
            S7: begin
                alu_control  = 2'b11;   // NOT
                rout_enable  = 1'b1;    // Rout <- ~R1
                next_state   = S8;
            end

            // S8: R1 <- Rout
            S8: begin
                bus_selector = 3'b011;  // bus = rout_out
                r1_enable    = 1'b1;    // R1 <- Rout
                next_state   = S9;
            end

            // S9: Rout <- R1 XOR R2
            // Final state: stays here until reset is asserted.
            S9: begin
                alu_control  = 2'b10;   // XOR
                rout_enable  = 1'b1;    // Rout <- R1 ^ R2
                next_state   = S9;      // remain in S9
            end

            // Safety: if something weird happens, go back to reset
            default: begin
                next_state = S0;
            end
        endcase
    end

endmodule
