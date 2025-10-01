/*
 * Copyright (c) 2025 Timothy Pan
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_counter(
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);
  wire en   = ui_in[0] & ena;
  wire load = ui_in[1];
  wire oe   = ui_in[2];

  wire [7:0] q, q_z;

  counter u_cnt(
    .clk(clk), .rst_n(rst_n),
    .load(load), .en(en), .oe(oe),
    .load_data(uio_in),
    .q(q), .q_z(q_z)
  );

  assign uio_out = q;
  assign uio_oe  = {8{oe}};

  assign uo_out  = oe ? q : 8'h00;
endmodule
