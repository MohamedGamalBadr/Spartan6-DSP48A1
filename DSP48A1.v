module DSP48A1(A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
	CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
parameter A0REG=0, A1REG=1, B0REG=0, B1REG=1;
parameter CREG=1, DREG=1, MREG=1, PREG=1, CARRYINREG=1, CARRYOUTREG=1, OPMODEREG=1;
parameter CARRYINSEL= "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE="SYNC";
input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input [7:0] OPMODE;
input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
output [17:0] BCOUT;
output [47:0] PCOUT, P;
output [35:0] M;
output   CARRYOUT;
output CARRYOUTF;
reg [17:0] B_OR_BCIN;
wire [17:0] D_mux_out,B0_mux_out,A0_mux_out;
wire [47:0] C_mux_out;
wire [17:0] B1_mux_out,A1_mux_out;
wire [7:0] OPMODE_MUX_OUT;
reg  [35:0] MULTPLIER_RESULT; 
reg CARRYCASCADE_MUX, carry_out_postadder;
wire CIN;
reg [47:0] POST_ADDER;
reg [17:0] pre_adder_result, PRE_ADDER_MUX;
reg [47:0] x_mux_out, z_mux_out;
block #(.RSTTYPE(RSTTYPE), .mux_sel(DREG),.NUMBER_BITS(18)) D_MUX(CLK,CED, RSTD,D, D_mux_out);
block #(.RSTTYPE(RSTTYPE), .mux_sel(B0REG),.NUMBER_BITS(18)) B0_MUX(CLK,CEB, RSTB,B_OR_BCIN, B0_mux_out);
block #(.RSTTYPE(RSTTYPE), .mux_sel(A0REG),.NUMBER_BITS(18)) A0_MUX(CLK,CEA, RSTA,A, A0_mux_out);
block #(.RSTTYPE(RSTTYPE), .mux_sel(CREG),.NUMBER_BITS(48)) C_MUX(CLK,CEC, RSTC,C, C_mux_out);
block #(.RSTTYPE(RSTTYPE), .mux_sel(B1REG),.NUMBER_BITS(18)) B1_MUX(CLK,CEB, RSTB,PRE_ADDER_MUX, B1_mux_out);
block #(.RSTTYPE(RSTTYPE), .mux_sel(A1REG),.NUMBER_BITS(18)) A1_MUX(CLK,CEA, RSTA,A0_mux_out, A1_mux_out);
block #(.RSTTYPE(RSTTYPE), .mux_sel(MREG),.NUMBER_BITS(36)) M_MUX(CLK,CEM, RSTM,MULTPLIER_RESULT, M);

block #(.RSTTYPE(RSTTYPE), .mux_sel(CARRYINREG),.NUMBER_BITS(1)) CYI_MUX(CLK,CECARRYIN, RSTCARRYIN,CARRYCASCADE_MUX, CIN);
block #(.RSTTYPE(RSTTYPE), .mux_sel(CARRYOUTREG),.NUMBER_BITS(1)) CYO_MUX(CLK,CECARRYIN, RSTCARRYIN,carry_out_postadder, CARRYOUT);
block #(.RSTTYPE(RSTTYPE), .mux_sel(PREG),.NUMBER_BITS(48)) P_MUX(CLK,CEP, RSTP,POST_ADDER, P);
block #(.RSTTYPE(RSTTYPE), .mux_sel(OPMODEREG),.NUMBER_BITS(8)) OPMODE_MUX(CLK,CEOPMODE, RSTOPMODE,OPMODE, OPMODE_MUX_OUT);

always @ (*) begin
   if (B_INPUT == "DIRECT")
       B_OR_BCIN=B;
       else if (B_INPUT == "CASCADE")
        B_OR_BCIN=BCIN;
        else 
        B_OR_BCIN=0;

	if(OPMODE_MUX_OUT[6] == 0 )
           pre_adder_result=D_mux_out + B0_mux_out;
       else 
        pre_adder_result=D_mux_out - B0_mux_out;

        if (OPMODE_MUX_OUT[4] == 0)
               PRE_ADDER_MUX=B0_mux_out;
         else 
            PRE_ADDER_MUX=pre_adder_result;
         
         MULTPLIER_RESULT= B1_mux_out * A1_mux_out;

         if( CARRYINSEL == "OPMODE5") 
              CARRYCASCADE_MUX= OPMODE_MUX_OUT[5];
            else if( CARRYINSEL == "CARRYIN")
              CARRYCASCADE_MUX= CARRYIN;
             else 
               CARRYCASCADE_MUX= 0;

               case (OPMODE_MUX_OUT[1:0])
               0: x_mux_out=0;
               1: x_mux_out={12'd0,M};
               2: x_mux_out=P;
               3: x_mux_out={D_mux_out[11:0],A1_mux_out[17:0],B1_mux_out[17:0]};
               endcase

               case(OPMODE_MUX_OUT[3:2])
               0: z_mux_out=0;
               1: z_mux_out=PCIN;
               2: z_mux_out=P;
               3: z_mux_out=C_mux_out;
               endcase

               if(OPMODE_MUX_OUT[7])
                  {carry_out_postadder,POST_ADDER}=z_mux_out - (x_mux_out+CIN);
                 else 
                   {carry_out_postadder,POST_ADDER}=z_mux_out+x_mux_out+CIN;
end

assign PCOUT=P;
assign CARRYOUTF=CARRYOUT;
assign BCOUT=B1_mux_out;
endmodule