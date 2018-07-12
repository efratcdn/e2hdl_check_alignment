// monitor_ver_2.sv
//
// this file is a modification of monitor.sv. the enum here is not aligned
// with the one defined in e
// 
// to catch such misalignment, use e2hdl checks:
//  xrun -snprecom "set e2hdl checks" monitor_ver_2.sv checker.e -exit
//   
typedef enum {IDLE, ARBI, PREAMBLE, ADDRESS, DATA} state_t;

module monitor;

   reg clk;
   
   initial begin 
     clk = 0;
   end
      
   always
      #1     clk = ~clk;
   
   state_t state = IDLE;
   reg valid = 0;

   always @(negedge clk) begin
      case (state)
	IDLE : begin
	   $display("\n[%3d] Monitor: IDLE moving to ARBI", $time);	 
	   state = ARBI;
	   #20;
	end
	ARBI : begin
	   state = ADDRESS;
	   $display("\n[%3d] Monitor: ARBI moving to ADDRESS", $time);
	   #17;
	end
	ADDRESS : begin
	   state = DATA;
	   valid = 1;
	   $display("\n[%3d] Monitor: ADDRESS moving to DATA", $time);
	   #33;
      end
	DATA : begin
	   state = IDLE;
	   valid = 0;
	   $display("\n[%3d] Monitor: DATA moving to IDLE", $time);
	   #87;
      end
      endcase 
   end

      
endmodule
	    
	    
      
