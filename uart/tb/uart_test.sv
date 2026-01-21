//----------------------------------------------------------------------
//  File Name:    uart_test.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 11:20:40
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_TEST_SV
`define UART_TEST_SV

class uart_test extends uvm_test;
    
    `uvm_component_utils(uart_test)

    uart_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uart_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uart_sequence seq;
        seq = uart_sequence::type_id::create("seq");

        phase.raise_objection(this);
        
        seq.start(env.agt.sqr);
        
        #1000ns;

        phase.drop_objection(this);
    endtask

endclass

`endif
