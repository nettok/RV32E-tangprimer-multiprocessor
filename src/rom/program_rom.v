`timescale 1ns / 1ps

`include "../processor/instructions.v"

module program_rom(
	input reset,
    input  [31:0] addr_bus,
    output [31:0] data_bus
);

    reg [31:0] mem [135:0];
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
    	mem[0003] <= {20'd252, 5'b00, `OP_JAL};									// JAL  x0, .L12		// (129-3)*2=252
    	
	    																		// .L11:
    	mem[0004] <= {12'b0, 5'd0, `F3_LW, 5'd1, `OP_LOAD};						// LW   x1, 0			// x1 = input (i0)
    	mem[0005] <= {12'b000011111111, 5'd1, `F3_ANDI, 5'd6, `OP_OP_IMM};		// ANDI x6, x1, 0xFF	// num <- i0
    	
    	mem[0006] <= {12'd108, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 108		// jump to else (num < 108)
    	mem[0007] <= {7'b0000011, 5'd8, 5'd6, `F3_BLT, 5'b10100, `OP_BRANCH};	// BLT  x6, x8, .L2		// (65-7)*2=116=0b1110100
    	
    	mem[0008] <= {12'd109, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 109		// num == 109  -->  .L3
    	mem[0009] <= {7'b0000011, 5'd8, 5'd6, `F3_BEQ, 5'b00110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-9)*2=102=0b1100110
    	mem[0010] <= {12'd113, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 113		// num == 113  -->  .L3
    	mem[0011] <= {7'b0000011, 5'd8, 5'd6, `F3_BEQ, 5'b00010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-11)*2=98=0b1100010
        mem[0012] <= {12'd127, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 127		// num == 127  -->  .L3
    	mem[0013] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b11110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-13)*2=94=0b1011110
        mem[0014] <= {12'd131, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 131		// num == 131  -->  .L3
    	mem[0015] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b11010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-15)*2=90=0b1011010
    	mem[0016] <= {12'd137, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 137		// num == 137  -->  .L3
    	mem[0017] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b10110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-17)*2=86=0b1010110
    	mem[0018] <= {12'd139, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 139		// num == 139  -->  .L3
    	mem[0019] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b10010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-19)*2=82=0b1010010
        mem[0020] <= {12'd149, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 149		// num == 149  -->  .L3
    	mem[0021] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b01110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-21)*2=78=0b1001110
        mem[0022] <= {12'd151, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 151		// num == 151  -->  .L3
    	mem[0023] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b01010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-23)*2=74=0b1001010
        mem[0024] <= {12'd157, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 157		// num == 157  -->  .L3
    	mem[0025] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b00110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-25)*2=70=0b1000110
        mem[0026] <= {12'd163, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 163		// num == 163  -->  .L3
    	mem[0027] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b00010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-27)*2=66=0b1000010
        mem[0028] <= {12'd167, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 167		// num == 167  -->  .L3
    	mem[0029] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b11110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-29)*2=62=0b0111110
        mem[0030] <= {12'd173, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 173		// num == 173  -->  .L3
    	mem[0031] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b11010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-31)*2=58=0b0111010
    	mem[0032] <= {12'd179, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 179		// num == 179  -->  .L3
    	mem[0033] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b10110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-33)*2=54=0b0110110
        mem[0034] <= {12'd181, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 181		// num == 181  -->  .L3
    	mem[0035] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b10010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-35)*2=50=0b0110010
        mem[0036] <= {12'd191, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 191		// num == 191  -->  .L3
    	mem[0037] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b01110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-37)*2=46=0b0101110
        mem[0038] <= {12'd193, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 193		// num == 193  -->  .L3
    	mem[0039] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b01010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-39)*2=42=0b0101010
        mem[0040] <= {12'd197, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 197		// num == 197  -->  .L3
    	mem[0041] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b00110, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-41)*2=38=0b0100110
        mem[0042] <= {12'd199, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 199		// num == 199  -->  .L3
    	mem[0043] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b00010, `OP_BRANCH};	// BEQ  x6, x8, .L3		// (60-43)*2=34=0b0100010
        mem[0044] <= {12'd211, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 211		// num == 211  -->  .L3
    	mem[0045] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd30, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-45)*2=30
        mem[0046] <= {12'd223, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 223		// num == 223  -->  .L3
    	mem[0047] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd26, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-47)*2=26
        mem[0048] <= {12'd227, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 227		// num == 227  -->  .L3
    	mem[0049] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd22, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-49)*2=22
        mem[0050] <= {12'd229, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 229		// num == 229  -->  .L3
    	mem[0051] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd18, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-51)*2=18
        mem[0052] <= {12'd233, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 233		// num == 233  -->  .L3
    	mem[0053] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd14, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-53)*2=14
        mem[0054] <= {12'd239, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 239		// num == 239  -->  .L3
    	mem[0055] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd10, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-55)*2=10
        mem[0056] <= {12'd241, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 241		// num == 241  -->  .L3
    	mem[0057] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd6, `OP_BRANCH};		// BEQ  x6, x8, .L3		// (60-57)*2=6
    	mem[0058] <= {12'd251, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 251		// num != 251  -->  .L4
    	mem[0059] <= {7'b0000000, 5'd8, 5'd6, `F3_BNE, 5'd6, `OP_BRANCH};		// BNE  x6, x8, .L4		// (62-59)*2=6

    																			// .L3:
    	mem[0060] <= {12'd1, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 1
    	mem[0061] <= {20'd4, 5'b00, `OP_JAL};									// JAL  x0, .L5			// (63-61)*2=4
    	
	    																		// .L4:
	    mem[0062] <= {12'd0, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 0
	    
																			    // .L5:
	    mem[0063] <= {`F7_30_0, 5'd9, 5'd5, `F3_ADD, 5'd5, `OP_OP};				// ADD  x5, x5, x9		// count += incr(x9)
	    mem[0064] <= {20'd126, 5'b00, `OP_JAL};									// JAL  x0, .L6			// (127-64)*2=126
	    
																			    // .L2:
		mem[0065] <= {12'd107, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 107		// jump to else (num == 107)
		mem[0066] <= {7'b0000011, 5'd8, 5'd6, `F3_BGE, 5'b11000, `OP_BRANCH};	// BGE  x6, x8, .L7		// (126-66)*2=120=0b1111000
		
		mem[0067] <= {12'd2, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};					// ADDI x8, x0, 2		// num == 2  -->  .L8
		mem[0068] <= {7'b0000011, 5'd8, 5'd6, `F3_BEQ, 5'b01010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-68)*2=106=0b1101010
		mem[0069] <= {12'd3, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};					// ADDI x8, x0, 3		// num == 3  -->  .L8
		mem[0070] <= {7'b0000011, 5'd8, 5'd6, `F3_BEQ, 5'b00110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-70)*2=102=0b1100110
        mem[0071] <= {12'd5, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};					// ADDI x8, x0, 5		// num == 5  -->  .L8
		mem[0072] <= {7'b0000011, 5'd8, 5'd6, `F3_BEQ, 5'b00010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-72)*2=98=0b1100010
        mem[0073] <= {12'd7, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};					// ADDI x8, x0, 7		// num == 7  -->  .L8
		mem[0074] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b11110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-74)*2=94=0b1011110
        mem[0075] <= {12'd11, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 11		// num == 11  -->  .L8
		mem[0076] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b11010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-76)*2=90=0b1011010
		mem[0077] <= {12'd13, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 13		// num == 13  -->  .L8
		mem[0078] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b10110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-78)*2=86=0b1010110
        mem[0079] <= {12'd17, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 17		// num == 17  -->  .L8
		mem[0080] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b10010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-80)*2=82=0b1010010
        mem[0081] <= {12'd19, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 19		// num == 19  -->  .L8
		mem[0082] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b01110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-82)*2=78=0b1001110
        mem[0083] <= {12'd23, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 23		// num == 23  -->  .L8
		mem[0084] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b01010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-84)*2=74=0b1001010
        mem[0085] <= {12'd29, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 29		// num == 29  -->  .L8
		mem[0086] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b00110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-86)*2=70=0b1000110
        mem[0087] <= {12'd31, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 31		// num == 31  -->  .L8
		mem[0088] <= {7'b0000010, 5'd8, 5'd6, `F3_BEQ, 5'b00010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-88)*2=66=0b1000010
        mem[0089] <= {12'd37, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 37		// num == 37  -->  .L8
		mem[0090] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b11110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-90)*2=62=0b0111110
        mem[0091] <= {12'd41, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 41		// num == 41  -->  .L8
		mem[0092] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b11010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-92)*2=58=0b0111010
        mem[0093] <= {12'd43, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 43		// num == 43  -->  .L8
		mem[0094] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b10110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-94)*2=54=0b0110110
        mem[0095] <= {12'd47, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 47		// num == 47  -->  .L8
		mem[0096] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b10010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-96)*2=50=0b0110010
        mem[0097] <= {12'd53, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 53		// num == 53  -->  .L8
		mem[0098] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b01110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-98)*2=46=0b0101110
        mem[0099] <= {12'd59, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 59		// num == 59  -->  .L8
		mem[0100] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b01010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-100)*2=42=0b0101010
        mem[0101] <= {12'd61, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 61		// num == 61  -->  .L8
		mem[0102] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b00110, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-102)*2=38=0b0100110
        mem[0103] <= {12'd67, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 67		// num == 67  -->  .L8
		mem[0104] <= {7'b0000001, 5'd8, 5'd6, `F3_BEQ, 5'b00010, `OP_BRANCH};	// BEQ  x6, x8, .L8		// (121-104)*2=34=0b0100010
        mem[0105] <= {12'd71, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 71		// num == 71  -->  .L8
		mem[0106] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd30, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-106)*2=30
        mem[0107] <= {12'd73, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 73		// num == 73  -->  .L8
		mem[0108] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd26, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-108)*2=26
        mem[0109] <= {12'd79, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 79		// num == 79  -->  .L8
		mem[0110] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd22, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-110)*2=22
        mem[0111] <= {12'd83, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 83		// num == 83  -->  .L8
		mem[0112] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd18, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-112)*2=18
        mem[0113] <= {12'd89, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 89		// num == 89  -->  .L8
		mem[0114] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd14, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-114)*2=14
        mem[0115] <= {12'd97, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 97		// num == 97  -->  .L8
		mem[0116] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd10, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-116)*2=10
        mem[0117] <= {12'd101, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 101		// num == 101  -->  .L8
		mem[0118] <= {7'b0000000, 5'd8, 5'd6, `F3_BEQ, 5'd6, `OP_BRANCH};		// BEQ  x6, x8, .L8		// (121-118)*2=6
		mem[0119] <= {12'd103, 5'd0, `F3_ADDI, 5'd8, `OP_OP_IMM};				// ADDI x8, x0, 103		// num != 103  -->  .L9
		mem[0120] <= {7'b0000000, 5'd8, 5'd6, `F3_BNE, 5'd6, `OP_BRANCH};		// BNE  x6, x8, .L9		// (123-120)*2=6
		
																				// .L8:
		mem[0121] <= {12'd1, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 1
		mem[0122] <= {20'd4, 5'b00, `OP_JAL};									// JAL  x0, .L10		// (124-122)*2=4
		
																				// .L9:
		mem[0123] <= {12'd0, 5'd0, `F3_ADDI, 5'd9, `OP_OP_IMM};					// ADDI x9, x0, 0
		
																				// .L10:
		mem[0124] <= {`F7_30_0, 5'd9, 5'd5, `F3_ADD, 5'd5, `OP_OP};				// ADD  x5, x5, x9		// count += incr(x9)
		mem[0125] <= {20'd4, 5'b00, `OP_JAL};									// JAL  x0, .L6			// (127-125)*2=4
		
																				// .L7:
		mem[0126] <= {12'd1, 5'd5, `F3_ADDI, 5'd5, `OP_OP_IMM};					// ADDI x5, x5, 1		// count++
		
																				// .L6:
		mem[0127] <= {12'd1, 5'd7, `F3_ADDI, 5'd7, `OP_OP_IMM};					// ADDI x7, x7, 1		// work_address++
		mem[0128] <= {7'b0, 5'd7, 5'd0, `F3_SW, 5'd4, `OP_STORE};				// SW   x7, (o0)		// o0 <- x7
		
																				// .L12:
		mem[0129] <= {12'd255, 5'd0, `F3_ADDI, 5'd10, `OP_OP_IMM};				// ADDI x10, x0, 255	// work_address != 255 --> .L11
		mem[0130] <= {7'b1111000, 5'd10, 5'd7, `F3_BNE, 5'b00100, `OP_BRANCH};	// BNE  x7, x10, .L11	// (4-130)*2=-252=0b111100000100
		
		mem[0131] <= {`F7_30_0, 5'd0, 5'd5, `F3_ADD, 5'd11, `OP_OP};			// ADD  x11, x5, x0		// x11 = x5
		mem[0132] <= {12'b000100000000, 5'd11, `F3_ORI, 5'd11, `OP_OP_IMM};		// ORI  x11, x11, 0x100	// done flag
		mem[0133] <= {12'd8, 5'd11, `F3_SLLI, 5'd11, `OP_OP_IMM};				// SLLI x11, x11, 8
		mem[0134] <= {7'b0, 5'd11, 5'd0, `F3_SW, 5'd4, `OP_STORE};				// SW   x11, (o2, o1 ,o0)	// (o2, o1 ,o0) <- x11

		mem[0135] <= {20'b0, 5'b00, `OP_JAL};									// JAL  x0, .here		// halt
    end
endmodule
