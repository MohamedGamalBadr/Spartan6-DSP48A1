module DSP48A1_TB();
parameter A0REG=0, A1REG=1, B0REG=0, B1REG=1;
parameter CREG=1, DREG=1, MREG=1, PREG=1, CARRYINREG=1, CARRYOUTREG=1, OPMODEREG=1;
parameter CARRYINSEL= "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE="SYNC";
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg [7:0] OPMODE;
reg CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
wire [17:0] BCOUT;
wire [47:0] PCOUT, P;
wire [35:0] M;
wire CARRYOUT;
wire CARRYOUTF;
DSP48A1 #(A0REG, A1REG, B0REG, B1REG, CREG, DREG, MREG, PREG, CARRYINREG, CARRYOUTREG, OPMODEREG) dut(A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,
	RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE, CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
initial begin
	CLK=0;
	forever 
	#1 CLK=~CLK;
end

initial begin
    CEA=1; CEB=1; CEC=1; CECARRYIN=1; CED=1; CEM=1; CEOPMODE=1; CEP=1;
    RSTA=1; RSTB=1; RSTC=1; RSTCARRYIN=1; RSTD=1; RSTM=1; RSTOPMODE=1; RSTP=1; 
    D=10; B=10; OPMODE[6]=0; OPMODE[4]=1; A=2; OPMODE[1:0]=1; C=20; OPMODE[7]=0; OPMODE[5]=1; OPMODE[3:2]=3; BCIN=0; PCIN=0; CARRYIN=0;
	repeat(4) 
	@(negedge CLK); 
	RSTA=0; RSTB=0; RSTC=0; RSTCARRYIN=0; RSTD=0; RSTM=0; RSTOPMODE=0; RSTP=0; 
	repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 20 || P != 61 || CARRYOUT != 0 || M != 40 || PCOUT != 61 || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end 

	D=30; B=10; OPMODE[6]=1; OPMODE[4]=1; A=2; OPMODE[1:0]=1; C=20; OPMODE[7]=0; OPMODE[5]=1; OPMODE[3:2]=3;
	repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 20 || P != 61 || CARRYOUT != 0 || M != 40 || PCOUT != 61 || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end 

    D=10; B=10; OPMODE[6]=0; OPMODE[4]=1; A=1; OPMODE[1:0]=1; C=40; OPMODE[7]=1; OPMODE[5]=1; OPMODE[3:2]=3;
    repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 20 || P != 19 || CARRYOUT != 0 || M != 20 || PCOUT != 19 || CARRYOUTF !=0 ) begin
	  $display("There is an error");
	  $stop;
	end

	 D=30; B=10; OPMODE[6]=0; OPMODE[4]=1; A=2; OPMODE[1:0]=0; C=20; OPMODE[7]=0; OPMODE[5]=1; OPMODE[3:2]=0;
	 repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 40 || P != 1 || CARRYOUT != 0 || M != 80 || PCOUT != 1 || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end 

	 D=30; B=10; OPMODE[6]=0; OPMODE[4]=1; A=2; OPMODE[1:0]=2; C=20; OPMODE[7]=0; OPMODE[5]=1; OPMODE[3:2]=0;
	 repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 40 || P != 4 || CARRYOUT != 0 || M != 80 || PCOUT != 4 || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end 

	 D=0; B=10; OPMODE[6]=0; OPMODE[4]=0; A=4; OPMODE[1:0]=3; C=20; OPMODE[7]=0; OPMODE[5]=0; OPMODE[3:2]=0;
	 repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 10 || P != 48'h00000010000A || CARRYOUT != 0 || M != 40 || PCOUT != 48'h00000010000A || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end 
	 D=0; B=10; OPMODE[6]=0; OPMODE[4]=0; A=0; OPMODE[1:0]=3; C=20; OPMODE[7]=0; OPMODE[5]=0; OPMODE[3:2]=1; PCIN=50;
	 repeat(4) 
	@(negedge CLK); 
	if(BCOUT != 10 || P != 60 || CARRYOUT != 0 || M != 0 || PCOUT != 60 || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end 
	 D=50; B=10; OPMODE[6]=0; OPMODE[4]=0; A=1; OPMODE[1:0]=1; C=20; OPMODE[7]=0; OPMODE[5]=0; OPMODE[3:2]=2; PCIN=50;
	 repeat(3) 
	@(negedge CLK); 
	if(BCOUT != 10 || P != 70 || CARRYOUT != 0 || M != 10 || PCOUT != 70 || CARRYOUTF !=0) begin
	  $display("There is an error");
	  $stop;
	end  
	 D=0; B=10; OPMODE[6]=0; OPMODE[4]=0; A=0; OPMODE[1:0]=0; C=48'hFFFFFFFFFFFF; OPMODE[7]=0; OPMODE[5]=1; OPMODE[3:2]=3; PCIN=50;
	 repeat(3) 
	@(negedge CLK); 
	if(BCOUT != 10 || P != 0 || CARRYOUT != 1 || M != 0 || PCOUT != 0 || CARRYOUTF !=1) begin
	  $display("There is an error");
	  $stop;
	end 
	$stop;
end
 initial begin
   $monitor("A=%d,B=%d,DB=%d,CB=%d,CARRYIN=%d,OPMODE=%d,BCIN=%d,RSTA=%d,RSTB=%d,RSTM=%d,RSTP=%d,RSTC=%d,RSTD=%d,RSTCARRYIN=%d,
   	RSTOPMODE=%d,CEA=%d,CEB=%d,CEM=%d,CEP=%d,CEC=%d,CED=%d,CECARRYIN=%d,CEOPMODE=%d,PCIN=%d,BCOUT=%d,PCOUT=%d,P=%d,M=%d,
   	CARRYOUT=%d,CARRYOUTF=%d",A,B,D,C,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE, 
   	CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
end
endmodule