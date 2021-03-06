/* 
PSD 2020/21
Lab 1 - Design and verification of a sequential non-restoring divider

*/
`timescale 1ns/1ns

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
	$display("Teste 1");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h12345678, 32'h0beefeba ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 2");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h00000000, 32'h00000000 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 3");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h00000001, 32'h00000000 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 4");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h00000001, 32'h00000001 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 5");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h11111111, 32'h11111111 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 6");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'haaeeffdd, 32'h000011ee ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 7");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'hedca1234, 32'h0beefeba ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 8");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h11111111, 32'hffffffff ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 9");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'hffffffff, 32'h0beefeba ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 10");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'h0000ffff, 32'hffffffff ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 11");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'hefffffff, 32'hffffffff ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 12");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'hffffffff, 32'h00000001 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Teste 13");
	# ( 10*CLOCK_PERIOD )
	execdivide( 32'hefffffff, 32'h11111111 ); // call task
	# ( 10*CLOCK_PERIOD )
	$display("Test end");

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
  if ( quotient == (divdn / divdr ) )   // testa o quotient
		begin
			$display("Quotient = %h correct", quotient);
		end else begin
			$display("Quotient = %h wrong correct is = %h", quotient,(divdn / divdr ));
	end
	if ( rest == (divdn % divdr ) )   // testa o rest
		begin
			$display("Rest = %h correct", rest);
		end else begin
			$display("Rest = %h wrong correct is %h", rest,(divdn % divdr ));
	end
  
 end  
endtask

endmodule
			   
