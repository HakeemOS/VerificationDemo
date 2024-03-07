`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:54:01 AM
// Design Name: 
// Module Name: invLED_tb2
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


module invLED_tb2();
    reg SW, CLK; 
    wire LED; 

    initial begin
        CLK = 0; 
        forever #5 CLK = ~CLK; 
    end

    initial begin
        
        SW = 1; 

        #100
        SW = 0; 

        #100
        SW = 1; 

    end

    invLED_s U1 (
        .sw(SW), 
        .clk(CLK), 
        .led(LED)
    ); 
endmodule
