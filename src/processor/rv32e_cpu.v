`timescale 1ns / 1ps

`include "instructions.v"

// States
`define ST_FETCH        4'b0001
`define ST_DECODE       4'b0010
`define ST_EXECUTE      4'b0100
`define ST_WRITE_BACK   4'b1000

module rv32e_cpu(
    input clk,
    input reset,

    input  [31:0] program_data_bus,
    output [31:0] program_addr_bus,

    input  [31:0] mem_read_data_bus,
    output [31:0] mem_write_data_bus,
    output mem_write_signal,
    output [31:0] mem_addr_bus
);
    // registers (RV32E has 16 registers (x0-x15))
    reg  [31:0] x [5:1];       // x1-x15 are general purpose  (x0 is defined below as it is hardwired to 0)
    reg  [31:0] pc;

    // registers wiring
    wire [31:0] x0 = 0;         // x0 is hardwired to 0

    wire [31:0] x1 = x[1];      // x1-x15 have wires for simulation visualization only
    wire [31:0] x2 = x[2];
    wire [31:0] x3 = x[3];
    wire [31:0] x4 = x[4];
    wire [31:0] x5 = x[5];
//    wire [31:0] x6 = x[6];
//    wire [31:0] x7 = x[7];
//    wire [31:0] x8 = x[8];
//    wire [31:0] x9 = x[9];
//    wire [31:0] x10 = x[10];
//    wire [31:0] x11 = x[11];
//    wire [31:0] x12 = x[12];
//    wire [31:0] x13 = x[13];
//    wire [31:0] x14 = x[14];
//    wire [31:0] x15 = x[15];

    assign program_addr_bus = pc;

    // state machine
    reg [3:0]  state;
    reg [31:0] instruction;

    /* instruction decoding wiring
     *
     * Some ranges are overlapped given that different instruction types use different instruction formats.
     */
    wire [6:0]  opcode   = instruction[6:0];
    wire [4:0]  rd       = instruction[11:7];                           // destination register
    wire [2:0]  funct3   = instruction[14:12];                          // operation selector
    wire [4:0]  rs1      = instruction[19:15];                          // source register 1
    wire [4:0]  rs2      = instruction[24:20];                          // source register 2
    wire [6:0]  funct7   = instruction[31:25];                          // operation selector
    wire [11:0] i_imm    = instruction[31:20];                          // I-type immediate (OP-IMM)
//    wire [19:0] u_imm    = instruction[31:12];                          // U-type immediate (LUI, AUIPC)
    wire [19:0] j_imm    = instruction[31:12];                          // J-type immediate offset (JAL)
    wire [11:0] b_imm    = {instruction[31:25], instruction[11:7]};     // B-type immediate offset (BRANCH)
    wire [11:0] s_imm    = {instruction[31:25], instruction[11:7]};     // S-type immediate (STORE)

    /* internal memory
     *
     * Execution is simplified by decoding all instruction operand types into common 32-bits operands.
     */
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [31:0] result;
    reg [31:0] offset;
    reg [31:0] effective_addr;
    reg write_signal_reg;

    assign mem_addr_bus = effective_addr;
    assign mem_write_data_bus = operand2;   // operand2 will have the content of rs2
    assign mem_write_signal = write_signal_reg;

    // logic
    always @(posedge(clk)) begin
        //$monitor("state=%d, pc=%03d, instruction=%032b", state, pc, instruction);
        if (reset == 0) begin
            state <= `ST_FETCH;
            pc    <= 0;
            x[1]  <= 0;
            x[2]  <= 0;
            x[3]  <= 0;
            x[4]  <= 0;
            x[5]  <= 0;
//            x[6]  <= 0;
//            x[7]  <= 0;
//            x[8]  <= 0;
//            x[9]  <= 0;
//            x[10] <= 0;
//            x[11] <= 0;
//            x[12] <= 0;
//            x[13] <= 0;
//            x[14] <= 0;
//            x[15] <= 0;

            operand1 <= 0;
            operand2 <= 0;
            result <= 0;
            offset <= 0;
            effective_addr <= 0;
            write_signal_reg <= 0;
        end
        else begin
            case (state)
                `ST_FETCH: begin
                    instruction <= program_data_bus;
                    state <= `ST_DECODE;
                end
                `ST_DECODE: begin
                    case (opcode)
                        `OP_LOAD:
                            effective_addr <= (rs1 == 0 ? x0 : x[rs1]) + $signed(i_imm);
                        `OP_STORE: begin
                            effective_addr <= (rs1 == 0 ? x0 : x[rs1]) + $signed(s_imm);
                            operand2 <= rs2 == 0 ? x0 : x[rs2];
                        end
                        `OP_OP_IMM: begin
                            operand1 <= rs1 == 0 ? x0 : x[rs1];
                            operand2 <= $signed(i_imm);
                        end
//                        `OP_LUI, `OP_AUIPC:
//                            result <= {u_imm, 12'b0};
                        `OP_OP: begin
                            operand1 <= rs1 == 0 ? x0 : x[rs1];
                            operand2 <= rs2 == 0 ? x0 : x[rs2];
                        end
                        `OP_JAL:
                            offset <= $signed({j_imm, 1'b0});
//                        `OP_JALR: begin
//                            operand1 <= rs1 == 0 ? x0 : x[rs1];
//                            offset   <= $signed(i_imm);
//                        end
                        `OP_BRANCH: begin
                            operand1 <= rs1 == 0 ? x0 : x[rs1];
                            operand2 <= rs2 == 0 ? x0 : x[rs2];
                            offset   <= $signed({b_imm, 1'b0});
                        end
                        default: begin
                            operand1 <= 0;
                            operand2 <= 0;
                            result <= 0;
                            offset <= 0;
                            effective_addr <= 0;
                        end
                    endcase
                    state <= `ST_EXECUTE;
                end
                `ST_EXECUTE: begin
                    case (opcode)
                        `OP_LOAD: begin
                            if (funct3 == `F3_LW) result <= mem_read_data_bus;
                            state <= `ST_WRITE_BACK;
                        end
                        `OP_STORE: begin
                            if (funct3 == `F3_SW) write_signal_reg <= 1;
                            state <= `ST_WRITE_BACK;
                        end
                        `OP_OP_IMM: begin
                            if (funct3 == `F3_ADDI)       result <= operand1 + operand2;
//                            else if (funct3 == `F3_SLTI)  result <= $signed(operand1) < $signed(operand2);
//                            else if (funct3 == `F3_SLTIU) result <= operand1 < operand2;
//                            else if (funct3 == `F3_XORI)  result <= operand1 ^ operand2;
                            else if (funct3 == `F3_ORI)   result <= operand1 | operand2;
                            else if (funct3 == `F3_ANDI)  result <= operand1 & operand2;
                            else if (funct3 == `F3_SLLI)  result <= operand1 << operand2[4:0];
//                            else if (funct3 == `F3_SRLI_SRAI)
//                                if (operand2[10])   result <= $signed(operand1) >>> operand2[4:0];
//                                else                result <= operand1 >> operand2[4:0];
                            state <= `ST_WRITE_BACK;
                        end
//                        `OP_AUIPC: begin
//                            result <= result + pc;
//                            state <= `ST_WRITE_BACK;
//                        end
                        `OP_OP: begin
                            if (funct7 == `F7_30_0) begin
                                    if (funct3 == `F3_ADD)       result <= operand1 + operand2;
//                                    else if (funct3 == `F3_SLT)  result <= $signed(operand1) < $signed(operand2);
//                                    else if (funct3 == `F3_SLTU) result <= operand1 < operand2;
//                                    else if (funct3 == `F3_XOR)  result <= operand1 ^ operand2;
//                                    else if (funct3 == `F3_OR)   result <= operand1 | operand2;
//                                    else if (funct3 == `F3_AND)  result <= operand1 & operand2;
//                                    else if (funct3 == `F3_SLL)  result <= operand1 << operand2[4:0];
//                                    else if (funct3 == `F3_SRL)  result <= operand1 >> operand2[4:0];
                            end
//                            else if (funct7 == `F7_30_1) begin
//                                    if (funct3 == `F3_SUB)       result <= $signed(operand1) - $signed(operand2);
//                                    else if (funct3 == `F3_SRA)  result <= $signed(operand1) >>> operand2[4:0];
//                            end
                            state <= `ST_WRITE_BACK;
                        end
                        `OP_JAL: begin
                            if (rd != 0) x[rd] <= pc + 4;
                            pc <= pc + offset;
                            state <= `ST_FETCH;
                        end
//                        `OP_JALR: begin
//                            if (rd != 0) x[rd] <= pc + 4;
//                            pc <= (operand1 + offset) & 32'b11111111111111111111111111111110;
//                            state <= `ST_FETCH;
//                        end
                        `OP_BRANCH: begin
                            case (funct3)
                                `F3_BEQ:
                                    if (operand1 == operand2) pc <= pc + offset;
                                    else pc <= pc + 4;
                                `F3_BNE:
                                    if (operand1 != operand2) pc <= pc + offset;
                                    else pc <= pc + 4;
                                `F3_BLT:
                                    if ($signed(operand1) < $signed(operand2)) pc <= pc + offset;
                                    else pc <= pc + 4;
                                `F3_BGE:
                                    if ($signed(operand1) >= $signed(operand2)) pc <= pc + offset;
                                    else pc <= pc + 4;
//                                `F3_BLTU:
//                                    if (operand1 < operand2) pc <= pc + offset;
//                                    else pc <= pc + 4;
//                                `F3_BGEU:
//                                    if (operand1 >= operand2) pc <= pc + offset;
//                                    else pc <= pc + 4;
                                default:
                                    pc <= pc + 4;
                            endcase
                            state <= `ST_FETCH;
                        end
                        default:
                            state <= `ST_WRITE_BACK;
                    endcase
                end
                `ST_WRITE_BACK: begin
                    case (opcode)
                        `OP_LOAD, `OP_OP_IMM, `OP_OP: //, `OP_LUI, `OP_AUIPC:
                            if (rd != 0) x[rd] <= result;
                        default:    // `OP_STORE
                            write_signal_reg <= 0;
                    endcase
                    pc <= pc + 4;
                    state <= `ST_FETCH;
                end
                default: begin
                    // reset
                    state <= `ST_FETCH;
                    pc    <= 0;
                    x[1]  <= 0;
                    x[2]  <= 0;
                    x[3]  <= 0;
                    x[4]  <= 0;
                    x[5]  <= 0;
//                    x[6]  <= 0;
//                    x[7]  <= 0;
//                    x[8]  <= 0;
//                    x[9]  <= 0;
//                    x[10] <= 0;
//                    x[11] <= 0;
//                    x[12] <= 0;
//                    x[13] <= 0;
//                    x[14] <= 0;
//                    x[15] <= 0;

                    operand1 <= 0;
                    operand2 <= 0;
                    result <= 0;
                    offset <= 0;
                    effective_addr <= 0;
                    write_signal_reg <= 0;
                end
            endcase
        end
    end

endmodule
