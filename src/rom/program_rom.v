`timescale 1ns / 1ps

`include "../processor/instructions.v"

module program_rom(
	input reset,
    input  [31:0] addr_bus,
    output [31:0] data_bus
);

    reg [31:0] mem [37:0];
    assign data_bus = mem[addr_bus/4];  // byte-addressable with forced 32-bit aligned access
    
    // x5: count
	// x6: num
	// x7: work_address (-> o0)

	// i0: work value in
	// o0: work address out
	// o1: count out
	// o2: done flag out
    
    always @(negedge reset) begin
	    																		// main:
    	mem[0000] <= {12'd0, 5'd0, `F3_ADDI, 5'd5, `OP_OP_IMM};					// ADDI x5, x0, 0		// count = 0
    	mem[0001] <= {12'd0, 5'd0, `F3_ADDI, 5'd7, `OP_OP_IMM};					// ADDI x7, x0, 0		// work_address = 0
    	mem[0002] <= {7'b0, 5'd7, 5'd0, `F3_SW, 5'd4, `OP_STORE};				// SW   x7, (o0)		// o0 <- x7
    	mem[0003] <= {20'd56, 5'b00, `OP_JAL};				// JAL  x0, .L12
    	
	    																		// .L11:
    	mem[0004] <= {12'b0, 5'd0, `F3_LW, 5'd1, `OP_LOAD};						// LW   x1, 0			// x1 = input (i0)
    	mem[0005] <= {12'b000011111111, 5'd1, `F3_ANDI, 5'd6, `OP_OP_IMM};		// ANDI x6, x1, 0xFF	// num <- i0
    	
    	mem[0006] <= {12'd108, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 108
    	mem[0007] <= {7'b0000000, 5'd8, 5'd6, `F3_BLT, 5'd20, `OP_BRANCH};	// BLT  x6, x8, .L2		// jump to else (num < 108)
    	
    	mem[0008] <= {12'd109, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 109
    	mem[0009] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd6, `OP_BRANCH};	// BEQ  x6, x8, .L3		// num == 109  -->  .L3
    	mem[0010] <= {12'd113, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 113
    	mem[0011] <= {7'b0000000, 5'd8, 5'd6, `F3_BNE, 5'd6, `OP_BRANCH};	// BNE  x6, x8, .L4		// num != 113  -->  .L4
    	
    																			// .L3:
    	mem[0012] <= {12'd1, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 1
    	mem[0013] <= {20'd4, 5'b00, `OP_JAL};				// JAL  x0, .L5
    	
	    																		// .L4:
	    mem[0014] <= {12'd0, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 0
	    
																			    // .L5:
	    mem[0015] <= {`F7_30_0, 5'd9, 5'd5, `F3_ADD, 5'd5, `OP_OP};				// ADD  x5, x5, x9		// count += incr(x9)
	    mem[0016] <= {20'd26, 5'b00, `OP_JAL};				// JAL  x0, .L6
	    
																			    // .L2:
		mem[0017] <= {12'd107, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 107
		mem[0018] <= {7'b0000000, 5'd8, 5'd6, `F3_BGE, 5'd20, `OP_BRANCH};	// BGE  x6, x8, .L7		// jump to else (num == 107)
		
		mem[0019] <= {12'd2, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};					// ADDI x8, x0, 2
		mem[0020] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd6, `OP_BRANCH};	// BEQ  x6, x8, .L8		// num == 2  -->  .L8
		mem[0021] <= {12'd3, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};					// ADDI x8, x0, 3
		mem[0022] <= {7'b0000000, 5'd8, 5'd6, `F3_BNE, 5'd6, `OP_BRANCH};	// BNE  x6, x8, .L9		// num != 3  -->  .L9
		
																				// .L8:
		mem[0023] <= {12'd1, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 1
		mem[0024] <= {20'd4, 5'b00, `OP_JAL};				// JAL  x0, .L10
		
																				// .L9:
		mem[0025] <= {12'd0, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 0
		
																				// .L10:
		mem[0026] <= {`F7_30_0, 5'd9, 5'd5, `F3_ADD, 5'd5, `OP_OP};				// ADD  x5, x5, x9		// count += incr(x9)
		mem[0027] <= {20'd4, 5'b00, `OP_JAL};				// JAL  x0, .L6
		
																				// .L7:
		mem[0028] <= {12'd1, 5'd5, `F3_ADDI, 5'd5, `OP_OP_IMM};					// ADDI x5, x5, 1		// count++
		
																				// .L6:
		mem[0029] <= {12'd1, 5'd7, `F3_ADDI, 5'd7, `OP_OP_IMM};					// ADDI x7, x7, 1		// work_address++
		mem[0030] <= {7'b0, 5'd7, 5'd0, `F3_SW, 5'd4, `OP_STORE};				// SW   x7, (o0)		// o0 <- x7
		
																				// .L12:
		mem[0031] <= {12'd255, 5'd0, `F3_ADDI, 5'd10, `OP_OP_IMM};				// ADDI x10, x0, 255
		mem[0032] <= {7'b1111110, 5'd10, 5'd7, `F3_BNE, 5'b01000, `OP_BRANCH};	// BNE  x7, x10, .L11	// work_address != 255 --> .L11
		
		mem[0033] <= {`F7_30_0, 5'd0, 5'd5, `F3_ADD, 5'd11, `OP_OP};			// ADD  x11, x5, x0		// x11 = x5
		mem[0034] <= {12'b000100000000, 5'd11, `F3_ORI, 5'd11, `OP_OP_IMM};		// ORI  x11, x11, 0x100	// done flag
		mem[0035] <= {12'd8, 5'd11, `F3_SLLI, 5'd11, `OP_OP_IMM};				// SLLI x11, x11, 8
		mem[0036] <= {7'b0, 5'd11, 5'd0, `F3_SW, 5'd4, `OP_STORE};				// SW   x11, (o2, o1 ,o0)	// (o2, o1 ,o0) <- x11

		mem[0037] <= {20'b0, 5'b00, `OP_JAL};									// JAL  x0, .here		// halt
    end
endmodule
