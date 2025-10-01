`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
tt_um_counter user_project (

`ifdef GL_TEST
  .VPWR(VPWR),
  .VGND(VGND),
`endif
   
  .ui_in  (ui_in),
  .uo_out (uo_out),
  .uio_in (uio_in),
  .uio_out(uio_out),
  .uio_oe (uio_oe),
  .ena    (ena),
  .clk    (clk),
  .rst_n  (rst_n)
);

endmodule
