// I-type LOAD
`define OP_LOAD     7'b0000011
`define F3_LW       3'b010

// S-type STORE
`define OP_STORE    7'b0100011
`define F3_SW       3'b010

// I-type OP-IMM
`define OP_OP_IMM   7'b0010011
`define F3_ADDI     3'b000
//`define F3_SLTI     3'b010
//`define F3_SLTIU    3'b011
//`define F3_XORI     3'b100
`define F3_ORI      3'b110
`define F3_ANDI     3'b111

`define F3_SLLI         3'b001
//`define F3_SRLI_SRAI    3'b101

//`define I_NOP       {12'b0, 5'b0, `F3_ADDI, 5'b0, `OP_OP_IMM}   // ADDI x0, x0, 0

// U-type
//`define OP_LUI      7'b0110111
//`define OP_AUIPC    7'b0010111

// R-type
`define OP_OP       7'b0110011
`define F3_ADD      3'b000          // F7_30_0
//`define F3_SUB      3'b000          // F7_30_1
//`define F3_SLT      3'b010          // F7_30_0
//`define F3_SLTU     3'b011          // F7_30_0
//`define F3_XOR      3'b100          // F7_30_0
//`define F3_OR       3'b110          // F7_30_0
//`define F3_AND      3'b111          // F7_30_0
//`define F3_SLL      3'b001          // F7_30_0
//`define F3_SRL      3'b101          // F7_30_0
//`define F3_SRA      3'b101          // F7_30_1

`define F7_30_0     7'b0000000
`define F7_30_1     7'b0100000

// J-type
`define OP_JAL      7'b1101111

// I-type JALR
//`define OP_JALR     7'b1100111

// B-type
`define OP_BRANCH   7'b1100011
`define F3_BEQ      3'b000
`define F3_BNE      3'b001
`define F3_BLT      3'b100
`define F3_BGE      3'b101
//`define F3_BLTU     3'b110
//`define F3_BGEU     3'b111
