//----------------------------------------------------------------------
//  File Name:    uart_if.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-20 10:58:47
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
interface uart_if(input logic clk, input logic rst_n);
    logic       tx_start;
    logic [7:0] tx_data;

    logic       tx_active;
    logic       uart_tx;


    logic       uart_rx;
    logic       rx_done;
    logic [7:0] rx_data;

    
    //driver clocking block
    clocking cb_drv @(posedge clk);
        default input #1ns output #1ns;
        output tx_start;
        output tx_data;
        input  tx_active;
        output uart_rx;
    endclocking

    //monitor clocking block
    clocking cb_mon @(posedge clk);
        default input #1ns output #1ns;
        input tx_start;
        input tx_data;
        input tx_active;
        input uart_tx;

        input uart_rx;
        input rx_done;
        input rx_data;
    endclocking


    //Modports
    modport drv (clocking cb_drv, input clk, input rst_n);
    modport mon (clocking cb_mon, input clk, input rst_n);

endinterface
