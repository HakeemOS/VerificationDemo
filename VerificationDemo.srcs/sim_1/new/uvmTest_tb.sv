`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:54:01 AM
// Design Name: 
// Module Name: uvmTest_tb
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

`include "uvm_macros.svh"
import uvm_pkg::*;

module automatic uvmTest_tb();
        class hw_test extends uvm_test;
            `uvm_component_utils(hw_test)
            string msg; 

            function new(string name="test", uvm_component parent=null);
                super.new(name, parent); 
                msg = "Greetings World! Salutations!";     
            endfunction //new()

            virtual task run_phase(uvm_phase phase);
                uvm_config_db#(string)::get(this, "", "message", msg); 
                //`uvm_info("Demo", "Howdy World! iT wORkED!", UVM_MEDIUM); 
                `uvm_info("Demo", msg, UVM_MEDIUM); 
            endtask 
        endclass //hw_test extends uvm_test

        initial begin
            run_test("hw_test"); 
        end
endmodule
