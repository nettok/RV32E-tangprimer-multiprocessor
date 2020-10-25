`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        Universidad Galileo
// Engineer:       Eduardo Corpeno
// 
// Create Date:    09:01:49 11/21/2010 
// Design Name:    
// Module Name:    EightPortArray 
// Project Name:   EightCore PicoBaze
// Target Devices: 
// Tool versions:  
// Description:    FPGA Class 2016
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Modified to be a 4-port array by Ernesto Menendez.
//
//////////////////////////////////////////////////////////////////////////////////

module FourPortArray(
    output [7:0] DataBus0,
//    output [7:0] DataBus1,
//    output [7:0] DataBus2,
//    output [7:0] DataBus3,
    input [7:0] AddressBus0,
//    input [7:0] AddressBus1,
//    input [7:0] AddressBus2,
//    input [7:0] AddressBus3,
    input reset
    );

  reg [7:0] Data[255:0];

  assign DataBus0 = Data[AddressBus0];
//  assign DataBus1 = Data[AddressBus1];
//  assign DataBus2 = Data[AddressBus2];
//  assign DataBus3 = Data[AddressBus3];	 
	 
 
  always @(negedge reset) begin
      Data[  0] <= 0;    
      Data[  1] <= 1;
      Data[  2] <= 2;    
      Data[  3] <= 3;
      Data[  4] <= 4;    
      Data[  5] <= 5;
      Data[  6] <= 6;    
      Data[  7] <= 7;
      Data[  8] <= 8;    
      Data[  9] <= 9;
      Data[ 10] <= 10;    
      Data[ 11] <= 11;
      Data[ 12] <= 12;    
      Data[ 13] <= 13;
      Data[ 14] <= 14;    
      Data[ 15] <= 15;
      Data[ 16] <= 16;    
      Data[ 17] <= 17;
      Data[ 18] <= 18;    
      Data[ 19] <= 19;
      Data[ 20] <= 20;    
      Data[ 21] <= 21;
      Data[ 22] <= 22;    
      Data[ 23] <= 23;
      Data[ 24] <= 24;    
      Data[ 25] <= 25;
      Data[ 26] <= 26;    
      Data[ 27] <= 27;
      Data[ 28] <= 28;    
      Data[ 29] <= 29;
      Data[ 30] <= 30;    
      Data[ 31] <= 31;
      Data[ 32] <= 32;    
      Data[ 33] <= 33;
      Data[ 34] <= 34;    
      Data[ 35] <= 35;
      Data[ 36] <= 36;    
      Data[ 37] <= 37;
      Data[ 38] <= 38;    
      Data[ 39] <= 39;
      Data[ 40] <= 40;    
      Data[ 41] <= 41;
      Data[ 42] <= 42;    
      Data[ 43] <= 43;
      Data[ 44] <= 44;    
      Data[ 45] <= 45;
      Data[ 46] <= 46;    
      Data[ 47] <= 47;
      Data[ 48] <= 48;    
      Data[ 49] <= 49;
      Data[ 50] <= 50;      
      Data[ 51] <= 51;
      Data[ 52] <= 52;    
      Data[ 53] <= 53;
      Data[ 54] <= 54;    
      Data[ 55] <= 55;
      Data[ 56] <= 56;    
      Data[ 57] <= 57;
      Data[ 58] <= 58;    
      Data[ 59] <= 59;
      Data[ 60] <= 60;     
      Data[ 61] <= 61;
      Data[ 62] <= 62;    
      Data[ 63] <= 63;
      Data[ 64] <= 64;    
      Data[ 65] <= 65;
      Data[ 66] <= 66;    
      Data[ 67] <= 67;
      Data[ 68] <= 68;    
      Data[ 69] <= 69;
      Data[ 70] <= 70;     
      Data[ 71] <= 71;
      Data[ 72] <= 72;    
      Data[ 73] <= 73;
      Data[ 74] <= 74;    
      Data[ 75] <= 75;
      Data[ 76] <= 76;    
      Data[ 77] <= 77;
      Data[ 78] <= 78;    
      Data[ 79] <= 79;
      Data[ 80] <= 80;     
      Data[ 81] <= 81;
      Data[ 82] <= 82;    
      Data[ 83] <= 83;
      Data[ 84] <= 84;    
      Data[ 85] <= 85;
      Data[ 86] <= 86;    
      Data[ 87] <= 87;
      Data[ 88] <= 88;    
      Data[ 89] <= 89;
      Data[ 90] <= 90;     
      Data[ 91] <= 91;
      Data[ 92] <= 92;    
      Data[ 93] <= 93;
      Data[ 94] <= 94;    
      Data[ 95] <= 95;
      Data[ 96] <= 96;    
      Data[ 97] <= 97;
      Data[ 98] <= 98;    
      Data[ 99] <= 99;
      Data[100] <= 100;
      Data[101] <= 101;
      Data[102] <= 102;    
      Data[103] <= 103;
      Data[104] <= 104;    
      Data[105] <= 105;
      Data[106] <= 106;    
      Data[107] <= 107;
      Data[108] <= 108;    
      Data[109] <= 109;
      Data[110] <= 110;    
      Data[111] <= 111;
      Data[112] <= 112;    
      Data[113] <= 113;
      Data[114] <= 114;    
      Data[115] <= 115;
      Data[116] <= 116;    
      Data[117] <= 117;
      Data[118] <= 118;    
      Data[119] <= 119;
      Data[120] <= 120;    
      Data[121] <= 121;
      Data[122] <= 122;    
      Data[123] <= 123;
      Data[124] <= 124;    
      Data[125] <= 125;
      Data[126] <= 126;    
      Data[127] <= 127;
      Data[128] <= 128;    
      Data[129] <= 129;
      Data[130] <= 130;    
      Data[131] <= 131;
      Data[132] <= 132;    
      Data[133] <= 133;
      Data[134] <= 134;    
      Data[135] <= 135;
      Data[136] <= 136;    
      Data[137] <= 137;
      Data[138] <= 138;    
      Data[139] <= 139;
      Data[140] <= 140;    
      Data[141] <= 141;
      Data[142] <= 142;    
      Data[143] <= 143;
      Data[144] <= 144;    
      Data[145] <= 145;
      Data[146] <= 146;    
      Data[147] <= 147;
      Data[148] <= 148;    
      Data[149] <= 149;
      Data[150] <= 150;      
      Data[151] <= 151;
      Data[152] <= 152;    
      Data[153] <= 153;
      Data[154] <= 154;    
      Data[155] <= 155;
      Data[156] <= 156;    
      Data[157] <= 157;
      Data[158] <= 158;    
      Data[159] <= 159;
      Data[160] <= 160;     
      Data[161] <= 161;
      Data[162] <= 162;    
      Data[163] <= 163;
      Data[164] <= 164;    
      Data[165] <= 165;
      Data[166] <= 166;    
      Data[167] <= 167;
      Data[168] <= 168;    
      Data[169] <= 169;
      Data[170] <= 170;     
      Data[171] <= 171;
      Data[172] <= 172;    
      Data[173] <= 173;
      Data[174] <= 174;    
      Data[175] <= 175;
      Data[176] <= 176;    
      Data[177] <= 177;
      Data[178] <= 178;    
      Data[179] <= 179;
      Data[180] <= 180;     
      Data[181] <= 181;
      Data[182] <= 182;    
      Data[183] <= 183;
      Data[184] <= 184;    
      Data[185] <= 185;
      Data[186] <= 186;    
      Data[187] <= 187;
      Data[188] <= 188;    
      Data[189] <= 189;
      Data[190] <= 190;     
      Data[191] <= 191;
      Data[192] <= 192;    
      Data[193] <= 193;
      Data[194] <= 194;    
      Data[195] <= 195;
      Data[196] <= 196;    
      Data[197] <= 197;
      Data[198] <= 198;    
      Data[199] <= 199;
      Data[200] <= 200;
      Data[201] <= 201;
      Data[202] <= 202;    
      Data[203] <= 203;
      Data[204] <= 204;    
      Data[205] <= 205;
      Data[206] <= 206;    
      Data[207] <= 207;
      Data[208] <= 208;    
      Data[209] <= 209;
      Data[210] <= 210;    
      Data[211] <= 211;
      Data[212] <= 212;    
      Data[213] <= 213;
      Data[214] <= 214;    
      Data[215] <= 215;
      Data[216] <= 216;    
      Data[217] <= 217;
      Data[218] <= 218;    
      Data[219] <= 219;
      Data[220] <= 220;    
      Data[221] <= 221;
      Data[222] <= 222;    
      Data[223] <= 223;
      Data[224] <= 224;    
      Data[225] <= 225;
      Data[226] <= 226;    
      Data[227] <= 227;
      Data[228] <= 228;    
      Data[229] <= 229;
      Data[230] <= 230;    
      Data[231] <= 231;
      Data[232] <= 232;    
      Data[233] <= 233;
      Data[234] <= 234;    
      Data[235] <= 235;
      Data[236] <= 236;    
      Data[237] <= 237;
      Data[238] <= 238;    
      Data[239] <= 239;
      Data[240] <= 240;    
      Data[241] <= 241;
      Data[242] <= 242;    
      Data[243] <= 243;
      Data[244] <= 244;    
      Data[245] <= 245;
      Data[246] <= 246;    
      Data[247] <= 247;
      Data[248] <= 248;    
      Data[249] <= 249;
      Data[250] <= 250;      
      Data[251] <= 251;
      Data[252] <= 252;    
      Data[253] <= 253;
      Data[254] <= 254;    
      Data[255] <= 255;
    end
endmodule
