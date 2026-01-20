# 4Bit-CPU-in-Verilog
This 4-bit CPU uses many concepts we have learned this semester in ECE 3700. The project uses Finite State Machines
for control, registers for storing values, a BUS for moving data, write buffers, and basic ALU operations. 

A Finite State Machine is a tool that consistes of states, transitions in between, and outputs that depend on the current state
or on the state and current inputs. 

Registers allow us to store values in our design so the system can remember data across clock cycles. A register is a group of flip 
flops that store 4 bit values. They have an enable signal which indicates when it is time to save the data on the BUS. When the 
enable is not on, we will not be storing the data on the BUS, the last value will remain. The register will also contain a reset signal, 
when the reset is high, the value of this register is set to 0000.

For my design, I used a BUS module that was a simple combinational multiplexer. The BUS takes 4-bit sources (in this case its: switches, 
R1, R2, Rout, and the ALU) and uses a 3-bit opcode from the Finite State Machine to select which source drives the BUS at that clock time. 
Since only one opcode is produced by the Finite State Machine, this ensures one output to the BUS.

This CPU is built out of a few different Verilog modules that each work together through one shared BUS. The BUS is really the central 
connection in the system - every register, the ALU, and the switch input connect to it. The FSM controls which source is placed onto the 
BUS and which register should load that value on the next clock cycle. Because everything runs off the 50 MHz clock, the data moves through the 
system one step at a time as outlined in the finite state machine module. 

The registers of R1, R2, and Rout only update when their enable signal is high, and the ALU is always reading the registers. The finite state 
machine chooses the ALU operation and decides when its output should go onto the BUS. The final result is stored in Rout, and since Rout is wired 
to the seven segment display module, whatever value ends up in Rout at the end shows up on HEX0.

All of these components are tied together in the top file cpu_top, which connects the switches → BUS, the BUS → registers, the registers → ALU, 
and the FSM → all control signals. When reset switched on, the FSM starts at state S0 and steps through the hard coded program until the final
result is displayed.
