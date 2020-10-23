/* 
PSD 2020/21
Lab 1 - Design and verification of a sequential non-restoring divider

*/
//`timescale 1ns/1ns;

module psddivide_tb;
  
parameter CLOCK_PERIOD = 10;

parameter MAX_SIM_TIME = 100_000_000;

  
reg  clock, reset;
reg  start, stop;
reg  [31:0] dividend, divisor;
wire [31:0] quotient, rest;


psddivide psddivide_1
      ( .clock(clock), // master clock and reset
        .reset(reset), 
        .start(start), // set to 1 to start a division
        .stop(stop),   // set to 1 to load output registers
        .dividend(dividend),  // the operands
        .divisor(divisor), 
        .quotient(quotient),  // the results
        .rest(rest) 
        ); 
     
        
// Setup initial signals, generate 50% duty-cycle clock:
initial
begin
  clock = 1'b0;
  reset = 1'b0;
  dividend = 32'd0;
  divisor  = 32'd0;
  start = 1'b0;
  stop  = 1'b0;
  forever
    # (CLOCK_PERIOD / 2 ) clock = ~clock;
end

//---------------------------------------------------
// Apply the initial reset for 1.5 clock cycles:
initial
begin
  # 23 // wait 23 ns to misalign the reset pulse with the clock edges:
  reset = 1;
  # (2 * CLOCK_PERIOD )
  reset = 0;
end

// Set simulation time:
initial
begin
  # ( MAX_SIM_TIME )
  $stop;
end



//---------------------------------------------------
// The verifications:
initial
begin
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h12345678, 32'h0beefeba ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Quotient = %h", quotient );
	$display("Rest = %h", rest );
	execdivide( 32'h00000000, 32'h0beefeba ); // call task
    # ( 10*CLOCK_PERIOD )
	$display("Quotient = %h", quotient );
	$display("Rest = %h", rest );
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h00000001, 32'h00000001 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Quotient = %h", quotient );
	$display("Rest = %h", rest );
	// add more tests to improve the toggle coverage to  more than 95%

end


// Execute a division:
task execdivide;
input [31:0] divdn, divdr;
begin

  dividend = divdn;   // Apply operands
  divisor = divdr;
  @(negedge clock);
  start = 1'b1;       // Assert start
  @(negedge clock );
  start = 1'b0;  
  repeat (32) @(posedge clock);  // Execute division
  @(negedge clock);
  stop = 1'b1;        // Assert stop
  @(negedge clock);
  stop = 1'b0;
 end  
endtask

endmodule
			   
