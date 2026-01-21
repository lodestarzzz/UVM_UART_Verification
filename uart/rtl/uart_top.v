//----------------------------------------------------------------------
//  File Name:    uart_top.v
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-19 11:52:55
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
// ---------------------------------------------------------
// File Name: uart_top.v
// Description: Top level wrapper connecting TX, RX and Baud Gen
// ---------------------------------------------------------
module uart_top #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst_n,
    
    // TX Interface
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx_active,
    output wire       uart_tx, 
    
    // RX Interface
    input  wire       uart_rx, 
    output wire       rx_done,
    output wire [7:0] rx_data
);

    wire rx_clk_en;
    wire tx_clk_en;

    // Instance of Baud Rate Generator
    baud_rate_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .rx_clk_en(rx_clk_en),
        .tx_clk_en(tx_clk_en)
    );

    // Instance of UART Transmitter
    uart_tx u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_clk_en(tx_clk_en),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_active(tx_active),
        .uart_tx(uart_tx)
    );

    // Instance of UART Receiver
    uart_rx u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx_clk_en(rx_clk_en),
        .uart_rx(uart_rx),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );

endmodule
