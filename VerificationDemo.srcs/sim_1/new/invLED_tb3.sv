`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:54:01 AM
// Design Name: 
// Module Name: invLED_tb3
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


module invLED_tb3();
    //cool that I dont need to distinguish INs from OUTs (reg's and wires)
    logic SW, CLK, LED;

    invLED_s U1 (
        .sw(SW), 
        .clk(CLK), 
        .led(LED)
    ); 

    initial begin

        SW <= 0; 
        
        #100
        SW <= 1; 

    end

    //excessive but for completionist sake will include
    always begin
        #5 CLK <= 0; 
        #5 CLK <= 1;   
    end
endmodule
