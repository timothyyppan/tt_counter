/*
 * Copyright (c) 2025 Timothy Pan
 * SPDX-License-Identifier: Apache-2.0
 */

module counter_8bit (
    input wire clk,           // Clock input
    input wire rst_n,         // Asynchronous active-low reset
    input wire load,          // Synchronous load enable
    input wire count_en,      // Count enable
    input wire [7:0] data_in, // Parallel load data
    input wire oe,            // Output enable (for tri-state)
    output wire [7:0] count_out // Counter output (tri-state)
);

    // Internal counter register
    reg [7:0] counter;
    
    // Counter logic with asynchronous reset and synchronous load
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset - counter goes to 0
            counter <= 8'b0;
        end else begin
            if (load) begin
                // Synchronous load - load data_in into counter
                counter <= data_in;
            end else if (count_en) begin
                // Count up when enabled
                counter <= counter + 1'b1;
            end
            // If neither load nor count_en, counter holds value
        end
    end
    
    // Tri-state output logic
    assign count_out = oe ? counter : 8'bz;

endmodule
