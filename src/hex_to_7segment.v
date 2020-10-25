module hex_to_7segment(
	input [3:0] hex,
	output reg [6:0] segments
);
	localparam error = 7'b0000000;

    always @(hex) begin
        case (hex)
            4'h0 : segments <= 7'b1111110;
            4'h1 : segments <= 7'b0110000;
            4'h2 : segments <= 7'b1101101;
            4'h3 : segments <= 7'b1111001;
            4'h4 : segments <= 7'b0110011;
            4'h5 : segments <= 7'b1011011;
            4'h6 : segments <= 7'b1011111;
            4'h7 : segments <= 7'b1110000;
            4'h8 : segments <= 7'b1111111;
            4'h9 : segments <= 7'b1110011;
            4'hA : segments <= 7'b1110111;
            4'hB : segments <= 7'b0011111;
            4'hC : segments <= 7'b1001110;
            4'hD : segments <= 7'b0111101;
            4'hE : segments <= 7'b1001111;
            4'hF : segments <= 7'b1000111;
			default : segments <= error;
        endcase
    end
endmodule
