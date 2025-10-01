/*
 * Copyright (c) 2025 Timothy Pan
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_counter (
    input  wire [7:0] ui_in,    // ui_in[0]=en, ui_in[1]=load, ui_in[2]=oe
    output wire [7:0] uo_out,   // dedicated outputs (cannot truly tri-state)
    input  wire [7:0] uio_in,   // load_data
    output wire [7:0] uio_out,  // bidir: output path
    output wire [7:0] uio_oe,   // bidir: output enable (1=drive)
    input  wire       ena,      // high when design is selected
    input  wire       clk,
    input  wire       rst_n     // async active-low reset
);

    // Decode controls (keep simple, no fancy priority here)
    wire en   = ui_in[0] & ena;   // gate with ena for safety on shared die
    wire load = ui_in[1];
    wire oe   = ui_in[2];

    // Counter state
    reg [7:0] cnt;

    // Async reset, sync load, then count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)       cnt <= 8'h00;
        else if (load)    cnt <= uio_in;         // synchronous load
        else if (en)      cnt <= cnt + 8'd1;     // increment when enabled
    end

    // Tiny Tapeout pad behavior:
    // - Real tri-state is only on uio_* via uio_oe.
    // - uo_out pads are always driven; we gate the value for display/board logic.
    assign uio_out = cnt;
    assign uio_oe  = {8{oe}};        // drive uio_out only when oe=1

    assign uo_out  = oe ? cnt : 8'h00;  // cannot drive 'Z' on uo_out pads

    // avoid unused warnings
    wire _unused = &{ui_in[7:3], 1'b0};

endmodule
