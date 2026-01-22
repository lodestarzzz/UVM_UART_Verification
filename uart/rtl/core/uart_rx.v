//----------------------------------------------------------------------
//  File Name:    uart_rx.v
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-19 11:52:42
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
// ---------------------------------------------------------
// File Name: uart_rx.v
// Description: UART Receiver (8N1)
// ---------------------------------------------------------
module uart_rx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx_clk_en, // 16x oversampling
    input  wire       uart_rx,
    output reg        rx_done,
    output reg  [7:0] rx_data
);
    localparam STATE_IDLE  = 3'd0;
    localparam STATE_START = 3'd1;
    localparam STATE_DATA  = 3'd2;
    localparam STATE_STOP  = 3'd3;

    reg [2:0] state;
    reg [3:0] sample_cnt; // 0-15
    reg [2:0] bit_idx;
    reg [7:0] scratch_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_IDLE;
            rx_done <= 1'b0;
            rx_data <= 0;
            sample_cnt <= 0;
            bit_idx <= 0;
        end else if (rx_clk_en) begin
            case (state)
                STATE_IDLE: begin
                    rx_done <= 1'b0;
                    if (uart_rx == 1'b0) begin // Detect start bit falling edge
                        state <= STATE_START;
                        sample_cnt <= 0;
                    end
                end
                STATE_START: begin
                    if (sample_cnt == 4'd7) begin // Middle of start bit
                        if (uart_rx == 1'b0) begin
                            sample_cnt <= 0;
                            state <= STATE_DATA;
                        end else begin
                            state <= STATE_IDLE; // False start
                        end
                    end else begin
                        sample_cnt <= sample_cnt + 1;
                    end
                end
                STATE_DATA: begin
                    if (sample_cnt == 4'd15) begin
                        sample_cnt <= 0;
                        scratch_data[bit_idx] <= uart_rx;
                        if (bit_idx == 3'd7) begin
                            bit_idx <= 0;
                            state <= STATE_STOP;
                        end else begin
                            bit_idx <= bit_idx + 1;
                        end
                    end else begin
                        sample_cnt <= sample_cnt + 1;
                    end
                end
                STATE_STOP: begin
                    if (sample_cnt == 4'd15) begin
                        state <= STATE_IDLE;
                        rx_data <= scratch_data;
                        rx_done <= 1'b1;
                    end else begin
                        sample_cnt <= sample_cnt + 1;
                    end
                end
                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule
