`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:49:51 AM
// Design Name: 
// Module Name: invLED_tb
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


module invLED_tb();
    reg SW, CLK; 
    wire LED; 

    //shorthand but not obvious what is being connected to what; maybe good for simple stuff but once components increase in size becomes unclear
    invLED_s U1(SW, CLK, LED); 

    //preferred clk method
    always #5 CLK = ~CLK; 

    initial begin
        
        CLK = 0; 
        SW = 1; 

        #100
        SW = 0; 

    end
endmodule
