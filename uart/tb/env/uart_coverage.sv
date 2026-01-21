//----------------------------------------------------------------------
//  File Name:    uart_coverage.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 11:41:55
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_COVERAGE_SV
`define UART_COVERAGE_SV

class uart_coverage extends uvm_subscriber #(uart_item);
    
    `uvm_component_utils(uart_coverage)

    uart_item item; 
    covergroup cg_uart;
        c_data: coverpoint item.data {
            bins min_val   = {8'h00};
            bins max_val   = {8'hFF};
            bins others[4] = {[1:254]};
        }
        
        c_delay: coverpoint item.delay {
            bins no_delay = {0};
            bins small_delay = {[1:10]};
            bins large_delay = {[11:20]};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_uart = new();
    endfunction

    function void write(uart_item t);
        this.item = t; 
        cg_uart.sample(); 
    endfunction

endclass

`endif
