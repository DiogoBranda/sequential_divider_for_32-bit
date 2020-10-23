/*
Digital Systems Design 2020/2021

Lab project 1 - Sequential unsigned non-restoring divider

Author: Diogo Silva
Date: 21-10-2020

Comments:

*/
module psddivide(
  input clock,            // master clock
  input reset,            // synchronous reset, active high
  input start,            // set to 1 to start a new division
  input stop,             // set to 1 to load the output registers
  input [31:0] dividend,  // operand dividend
  input [31:0] divisor,   // operand divisor
  output [31:0] quotient, // result quotient
  output [31:0] rest      // result rest
  );

//Wire

wire clock;// master clock
wire reset; // synchronous reset, active high
wire start;// set to 1 to start a new division
wire stop;// set to 1 to load the output registers
wire [31:0] divisor;// operand dividend
wire [31:0] dividend;// operand divisor
wire [30:0] rmux_R_rdiv; // mux output
wire [32:0] prest;// A-B output
wire [33:0] rmux_L_rdiv_1 ;// mux output
wire[33:0] rmux_L_rdiv_2 ; // mux output


// Reg definition 

reg quotient; // result quotient
reg rest; // result rest
reg [63:0] rdiv; // internal register for dividend value
reg [31:0] rdivisor;// internal register for divisor value

assign rmux_R_rdiv = (start) ? dividend[30:0]:{rdiv[29:0],~prest[32]};

assign rmux_L_rdiv_1 = (prest[32]) ? rdiv[62:30]:{prest[31:0],rdiv[30]};

assign rmux_L_rdiv_2 = (start) ?  {32'd0,dividend[31]}:rmux_L_rdiv_1 ;

assign prest = rdiv[63:31] - {1'b0,rdivisor};

always @(posedge clock) 
begin 

	if (reset) begin
		rdiv <= 64'b0;
		rdivisor <= 32'b0;
		
	end  else begin
		rdivisor <= divisor;
		rdiv  <= {rmux_L_rdiv_2,rmux_R_rdiv};	
	end
end

always @(posedge stop) 
begin 
	if (stop) begin
		quotient <=rdiv[31:0];
		rest <=  rdiv[63:32];
	end else begin
		rdivisor <= 32'b0;
		rdiv  <= 32'b0;	
	end
end
endmodule
