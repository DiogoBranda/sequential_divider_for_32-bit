/*
Digital Systems Design 2020/2021

Lab project 1 - Sequential unsigned non-restoring divider

Author: Diogo Silva
Date: 21-10-2020

Comments:

*/
module psddivide(
  input wire clock,            // master clock
  input wire reset,            // synchronous reset, active high
  input wire start,            // set to 1 to start a new division
  input wire stop,             // set to 1 to load the output registers
  input reg [31:0] dividend,  // operand dividend
  input reg [31:0] divisor,   // operand divisor
  output reg [31:0] quotient, // result quotient
  output reg [31:0] rest      // result rest
  );

//Wire

wire [30:0] rmux_R_rdiv; // mux output
wire [32:0] prest;// A-B output
wire [33:0] rmux_L_rdiv_1 ;// mux output
wire[33:0] rmux_L_rdiv_2 ; // mux output


// Reg definition 


reg [63:0] rdiv; // internal register for dividend value
reg [31:0] rdivisor;// internal register for divisor value

//Logica combinacional 
assign rmux_R_rdiv = (start) ? dividend[30:0]:{rdiv[29:0],~prest[32]}; // Mux 

assign rmux_L_rdiv_1 = (prest[32]) ? rdiv[62:30]:{prest[31:0],rdiv[30]}; // Mux

assign rmux_L_rdiv_2 = (start) ?  {32'd0,dividend[31]}:rmux_L_rdiv_1 ; //Mux 

assign prest = rdiv[63:31] - {1'b0,rdivisor};// subtrator 

// circuito sincrono reset e clock sincrono 
always @(posedge clock) 
begin 

	if (reset) begin // quando recebe o signal reset mete tudo a zeros
		rdiv <= 64'b0;
		rdivisor <= 32'b0;
		
	end  else if (stop) begin // quando recebe o stop guarda o resultado final
		quotient <=rdiv[31:0];
		rest <=  rdiv[63:32];
	end else begin // Caso contrario atribui os valores a baixo
		rdivisor <= divisor;
		rdiv  <= {rmux_L_rdiv_2,rmux_R_rdiv};	
	end
	
end


endmodule
