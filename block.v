module block(clk,enable_clk, reset,in, out);
parameter RSTTYPE = "SYNC";
parameter mux_sel = 1;
parameter NUMBER_BITS=18;
input clk, enable_clk, reset;
input [NUMBER_BITS-1:0] in;
output reg [NUMBER_BITS-1:0] out;
 reg [NUMBER_BITS-1:0] in_reg_async;
 reg [NUMBER_BITS-1:0] in_reg_sync;
 reg [NUMBER_BITS-1:0] in_reg;
 always @(posedge clk) begin 
   if (enable_clk) begin
      if (reset) begin
        in_reg_sync <=0;
        end
        else begin
        in_reg_sync<=in;
        end
   end
 end
 always @(posedge clk or posedge reset) begin
 	if (reset) begin
 	  in_reg_async <=0;
 	  end
 	 else if (enable_clk) begin
 	 in_reg_async<=in;
 	 end
 end
always@(*) begin
	if(RSTTYPE == "SYNC" ) begin
	  in_reg= in_reg_sync;
	  end
	  else begin
	  in_reg=in_reg_async;
        end
	  if(mux_sel) begin
         out= in_reg;
         end
         else begin
         out = in;
         end
end
endmodule