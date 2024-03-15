`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2024 09:22:55 AM
// Design Name: 
// Module Name: JKFF_utb
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

class jkff_seq_item extends uvm_sequence_item;

    `uvm_object_utils(jkff_seq_item)
    function new(string name="jkff_seq_item");
        super.new(name); 
    endfunction 
endclass //jkff_seq_item extends uvm_sequence_item

class seq1 extends uvm_sequence #(jkff_seq_item);

    `uvm_object_utils(seq1)
    function new(string name="seq1");
        super.new(name);
    endfunction //new()
endclass //seq1 extends uvm_sequence #(jkff_seq_item)

class seq2 extends uvm_sequence #(jkff_seq_item);

    `uvm_object_utils(seq2)
    function new(string name="seq2");
        super.new(name);
    endfunction //new()
endclass //seq2 extends uvm_sequence #(jkff_seq_item)

class seq3 extends uvm_sequence #(jkff_seq_item);

    `uvm_object_utils(seq3)
    function new(string name="seq3");
        super.new(name);
    endfunction //new()
endclass //seq3 extends uvm_sequence #(jkff_seq_item)

class jkff_sequencer extends uvm_sequencer #(jkff_seq_item);

    `uvm_component_utils(jkff_sequencer)
    function new(string name="jkff_sequencer", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()
endclass //jkff_sequencer extends uvm_sequencer

class jkff_driver extends uvm_driver #(jkff_seq_item);

    `uvm_component_utils(jkff_driver)
    function new(string name="jkff_driver", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()
endclass //jkff_driver extends uvm_driver

module JKFF_utb();


endmodule
