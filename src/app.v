`timescale 1ns / 1ps

`include "processor/rv32e_soc.v"
`include "rom/program_rom.v"
`include "four-port-array.v"

module app(
	input clk,
    input reset,
    
    output [2:0] rgb_led,
    
    output wire digit_anode1,
	output wire digit_anode2,
	output wire digit_anode3,
	output wire digit_anode4,
	
	output wire segmentA,
	output wire segmentB,
	output wire segmentC,
	output wire segmentD,
	output wire segmentE,
	output wire segmentF,
	output wire segmentG
);
    wire [31:0] program_addr_bus;
    wire [31:0] program_data_bus;
    
    assign rgb_led = 3'b111;
    
    wire [7:0] i0, o0, o1, o2;
    
    FourPortArray FourPortArray0(
	    .reset(reset),
	    .DataBus0(i0),
	    .AddressBus0(o0)
    );

    rv32e_soc rv32e_soc0(
        .clk(clk),
        .reset(reset),
        .program_addr_bus(program_addr_bus),
        .program_data_bus(program_data_bus),
        .i0(i0),
        .o0(o0), .o1(o1), .o2(o2)
    );

    program_rom program_rom0(
    	.reset(reset),
        .addr_bus(program_addr_bus),
        .data_bus(program_data_bus)
    );
    
    // Clock is 24Mhz
	localparam five_millis = 'd120_000;
	localparam one_second = 'd24_000_000;
	
	// Input to display comes from processor output
	
	wire [6:0] digit1_out;
	wire [6:0] digit2_out;
	wire [6:0] digit3_out;
	wire [6:0] digit4_out;
	
	hex_to_7segment digit1_converter (o2[7:4], digit1_out);
	hex_to_7segment digit2_converter (o2[3:0], digit2_out);
	hex_to_7segment digit3_converter (o1[7:4], digit3_out);
	hex_to_7segment digit4_converter (o1[3:0], digit4_out);
	
	// Display
	
	reg [19:0] display_timer;
	reg [3:0] digit_selector;
	reg [6:0] segments_out;
	
	assign {digit_anode1, digit_anode2, digit_anode3, digit_anode4} = ~digit_selector;
	assign {segmentA, segmentB, segmentC, segmentD, segmentE, segmentF, segmentG} = segments_out;

	always @(posedge clk) begin
		if (reset == 0) begin
			display_timer <= 0;
			digit_selector <= 4'b0001;
			segments_out <= 7'b0000000;
		end
		if (display_timer == five_millis) begin
			display_timer <= 0;
			digit_selector <= {digit_selector[2:0], digit_selector[3]};
		end
		else if (display_timer == 1) begin
			case (digit_selector)
				4'b1000 : segments_out <= digit1_out;
				4'b0100 : segments_out <= digit2_out;
				4'b0010 : segments_out <= digit3_out;
				4'b0001 : segments_out <= digit4_out;
			endcase
			display_timer <= display_timer + 1;
		end
		else display_timer <= display_timer + 1;
	end
endmodule
