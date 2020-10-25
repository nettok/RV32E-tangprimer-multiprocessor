`timescale 1ns / 1ps

module mem_data_ram(
    input clk,
    input reset,

    input  [31:0] addr_bus,
    
    input [31:0] write_data_bus,
    input write_signal,

    output [31:0] read_data_bus,

    // memory-mapped IO ports
    input  [7:0] i0,
    output [7:0] o0,
    output [7:0] o1,
    output [7:0] o2
);

    reg [7:0] mem [11:0];
    assign read_data_bus = {mem[addr_bus], mem[addr_bus+1], mem[addr_bus+2], mem[addr_bus+3]};   // byte-addressable with 32-bit bus

    // output wiring
    assign o2 = mem[5];
    assign o1 = mem[6];
    assign o0 = mem[7];

    always @(posedge clk) begin
        if (reset == 1) begin
        	// input
            mem[3][7] <= i0[7];
    		mem[3][6] <= i0[6];
		    mem[3][5] <= i0[5];
		    mem[3][4] <= i0[4];
		    mem[3][3] <= i0[3];
		    mem[3][2] <= i0[2];
		    mem[3][1] <= i0[1];
		    mem[3][0] <= i0[0];
    
        	if (write_signal) begin
	            mem[addr_bus]   <= write_data_bus[31:24];
    	        mem[addr_bus+1] <= write_data_bus[23:16];
        	    mem[addr_bus+2] <= write_data_bus[15:8];
            	mem[addr_bus+3] <= write_data_bus[7:0];
            end
        end
        else if (reset == 0) begin
            // memory-mapped IO registers (word 0) (input-only)
            mem[0] <= 0;    // reserved
            mem[1] <= 0;    // reserved
            mem[2] <= 0;	// reserved
            mem[3] <= i0;

            // memory-mapped IO registers (word 1) (output-only)
            mem[4] <= 0;    // reserved
            mem[5] <= 0;    // wired to "o2"
            mem[6] <= 0;    // wired to "o1"
            mem[7] <= 0;    // wired to "o0"

            // user memory (heap) (from word 2)
//            mem[8] <= 0;
//            mem[9] <= 0;
//            mem[10] <= 0;
//            mem[11] <= 0;
            
//            mem[12] <= 0;
//            mem[13] <= 0;
//            mem[14] <= 0;
//            mem[15] <= 0;
            
//            mem[16] <= 0;
//            mem[17] <= 0;
//            mem[18] <= 0;
//            mem[19] <= 0;
            
//            mem[20] <= 0;
//            mem[21] <= 0;
//            mem[22] <= 0;
//            mem[23] <= 0;
            
//            mem[24] <= 0;
//            mem[25] <= 0;
//            mem[26] <= 0;
//            mem[27] <= 0;
            
//            mem[28] <= 0;
//            mem[29] <= 0;
//            mem[30] <= 0;
//            mem[31] <= 0;
            
//            mem[32] <= 0;
//            mem[33] <= 0;
//            mem[34] <= 0;
//            mem[35] <= 0;
            
//            mem[36] <= 0;
//            mem[37] <= 0;
//            mem[38] <= 0;
//            mem[39] <= 0;
            
//            mem[40] <= 0;
//            mem[41] <= 0;
//            mem[42] <= 0;
//            mem[43] <= 0;
            
//            mem[44] <= 0;
//            mem[45] <= 0;
//            mem[46] <= 0;
//            mem[47] <= 0;
            
//            mem[48] <= 0;
//            mem[49] <= 0;
//            mem[50] <= 0;
//            mem[51] <= 0;
            
//            mem[52] <= 0;
//            mem[53] <= 0;
//            mem[54] <= 0;
//            mem[55] <= 0;
            
//            mem[56] <= 0;
//            mem[57] <= 0;
//            mem[58] <= 0;
//            mem[59] <= 0;
            
//            mem[60] <= 0;
//            mem[61] <= 0;
//            mem[62] <= 0;
//            mem[63] <= 0;
            
//            mem[64] <= 0;
//            mem[65] <= 0;
//            mem[66] <= 0;
//            mem[67] <= 0;
            
//            mem[68] <= 0;
//            mem[69] <= 0;
//            mem[70] <= 0;
//            mem[71] <= 0;
            
//            mem[72] <= 0;
//            mem[73] <= 0;
//            mem[74] <= 0;
//            mem[75] <= 0;
            
//            mem[76] <= 0;
//            mem[77] <= 0;
//            mem[78] <= 0;
//            mem[79] <= 0;

//            mem[80] <= 0;
//            mem[81] <= 0;
//            mem[82] <= 0;
//            mem[83] <= 0;

//            mem[84] <= 0;
//            mem[85] <= 0;
//            mem[86] <= 0;
//            mem[87] <= 0;

//            mem[88] <= 0;
//            mem[89] <= 0;
//            mem[90] <= 0;
//            mem[91] <= 0;

//            mem[92] <= 0;
//            mem[93] <= 0;
//            mem[94] <= 0;
//            mem[95] <= 0;

//            mem[96] <= 0;
//            mem[97] <= 0;
//            mem[98] <= 0;
//            mem[99] <= 0;

            // Stack pointer initial position (word 25) (grows to lower memory addresses ^)
        end
    end

endmodule
