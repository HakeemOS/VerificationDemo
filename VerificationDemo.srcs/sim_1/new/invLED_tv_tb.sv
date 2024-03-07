`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:54:01 AM
// Design Name: 
// Module Name: invLED_tv_tb
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


module invLED_tv_tb();
    reg SW, CLK; 
    wire LED; 

    //test vector format; could also use "logic" instead of reg
    reg exLED; 
    reg [10:0] i, err; //in all examples [32:0] is used, might be industry standard 
    reg [1:0] testVect[1000:0]; 

    invLED_s U1(
        .sw(SW), 
        .clk(CLK), 
        .led(LED)
    );


    always #5 CLK = ~CLK;

    initial begin
        CLK = 0; 

        //readmemb reads from files in decimal, readmemh reads from files in hexadecimal
        $readmemb("tbVector2.txt", testVect); 
        i = 0; 
        err = 0; 
        SW = 0; 

    end

    always @(posedge CLK ) begin
        #7 {SW, exLED} = testVect[i]; 
    end

    always @(negedge CLK ) begin
        if (LED !== exLED) begin
            $display("Incorrect OUT for %b !", {SW}); //curly braces allow to set "%b" to many diff reg 
            $display("OUT: %b (Expected OUT: %b)", exLED, LED);
            err = err + 1; 
        end else begin
            $display(SW, exLED, LED);
        end
        i = i + 1; 
        if (testVect[i] === 4'bx ) begin
            $display("%d Tests completed with %d errors!", i, err);
            $finish; 
        end
    end
endmodule
