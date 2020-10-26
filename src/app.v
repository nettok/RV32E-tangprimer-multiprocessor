`timescale 1ns / 1ps

`include "processor/rv32e_soc.v"
`include "rom/program_rom.v"
`include "four-port-array.v"

module app(
	input clk,
    input reset,
    
    input display_switch,
    
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
    wire [31:0] program_addr_bus0;
    wire [31:0] program_data_bus0;
    wire [31:0] program_addr_bus1;
    wire [31:0] program_data_bus1;
    wire [31:0] program_addr_bus2;
    wire [31:0] program_data_bus2;
    wire [31:0] program_addr_bus3;
    wire [31:0] program_data_bus3;
    
    assign rgb_led = 3'b111;
    
    wire [7:0] soc0_i0, soc0_o0, soc0_o1, soc0_o2;
    wire [7:0] soc1_i0, soc1_o0, soc1_o1, soc1_o2;
  	wire [7:0] soc2_i0, soc2_o0, soc2_o1, soc2_o2;
  	wire [7:0] soc3_i0, soc3_o0, soc3_o1, soc3_o2;
    
    wire [7:0] soc0_work_array_address;
    wire [7:0] soc1_work_array_address;
    wire [7:0] soc2_work_array_address;
    wire [7:0] soc3_work_array_address;
    
    assign soc0_work_array_address = {2'b00, soc0_o0[5:0]};
    assign soc1_work_array_address = {2'b01, soc1_o0[5:0]};
    assign soc2_work_array_address = {2'b10, soc2_o0[5:0]};
    assign soc3_work_array_address = {2'b11, soc3_o0[5:0]};
    
    FourPortArray FourPortArray0(
	    .reset(reset),
	    .DataBus0(soc0_i0),
	    .AddressBus0(soc0_work_array_address),
	    .DataBus1(soc1_i0),
	    .AddressBus1(soc1_work_array_address),
	    .DataBus2(soc2_i0),
	    .AddressBus2(soc2_work_array_address),
	    .DataBus3(soc3_i0),
	    .AddressBus3(soc3_work_array_address)
    );

    rv32e_soc rv32e_soc0(
        .clk(clk),
        .reset(reset),
        .program_addr_bus(program_addr_bus0),
        .program_data_bus(program_data_bus0),
        .i0(soc0_i0),
        .o0(soc0_o0), .o1(soc0_o1), .o2(soc0_o2)
    );
    
    rv32e_soc rv32e_soc1(
        .clk(clk),
        .reset(reset),
        .program_addr_bus(program_addr_bus1),
        .program_data_bus(program_data_bus1),
        .i0(soc1_i0),
        .o0(soc1_o0), .o1(soc1_o1), .o2(soc1_o2)
    );
    
    rv32e_soc rv32e_soc2(
        .clk(clk),
        .reset(reset),
        .program_addr_bus(program_addr_bus2),
        .program_data_bus(program_data_bus2),
        .i0(soc2_i0),
        .o0(soc2_o0), .o1(soc2_o1), .o2(soc2_o2)
    );
    
    rv32e_soc rv32e_soc3(
        .clk(clk),
        .reset(reset),
        .program_addr_bus(program_addr_bus3),
        .program_data_bus(program_data_bus3),
        .i0(soc3_i0),
        .o0(soc3_o0), .o1(soc3_o1), .o2(soc3_o2)
    );

    program_rom program_rom0(
    	.reset(reset),
        .addr_bus0(program_addr_bus0),
        .data_bus0(program_data_bus0),
        .addr_bus1(program_addr_bus1),
        .data_bus1(program_data_bus1),
        .addr_bus2(program_addr_bus2),
        .data_bus2(program_data_bus2),
        .addr_bus3(program_addr_bus3),
        .data_bus3(program_data_bus3)
    );
    
    // result adder
    
    wire [7:0] result;
    assign result = soc0_o1 + soc1_o1 + soc2_o1 + soc3_o1;
    
    // cycles counter
    
    reg [15:0] cycles_counter;
    wire done = soc0_o2[0] & soc1_o2[0] & soc2_o2[0] & soc3_o2[0];
    
    always @(posedge clk) begin
    	if (reset == 0)  cycles_counter <= 0;
    	else if (~done) cycles_counter <= cycles_counter + 1;
    end
    
    // display data switch (result counter / cpu cycles counter)
    
    wire [15:0] display_output;
    
    assign display_output = {
	    display_switch ? cycles_counter[15:12] : {3'b000, done},
	  	display_switch ? cycles_counter[11:8]  : 4'b0000,
	  	display_switch ? cycles_counter[7:4]   : result[7:4],
	  	display_switch ? cycles_counter[3:0]   : result[3:0]
    };
    
    // Clock is 24Mhz
	localparam five_millis = 'd120_000;
	localparam one_second = 'd24_000_000;
	
	// Input to display comes from processor output
	
	wire [6:0] digit1_out;
	wire [6:0] digit2_out;
	wire [6:0] digit3_out;
	wire [6:0] digit4_out;
	
	hex_to_7segment digit1_converter (display_output[15:12], digit1_out);
	hex_to_7segment digit2_converter (display_output[11:8], digit2_out);
	hex_to_7segment digit3_converter (display_output[7:4], digit3_out);
	hex_to_7segment digit4_converter (display_output[3:0], digit4_out);
	
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
