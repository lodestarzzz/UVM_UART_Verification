//----------------------------------------------------------------------
//  File Name:    tb_top.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-20 11:13:37
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`timescale 1ns/1ps

module tb_top;
    import uvm_pkg::*;          
    `include "uvm_macros.svh"
    import uart_pkg::*;

    logic clk;
    logic rst_n;

    //50MHz clock gen
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // T=20ns
    end

    //rst gen
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
    end


    uart_if intf(clk, rst_n);

    uart_top #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    )
    u_dut(
        .clk            (clk            ),
        .rst_n          (rst_n          ),
        
        .tx_start       (intf.tx_start  ),
        .tx_data        (intf.tx_data   ),
        .tx_active      (intf.tx_active ),
        .uart_tx        (intf.uart_tx   ),

        .uart_rx        (intf.uart_rx   ),
        .rx_done        (intf.rx_done   ),
        .rx_data        (intf.rx_data   )
    );
    initial begin
        uvm_config_db#(virtual uart_if)::set(null, "*", "uart_if", intf);
        run_test("uart_test"); 
    end

    initial begin
        $fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars(0, tb_top);
    end

/*
    initial begin
        #100ms;
        $finish;
    end
*/

endmodule
