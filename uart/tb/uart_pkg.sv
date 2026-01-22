//----------------------------------------------------------------------
//  File Name:    uart_pkg.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-20 12:31:31
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
package uart_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // 1. Agents 
    `include "agents/uart_agent/uart_item.sv"
    `include "agents/uart_agent/uart_driver.sv"
    `include "agents/uart_agent/uart_monitor.sv"
    // Sequence 
    `include "sequences/uart_sequence.sv" 
    `include "agents/uart_agent/uart_agent.sv"

    // ---------------------------------------------------------
    // 2. Environment 
    // ---------------------------------------------------------
    `include "env/uart_scoreboard.sv"
    `include "env/uart_coverage.sv"
    `include "env/uart_env.sv"

    // ---------------------------------------------------------
    // 3. Tests 
    // ---------------------------------------------------------
    `include "tests/uart_test.sv"

endpackage
