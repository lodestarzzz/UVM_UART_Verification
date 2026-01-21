//----------------------------------------------------------------------
//  File Name:    baud_rate_gen.v
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-19 11:52:06
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [begin]
//----------------------------------------------------------------------
module baud_rate_gen #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst_n,
    output reg  rx_clk_en, // 16x oversampling for RX
    output reg  tx_clk_en  // 1x for TX
);
    // Calculate dividers
    localparam RX_ACC_MAX = CLK_FREQ / (BAUD_RATE * 16);
    localparam TX_ACC_MAX = CLK_FREQ / BAUD_RATE;

    reg [15:0] rx_acc;
    reg [15:0] tx_acc;

    // RX Clock Enable Generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_acc <= 0;
            rx_clk_en <= 0;
        end else begin
            if (rx_acc == RX_ACC_MAX[15:0] - 1) begin
                rx_acc <= 0;
                rx_clk_en <= 1'b1;
            end else begin
                rx_acc <= rx_acc + 1;
                rx_clk_en <= 1'b0;
            end
        end
    end

    // TX Clock Enable Generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_acc <= 0;
            tx_clk_en <= 0;
        end else begin
            if (tx_acc == TX_ACC_MAX[15:0] - 1) begin
                tx_acc <= 0;
                tx_clk_en <= 1'b1;
            end else begin
                tx_acc <= tx_acc + 1;
                tx_clk_en <= 1'b0;
            end
        end
    end
endmodule
