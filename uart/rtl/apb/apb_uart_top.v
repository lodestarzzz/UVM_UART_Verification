//----------------------------------------------------------------------
//  File Name:    apb_uart_top.v
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-22 10:04:29
//  Version:      9dd099bacaea4c9e761d74254662c788cff20659
//  Description:  IC code
//  Modify Log:   [begin]
//----------------------------------------------------------------------
// 文件路径: rtl/apb/apb_uart_top.v
module apb_uart_top #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    // 1. 系统信号
    input  wire        pclk,    // APB 时钟 (通常也是系统时钟)
    input  wire        presetn, // APB 复位 (低电平有效)

    // 2. APB 总线接口 (Slave Interface)
    input  wire [31:0] paddr,   // 地址
    input  wire        psel,    // 片选 (Master 说：我要找你)
    input  wire        penable, // 使能 (Master 说：数据稳了，读/写吧)
    input  wire        pwrite,  // 写使能 (1=写, 0=读)
    input  wire [31:0] pwdata,  // 写数据
    output reg  [31:0] prdata,  // 读数据
    output wire        pready,  // 就绪信号 (简单的 APB 外设通常常驻为 1)

    // 3. 外部串口接口 (External Interface)
    output wire        uart_tx,
    input  wire        uart_rx
);

    // -----------------------------------------------------------
    // 内部信号声明
    // -----------------------------------------------------------
    reg        tx_start_reg; // 用来产生一个脉冲
    reg  [7:0] tx_data_reg;
    wire       tx_active;
    wire       rx_done;
    wire [7:0] rx_data;

    // APB 是简单的协议，这里 pready 始终拉高，表示我们总是立刻响应
    assign pready = 1'b1; 

    // -----------------------------------------------------------
    // 实例化原本的 UART Core
    // -----------------------------------------------------------
    uart_top #(
        .CLK_FREQ (CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_core (
        .clk      (pclk),       // 共享时钟
        .rst_n    (presetn),    // 共享复位
        
        // TX
        .tx_start (tx_start_reg), // 由 APB 逻辑控制
        .tx_data  (tx_data_reg),  // 由 APB 写入的数据提供
        .tx_active(tx_active),    // 给状态寄存器看
        .uart_tx  (uart_tx),      // 输出到外部
        
        // RX
        .uart_rx  (uart_rx),      // 外部输入
        .rx_done  (rx_done),      // 给状态寄存器看
        .rx_data  (rx_data)       // 给读寄存器看
    );

    // -----------------------------------------------------------
    // APB 写逻辑 (CPU -> UART)
    // -----------------------------------------------------------
    // 只有当 PSEL=1, PENABLE=1, PWRITE=1 时，才是有效的写操作
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            tx_start_reg <= 1'b0;
            tx_data_reg  <= 8'h00;
        end else begin
            // 自动复位 start 信号，确保它只是一个脉冲
            if (tx_start_reg) 
                tx_start_reg <= 1'b0;

            // APB Write Phase
            if (psel && penable && pwrite) begin
                case (paddr[7:0]) // 只看低 8 位地址即可
                    8'h00: begin // 写 TX_DATA 寄存器
                        tx_data_reg  <= pwdata[7:0]; // 拿 CPU 给的数据
                        tx_start_reg <= 1'b1;        // 🔥 拉高 Start，触发 core 发送！
                    end
                    // 以后可以在这里扩展 8'h04 来配置波特率
                    default: ;
                endcase
            end
        end
    end

    // -----------------------------------------------------------
    // APB 读逻辑 (UART -> CPU)
    // -----------------------------------------------------------
    // 当 PSEL=1, PENABLE=1, PWRITE=0 时，CPU 想读数据
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            prdata <= 32'h0;
        end else begin
            if (psel && !pwrite) begin // 只要选中且是读
                case (paddr[7:0])
                    8'h00: begin // 读 RX_DATA
                        prdata <= {24'h0, rx_data}; 
                    end
                    8'h04: begin // 读 STATUS
                        // Bit 0: TX is busy?
                        // Bit 1: RX has new data?
                        prdata <= {30'h0, rx_done, tx_active};
                    end
                    default: prdata <= 32'h0;
                endcase
            end
        end
    end

endmodule
