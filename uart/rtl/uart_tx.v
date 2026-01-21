//----------------------------------------------------------------------
//  File Name:    uart_tx.v
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-19 11:52:26
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [begin]
//----------------------------------------------------------------------
module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_clk_en,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx_active,
    output reg        uart_tx
);
    localparam STATE_IDLE  = 3'd0;
    localparam STATE_START = 3'd1;
    localparam STATE_DATA  = 3'd2;
    localparam STATE_STOP  = 3'd3;

    reg [2:0] state;
    reg [2:0] bit_idx;
    reg [7:0] data_temp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_IDLE;
            uart_tx <= 1'b1; // Idle high
            tx_active <= 1'b0;
            bit_idx <= 0;
            data_temp <= 0;
        end else if (tx_clk_en) begin
            case (state)
                STATE_IDLE: begin
                    uart_tx <= 1'b1;
                    if (tx_start) begin
                        state <= STATE_START;
                        data_temp <= tx_data;
                        tx_active <= 1'b1;
                    end else begin
                         tx_active <= 1'b0;
                    end
                end
                STATE_START: begin
                    uart_tx <= 1'b0; // Start bit low
                    state <= STATE_DATA;
                end
                STATE_DATA: begin
                    uart_tx <= data_temp[bit_idx];
                    if (bit_idx == 3'd7) begin
                        bit_idx <= 0;
                        state <= STATE_STOP;
                    end else begin
                        bit_idx <= bit_idx + 1;
                    end
                end
                STATE_STOP: begin
                    uart_tx <= 1'b1; // Stop bit high
                    state <= STATE_IDLE;
                    tx_active <= 1'b0;
                end
                default: state <= STATE_IDLE;
            endcase
        end else if (state == STATE_IDLE && tx_start) begin
             // Capture data immediately
             data_temp <= tx_data; 
             tx_active <= 1'b1;
        end
    end
endmodule
