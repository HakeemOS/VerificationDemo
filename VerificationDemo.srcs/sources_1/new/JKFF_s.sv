`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 09:24:55 AM
// Design Name: 
// Module Name: JKFF_s
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


module JKFF_s(jk, clk, q, qn);
    input [1:0] jk; 
    input clk;
    
    output reg q, qn; 

    reg qTemp; 

    always @(posedge clk ) begin
        case (jk)
            2'b01 : begin
                q = 0; 
                qTemp = 0; 
            end 
            2'b10 : begin
                q = 1;
                qTemp = 1; 
            end
                
            2'b11 : begin
                q = ~q;
                qTemp = ~qTemp; 
            end
            default: 
                q = q; 
        endcase
    end

    assign qn = ~qTemp; 
endmodule
