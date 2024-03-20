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

class jkff_seq_item extends uvm_sequence_item;              //used to add class to registery with INs and OUTs
    rand bit [1:0] jk;
    bit q, qn; 

    `uvm_object_utils_begin(jkff_seq_item)                  //order of list matters 
        `uvm_field_int(jK, UVM_DEFAULT+UVM_DEC)
        `uvm_field_int(q, UVM_DEFAULT+UVM_DEC)
        `uvm_field_int(qn, UVM_DEFAULT+UVM_DEC)        
    `uvm_object_utils_end

    function new(string name="jkff_seq_item");
        super.new(name); 
    endfunction 
endclass //jkff_seq_item extends uvm_sequence_item



class seq1 extends uvm_sequence #(jkff_seq_item);

    `uvm_object_utils(seq1)
    function new(string name="seq1");
        super.new(name);
    endfunction //new()

    virtual task automatic body();
        req = jkff_seq_item::type_id::create("req");        // built in object of uvm of transaction class; this uses factory to create object
        
        repeat(6) begin
            start_item(req); 
            void'(req.randomize()); 
            `uvm_info(get_type_name(), "Seq 1: Data sent to driver...", UVM_NONE)
            req.print(); 
            finish_item(req); 
            // `uvm_do(req); this line does all the work from start_item to finish_item
            // `uvm_do_with(req.constraint if any) ; line above with constraint(s)
        end
    endtask //automatic
endclass //seq1 extends uvm_sequence #(jkff_seq_item)



class seq2 extends uvm_sequence #(jkff_seq_item);

    `uvm_object_utils(seq2)
    function new(string name="seq2");
        super.new(name);
    endfunction //new()

    virtual task automatic body();
        req = jkff_seq_item::type_id::create("req");                                        //this uses factory to create object

        repeat(8) begin
            start_item(req); 
            void'(req.randomize()); 
            `uvm_info(get_type_name(), "Seq 2: Data sent to driver...", UVM_NONE)
            req.print(); 
            finish_item(req); 
        end
    endtask //automatic
endclass //seq2 extends uvm_sequence #(jkff_seq_item)



class seq3 extends uvm_sequence #(jkff_seq_item);

    `uvm_object_utils(seq3)
    function new(string name="seq3");
        super.new(name);
    endfunction //new()

    virtual task automatic body();
        req = jkff_seq_item::type_id::create("req");                                        //this uses factory to create object

        repeat(4) begin
            start_item(req); 
            void'(req.randomize()); 
            `uvm_info(get_type_name(), "Seq 3: Data sent to driver...", UVM_NONE)
            req.print(); 
            finish_item(req); 
        end
    endtask //automatic
endclass //seq3 extends uvm_sequence #(jkff_seq_item)



class jkff_sequencer extends uvm_sequencer #(jkff_seq_item);

    `uvm_component_utils(jkff_sequencer)
    function new(string name="jkff_sequencer", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()
endclass //jkff_sequencer extends uvm_sequencer



class jkff_driver extends uvm_driver #(jkff_seq_item);
    virtual jkff_if vif; 

    `uvm_component_utils(jkff_driver)
    function new(string name="jkff_driver", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req = jkff_seq_item::type_id::create("req");                                        //this uses factory to create object
        if (!uvm_config_db #(virtual jkff_if)::get(this, "", "virtual_if", vif)) begin      //virtual_if is set in top level of test bench (in module of this file)
            `uvm_fatal(get_type_name(),"Unable to retrieve interface... ")
        end
    endfunction

    task automatic drive();
        forever begin
            jkff_seq_item_port.get_next_item(req);                                          //send a request to get seq item/transaction and wait for it; port vars may be incorrect might be uvm base class generated var/handles, if so change by removing jkff
            vif.jk <= req.jk;                                                               //seems to be non-blocking assignment; sequential behaviour desired (assumption)
            `uvm_info(get_type_name(), "Driver: Sending data to DUT/UUT...", UVM_NONE); 
            req.print(); 
            jkff_seq_item_port.item_done();                                                 //send ack or request

            repeat(2) @(posedge vif.clk);                                                   // delay code; delay can be placed in the jkff_seq_item_port statements (after print line) with the same resulting code functionality
        end
    endtask //automatic

    // task used because run_phase contains timing/sequential logic
    virtual task automatic run_phase(uvm_phase phase);   
        //super.run_phase(phase);                                                           not necessary for sequential phases
        drive(); 
    endtask //automatic
endclass //jkff_driver extends uvm_driver



class jkff_monitor extends uvm_monitor;
    jkff_seq_item txn;

    virtual jkff_if vif;  

    uvm_analysis_port #(jkff_seq_item) ap; 

    `uvm_component_utils(jkff_monitor)
    function new(string name="jkff_monitor", uvm_component parent);
        super.new(name, parent); 
        ap = new("ap", this);                                                               //allocating mem for the ap; can be done here or in build_phase
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        txn = jkff_seq_item::type_id::create("txn", this);                                  //this uses factory to create object
        if (!uvm_config_db #(virtual jkff_if)::get(this, "", "virtual_if", vif)) begin
            `uvm_fatal(get_type_name(), "Unable to retrieve interface..."); 
        end
    endfunction

    task automatic capture();
        forever begin
            repeat(2) @(posedge vif.clk);                                                   //delay code; 
            txn.jk = vif.jk;                                                                //apparently either blocking or non-blocking assignment can be used; all examples seen use blocking
            txn.q = vif.q; 
            txn.qn = vif.qn; 
            `uvm_info(get_type_name(), "Monitor: Sending data to scoreboard...", UVM_NONE); 
            txn.print(); 
            ap.write(txn);                                                                  //collect data captured to the ap; non blocking method
        end
    endtask //automatic

    virtual task automatic run_phase(uvm_phase phase);
        //super.run_phase(phase); not neccessary for sequential phases 
        capture(); 
    endtask //automatic
endclass //jkff_monitor extends uvm_monitor



class agent_config extends uvm_object_utils;
    uvm_active_passive_enum is_active = UVM_ACTIVE;                                         //we use this instead of normal enum because it is 2 bit instead of int type 2^32 for normal enum; save mem
    //uvm_active_passive_enum agent_type = UVM_ACTIVE; also works  
    `uvm_object_utils(agent_config)
    function new(string name="agent_config");
        super.new(name);
    endfunction //new()
endclass //agent_config extends uvm_object_utils



class jkff_agent extends uvm_agent;
    agent_config a_cofig; 
    jkff_sequencer jkff_seqr; 
    jkff_driver jkff_drvr;
    jkff_monitor jkff_mon;  

    `uvm_component_utils(jkff_agent)
    function new(string name="jkff_agent", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a_config = agent_config::type_id::create("a_config");                               //this uses factory to create object
        jkff_mon = jkff_monitor::type_id::create("jkff_mon", this);  
        if (!uvm_config_db #(agent_config)::get(this, "", "agent_configuration", agent_config)) begin                   //this is set in top level like key virtual_if
            `uvm_fatal(get_type_name(), "Unable to get() agent configuration from uvm_config_db; Ensure set...")
        end
        if (agent_config.is_active == UVM_ACTIVE) begin                                     //can also use; if(get_is_active() ==UVM_ACTIVE) begin ...
            jkff_seqr = jkff_sequencer::type_id::create("jkff_seqr", this); 
            jkff_drvr = jkff_driver::type_id::create("jkff_drvr", this); 
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (agent_config.is_active == UVM_ACTIVE) begin
            jkff_drvr.jkff_seq_item_port.connect(jkff_seqr.jkff_seq_item_export);           //port vars may be incorrect might be uvm base class generated var/handles, if so change by removing jkff 
        end
    endfunction
endclass //jkff_agent extends uvm_agent



class jkff_scoreboard extends uvm_scoreboard;
    jkff_seq_item data;                                                                     //might rename to txn; 

    uvm_analysis_imp #(jkff_seq_item, jkff_scoreboard) aip; 

    `uvm_component_utils(jkff_scoreboard)
    function new(string name="jkff_scoreboard", uvm_component parent);
        super.new(name, parent); 
        aip = new("aip", this); 
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        data = jkff_seq_item::type_id::create("data");                                      
    endfunction

    virtual function void write ( jkff_seq_item t);
        'uvm_info(get_type_name(), "Data recv'd from Monitor Analysis Port...", UVM_NONE)
        t.print(); 
        case (t.jK)
            2'b01 : begin
                if ((t.q == 0) && (t.qn == 1)) begin
                    'uvm_info(get_type_name(), "PASS!", UVM_NONE)
                end else begin
                    `uvm_info(get_type_name(), "FAIL!", UVM_NONE)
                end
            end 
            2'b10 : begin
                if ((t.q == 1) && (t.qn == 0)) begin
                    'uvm_info(get_type_name(), "PASS!", UVM_NONE)
                end else begin
                    `uvm_info(get_type_name(), "FAIL!", UVM_NONE)
                end
            end
            2'b11 : begin
                `uvm_info(get_type_name(), "MUST DETERMINE PASS/FAIL STATEMENT(S)", UVM_NONE)
            end
            default:
                `uvm_info(get_type_name(), "MUST DETERMINE PASS/FAIL STATEMENT(S)", UVM_NONE) 
        endcase
        
    endfunction
endclass //jkff_scoreboard extends uvm_scoreboard



class jkff_env extends uvm_env;
    jkff_scoreboard jkff_sb; 
    jkff_agent jkff_a; 

    `uvm_component_utils(jkff_env)
    function new(string name="jkff_env", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        jkff_sb = jkff_scoreboard::type_id::create("jkff_sb", this);
        jkff_agt = jkff_agent::type_id::create("jkff_agt", this); 
    endfunction
endclass //jkff_env extends uvm_env

class jkff_test extends uvm_test;

    `uvm_component_utils(jkff_test)
    function new(string name="jkff_test", uvm_component parent);
        super.new(name, parent); 
    endfunction //new()
endclass //jkff_test extends uvm_test

class t1 extends jkff_test;

    `uvm_component_utils(t1)
    function new(string name="test 1", uvm_component parent);
        super.new(name, parent);
    endfunction //new()
endclass //t1 extends jkff_test

module JKFF_utb();


endmodule
