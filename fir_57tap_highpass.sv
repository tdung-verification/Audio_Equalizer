module fir_57tap_highpass(
    input signed [15:0] x,
    input clock_50,
    output signed [15:0] dout
);

    reg signed [15:0] x1;
    reg signed [31:0] xm [0:56];
    reg signed [31:0] xp [0:56];
    
reg signed [15:0] c0  = 0;     // round(0.000030 * 16384) = 0
reg signed [15:0] c1  = 1;     // round(0.000070 * 16384) = 1
reg signed [15:0] c2  = 2;     // round(0.000106 * 16384) = 2
reg signed [15:0] c3  = 2;     // round(0.000099 * 16384) = 2
reg signed [15:0] c4  = 0;     // round(-0.000000 * 16384) = 0
reg signed [15:0] c5  = -4;    // round(-0.000243 * 16384) = -4
reg signed [15:0] c6  = -11;   // round(-0.000658 * 16384) = -11
reg signed [15:0] c7  = -20;   // round(-0.001216 * 16384) = -20
reg signed [15:0] c8  = -30;   // round(-0.001814 * 16384) = -30
reg signed [15:0] c9  = -37;   // round(-0.002259 * 16384) = -37
reg signed [15:0] c10 = -38;   // round(-0.002285 * 16384) = -38
reg signed [15:0] c11 = -26;   // round(-0.001608 * 16384) = -26
reg signed [15:0] c12 = 0;     // round(-0.000000 * 16384) = 0
reg signed [15:0] c13 = 43;    // round(0.002611 * 16384) = 43
reg signed [15:0] c14 = 99;    // round(0.006047 * 16384) = 99
reg signed [15:0] c15 = 161;   // round(0.009814 * 16384) = 161
reg signed [15:0] c16 = 215;   // round(0.013101 * 16384) = 215
reg signed [15:0] c17 = 243;   // round(0.014847 * 16384) = 243
reg signed [15:0] c18 = 227;   // round(0.013889 * 16384) = 227
reg signed [15:0] c19 = 150;   // round(0.009176 * 16384) = 150
reg signed [15:0] c20 = 0;     // round(-0.000000 * 16384) = 0
reg signed [15:0] c21 = -226;  // round(-0.013788 * 16384) = -226
reg signed [15:0] c22 = -518;  // round(-0.031638 * 16384) = -518
reg signed [15:0] c23 = -856;  // round(-0.052276 * 16384) = -856
reg signed [15:0] c24 = -1210; // round(-0.073810 * 16384) = -1210
reg signed [15:0] c25 = -1539; // round(-0.093973 * 16384) = -1539
reg signed [15:0] c26 = -1801; // round(-0.110450 * 16384) = -1801
reg signed [15:0] c27 = -1986; // round(-0.121243 * 16384) = -1986
reg signed [15:0] c28 = 14336; // round(0.875000 * 16384) = 14336
reg signed [15:0] c29 = -1986; // round(-0.121243 * 16384) = -1986
reg signed [15:0] c30 = -1801; // round(-0.110450 * 16384) = -1801
reg signed [15:0] c31 = -1539; // round(-0.093973 * 16384) = -1539
reg signed [15:0] c32 = -1210; // round(-0.073810 * 16384) = -1210
reg signed [15:0] c33 = -856;  // round(-0.052276 * 16384) = -856
reg signed [15:0] c34 = -518;  // round(-0.031638 * 16384) = -518
reg signed [15:0] c35 = -226;  // round(-0.013788 * 16384) = -226
reg signed [15:0] c36 = 0;     // round(-0.000000 * 16384) = 0
reg signed [15:0] c37 = 150;   // round(0.009176 * 16384) = 150
reg signed [15:0] c38 = 227;   // round(0.013889 * 16384) = 227
reg signed [15:0] c39 = 243;   // round(0.014847 * 16384) = 243
reg signed [15:0] c40 = 215;   // round(0.013101 * 16384) = 215
reg signed [15:0] c41 = 161;   // round(0.009814 * 16384) = 161
reg signed [15:0] c42 = 99;    // round(0.006047 * 16384) = 99
reg signed [15:0] c43 = 43;    // round(0.002611 * 16384) = 43
reg signed [15:0] c44 = 0;     // round(-0.000000 * 16384) = 0
reg signed [15:0] c45 = -26;   // round(-0.001608 * 16384) = -26
reg signed [15:0] c46 = -38;   // round(-0.002285 * 16384) = -38
reg signed [15:0] c47 = -37;   // round(-0.002259 * 16384) = -37
reg signed [15:0] c48 = -30;   // round(-0.001814 * 16384) = -30
reg signed [15:0] c49 = -20;   // round(-0.001216 * 16384) = -20
reg signed [15:0] c50 = -11;   // round(-0.000658 * 16384) = -11
reg signed [15:0] c51 = -4;    // round(-0.000243 * 16384) = -4
reg signed [15:0] c52 = 0;     // round(-0.000000 * 16384) = 0
reg signed [15:0] c53 = 2;     // round(0.000099 * 16384) = 2
reg signed [15:0] c54 = 2;     // round(0.000106 * 16384) = 2
reg signed [15:0] c55 = 1;     // round(0.000070 * 16384) = 1
reg signed [15:0] c56 = 0;     // round(0.000030 * 16384) = 0

    wire signed [31:0] ADD [0:56];

    always @ (posedge clock_50) begin
        x1 <= x;
    end

    always @ (posedge clock_50) begin
	 
        xm[0]  <= x1 * c0;
    xm[1]  <= x1 * c1;
    xm[2]  <= x1 * c2;
    xm[3]  <= x1 * c3;
    xm[4]  <= x1 * c4;
    xm[5]  <= x1 * c5;
    xm[6]  <= x1 * c6;
    xm[7]  <= x1 * c7;
    xm[8]  <= x1 * c8;
    xm[9]  <= x1 * c9;
    xm[10] <= x1 * c10;
    xm[11] <= x1 * c11;
    xm[12] <= x1 * c12;
    xm[13] <= x1 * c13;
    xm[14] <= x1 * c14;
    xm[15] <= x1 * c15;
    xm[16] <= x1 * c16;
    xm[17] <= x1 * c17;
    xm[18] <= x1 * c18;
    xm[19] <= x1 * c19;
    xm[20] <= x1 * c20;
    xm[21] <= x1 * c21;
    xm[22] <= x1 * c22;
    xm[23] <= x1 * c23;
    xm[24] <= x1 * c24;
    xm[25] <= x1 * c25;
    xm[26] <= x1 * c26;
    xm[27] <= x1 * c27;
    xm[28] <= x1 * c28;
    xm[29] <= x1 * c29;
    xm[30] <= x1 * c30;
    xm[31] <= x1 * c31;
    xm[32] <= x1 * c32;
    xm[33] <= x1 * c33;
    xm[34] <= x1 * c34;
    xm[35] <= x1 * c35;
    xm[36] <= x1 * c36;
    xm[37] <= x1 * c37;
    xm[38] <= x1 * c38;
    xm[39] <= x1 * c39;
    xm[40] <= x1 * c40;
    xm[41] <= x1 * c41;
    xm[42] <= x1 * c42;
    xm[43] <= x1 * c43;
    xm[44] <= x1 * c44;
    xm[45] <= x1 * c45;
    xm[46] <= x1 * c46;
    xm[47] <= x1 * c47;
    xm[48] <= x1 * c48;
    xm[49] <= x1 * c49;
    xm[50] <= x1 * c50;
    xm[51] <= x1 * c51;
    xm[52] <= x1 * c52;
    xm[53] <= x1 * c53;
    xm[54] <= x1 * c54;
    xm[55] <= x1 * c55;
    xm[56] <= x1 * c56;
    end

    always @ (posedge clock_50) begin
        xp[56] <= xm[56];
         xp[55] <= ADD[56];
    xp[54] <= ADD[55];
    xp[53] <= ADD[54];
    xp[52] <= ADD[53];
    xp[51] <= ADD[52];
    xp[50] <= ADD[51];
    xp[49] <= ADD[50];
    xp[48] <= ADD[49];
    xp[47] <= ADD[48];
    xp[46] <= ADD[47];
    xp[45] <= ADD[46];
    xp[44] <= ADD[45];
    xp[43] <= ADD[44];
    xp[42] <= ADD[43];
    xp[41] <= ADD[42];
    xp[40] <= ADD[41];
    xp[39] <= ADD[40];
    xp[38] <= ADD[39];
    xp[37] <= ADD[38];
    xp[36] <= ADD[37];
    xp[35] <= ADD[36];
    xp[34] <= ADD[35];
    xp[33] <= ADD[34];
    xp[32] <= ADD[33];
    xp[31] <= ADD[32];
    xp[30] <= ADD[31];
    xp[29] <= ADD[30];
    xp[28] <= ADD[29];
    xp[27] <= ADD[28];
    xp[26] <= ADD[27];
    xp[25] <= ADD[26];
    xp[24] <= ADD[25];
    xp[23] <= ADD[24];
    xp[22] <= ADD[23];
    xp[21] <= ADD[22];
    xp[20] <= ADD[21];
    xp[19] <= ADD[20];
    xp[18] <= ADD[19];
    xp[17] <= ADD[18];
    xp[16] <= ADD[17];
    xp[15] <= ADD[16];
    xp[14] <= ADD[15];
    xp[13] <= ADD[14];
    xp[12] <= ADD[13];
    xp[11] <= ADD[12];
    xp[10] <= ADD[11];
    xp[9]  <= ADD[10];
    xp[8]  <= ADD[9];
    xp[7]  <= ADD[8];
    xp[6]  <= ADD[7];
    xp[5]  <= ADD[6];
    xp[4]  <= ADD[5];
    xp[3]  <= ADD[4];
    xp[2]  <= ADD[3];
    xp[1]  <= ADD[2];
    xp[0]  <= ADD[1];
    end

    assign ADD[56] = xp[56] + xm[55];
    assign ADD[55] = xp[55] + xm[54];
    assign ADD[54] = xp[54] + xm[53];
    assign ADD[53] = xp[53] + xm[52];
    assign ADD[52] = xp[52] + xm[51];
    assign ADD[51] = xp[51] + xm[50];
    assign ADD[50] = xp[50] + xm[49];
    assign ADD[49] = xp[49] + xm[48];
    assign ADD[48] = xp[48] + xm[47];
    assign ADD[47] = xp[47] + xm[46];
    assign ADD[46] = xp[46] + xm[45];
    assign ADD[45] = xp[45] + xm[44];
    assign ADD[44] = xp[44] + xm[43];
    assign ADD[43] = xp[43] + xm[42];
    assign ADD[42] = xp[42] + xm[41];
    assign ADD[41] = xp[41] + xm[40];
    assign ADD[40] = xp[40] + xm[39];
    assign ADD[39] = xp[39] + xm[38];
    assign ADD[38] = xp[38] + xm[37];
    assign ADD[37] = xp[37] + xm[36];
    assign ADD[36] = xp[36] + xm[35];
    assign ADD[35] = xp[35] + xm[34];
    assign ADD[34] = xp[34] + xm[33];
    assign ADD[33] = xp[33] + xm[32];
    assign ADD[32] = xp[32] + xm[31];
    assign ADD[31] = xp[31] + xm[30];
    assign ADD[30] = xp[30] + xm[29];
    assign ADD[29] = xp[29] + xm[28];
    assign ADD[28] = xp[28] + xm[27];
    assign ADD[27] = xp[27] + xm[26];
    assign ADD[26] = xp[26] + xm[25];
    assign ADD[25] = xp[25] + xm[24];
    assign ADD[24] = xp[24] + xm[23];
    assign ADD[23] = xp[23] + xm[22];
    assign ADD[22] = xp[22] + xm[21];
    assign ADD[21] = xp[21] + xm[20];
    assign ADD[20] = xp[20] + xm[19];
    assign ADD[19] = xp[19] + xm[18];
    assign ADD[18] = xp[18] + xm[17];
    assign ADD[17] = xp[17] + xm[16];
    assign ADD[16] = xp[16] + xm[15];
    assign ADD[15] = xp[15] + xm[14];
    assign ADD[14] = xp[14] + xm[13];
    assign ADD[13] = xp[13] + xm[12];
    assign ADD[12] = xp[12] + xm[11];
    assign ADD[11] = xp[11] + xm[10];
    assign ADD[10] = xp[10] + xm[9];
    assign ADD[9]   = xp[9]   + xm[8];
    assign ADD[8]   = xp[8]   + xm[7];
    assign ADD[7]   = xp[7]   + xm[6];
    assign ADD[6]   = xp[6]   + xm[5];
    assign ADD[5]   = xp[5]   + xm[4];
    assign ADD[4]   = xp[4]   + xm[3];
    assign ADD[3]   = xp[3]   + xm[2];
    assign ADD[2]   = xp[2]   + xm[1];
    assign ADD[1]   = xp[1]   + xm[0];

    assign dout = ADD[1] >> 14;

endmodule
