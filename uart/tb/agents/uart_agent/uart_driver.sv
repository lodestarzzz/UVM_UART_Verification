//----------------------------------------------------------------------
//  File Name:    uart_driver.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-20 13:11:25
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------

`ifndef UART_DRIVER_SV
`define UART_DRIVER_SV

class uart_driver extends uvm_driver #(uart_item);
    
    `uvm_component_utils(uart_driver)

    virtual uart_if vif;
    uvm_analysis_port #(uart_item) drv_port;


    function new(string name, uvm_component parent);
        super.new(name, parent);
        drv_port = new("drv_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual uart_if)::get(this, "", "uart_if", vif)) begin
            `uvm_fatal("DRV", "Could not get vif from config db!")
        end
    endfunction

    task run_phase(uvm_phase phase);
        vif.uart_rx <= 1'b1; 
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRV", $sformatf("Driving data: 0x%0h", req.data), UVM_HIGH)
            drv_port.write(req); 
            drive_item(req);
            `uvm_info("DRV", "Sent item to Scoreboard for comparison", UVM_HIGH)
            seq_item_port.item_done();
        end
    endtask

    task drive_item(uart_item item);
        repeat(item.delay) @(posedge vif.clk);
        @(posedge vif.clk);
        vif.uart_rx <= item.start_bit; 

        repeat(5208) @(posedge vif.clk); 

        for(int i=0; i<8; i++) begin
            vif.uart_rx <= item.data[i]; // 发送第 i 位
            repeat(5208) @(posedge vif.clk);
        end
 
        vif.uart_rx <= item.stop_bit; 
        repeat(5208) @(posedge vif.clk);
        
    endtask

endclass

`endif
