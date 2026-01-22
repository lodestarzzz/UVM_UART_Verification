//----------------------------------------------------------------------
//  File Name:    uart_agent.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 10:20:52
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_AGENT_SV
`define UART_AGENT_SV

class uart_agent extends uvm_agent;
    
    `uvm_component_utils(uart_agent)

    uart_driver    drv;
    uart_monitor   mon;
    uvm_sequencer #(uart_item) sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        mon = uart_monitor::type_id::create("mon", this);

        if(get_is_active() == UVM_ACTIVE) begin
            drv = uart_driver::type_id::create("drv", this);
            sqr = uvm_sequencer#(uart_item)::type_id::create("sqr", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        if(get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

endclass

`endif
