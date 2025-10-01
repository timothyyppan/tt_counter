/*
 * Copyright (c) 2025 Timothy Pan
 * SPDX-License-Identifier: Apache-2.0
 */

module counter(
  input  wire       clk,
  input  wire       rst_n,     // async, active-low
  input  wire       load,      // sync load
  input  wire       en,        // count enable
  input  wire       oe,        // tri-state enable (for q_z)
  input  wire [7:0] load_data,
  output wire [7:0] q,
  output wire [7:0] q_z
);
  reg [7:0] cnt;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)      cnt <= 8'h00;
    else if (load)   cnt <= load_data;
    else if (en)     cnt <= cnt + 8'd1;
  end
  assign q   = cnt;
  assign q_z = oe ? cnt : 8'bz;
endmodule
