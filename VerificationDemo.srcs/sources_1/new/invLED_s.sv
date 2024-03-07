`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:46:44 AM
// Design Name: 
// Module Name: invLED_s
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module invLED_s(sw, clk, led);
    input sw, clk; 
    output reg led; 

    always @(posedge clk ) begin
        if (sw == 1) begin
            led = 0; 
        end else begin
            led = 1; 
        end
    end
endmodule
