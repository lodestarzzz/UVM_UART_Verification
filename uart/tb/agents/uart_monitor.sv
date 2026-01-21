//----------------------------------------------------------------------
//  File Name:    uart_monitor.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 10:12:06
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_MONITOR_SV
`define UART_MONITOR_SV

class uart_monitor extends uvm_monitor;
    
    `uvm_component_utils(uart_monitor)

    virtual uart_if vif;

    uvm_analysis_port #(uart_item) mon_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_port = new("mon_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual uart_if)::get(this, "", "uart_if", vif)) begin
            `uvm_fatal("MON", "Could not get vif from config db!")
        end
    endfunction

    task run_phase(uvm_phase phase);
        uart_item item;
        forever begin

            @(negedge vif.uart_rx);
            
            item = uart_item::type_id::create("item");

            repeat(2604) @(posedge vif.clk);

            if(vif.uart_rx != 1'b0) begin
                `uvm_warning("MON", "Detected false start bit, ignoring...")
                continue; 
            end

            item.data = 0;
            for(int i=0; i<8; i++) begin
                repeat(5208) @(posedge vif.clk);
                item.data[i] = vif.uart_rx;
            end

            repeat(5208) @(posedge vif.clk);
            item.stop_bit = vif.uart_rx;

            `uvm_info("MON", $sformatf("Monitored data: 0x%0h", item.data), UVM_HIGH)
            
            mon_port.write(item);
        end
    endtask

endclass

`endif
