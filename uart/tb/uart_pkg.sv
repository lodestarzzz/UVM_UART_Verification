//----------------------------------------------------------------------
//  File Name:    uart_pkg.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-20 12:31:31
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
// ---------------------------------------------------------
// File: uvm_tb/uart_pkg.sv
// ---------------------------------------------------------
package uart_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "agents/uart_item.sv"
    `include "agents/uart_driver.sv"
    `include "agents/uart_monitor.sv"
    `include "agents/uart_sequence.sv"
    `include "agents/uart_agent.sv"
    
    `include "env/uart_scoreboard.sv"
    `include "env/uart_coverage.sv"
    `include "env/uart_env.sv"

    `include "uart_test.sv"

endpackage
