//----------------------------------------------------------------------
//  File Name:    uart_scoreboard.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 10:48:29
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_SCOREBOARD_SV
`define UART_SCOREBOARD_SV

`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_mon)

class uart_scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(uart_scoreboard)

    uvm_analysis_imp_drv #(uart_item, uart_scoreboard) exp_export; 
    uvm_analysis_imp_mon #(uart_item, uart_scoreboard) act_export;

    uart_item expect_queue[$];

    int match_count = 0;
    int error_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        exp_export = new("exp_export", this);
        act_export = new("act_export", this);
    endfunction

    function void write_drv(uart_item item);
        expect_queue.push_back(item); 
    endfunction

    bit header_printed = 0;

    function void write_mon(uart_item item);
        uart_item exp_item;
        string result_str;
        string row_str; 
        
        if(expect_queue.size() == 0) begin
            `uvm_error("SCB", $sformatf("Unexpected item: 0x%02h (Queue Empty)", item.data))
            error_count++;
            check_error_limit();
            return;
        end

        exp_item = expect_queue.pop_front();

        if (!header_printed) begin
            $display(""); 
            $display("+------------+------------+----------+----------------+");
            $display("|   ACTUAL   |  EXPECTED  |  STATUS  |      TIME      |");
            $display("+------------+------------+----------+----------------+");
            header_printed = 1;
        end

        if(item.data == exp_item.data) begin
            match_count++;
            result_str = "  PASS  "; 
        end else begin
            error_count++;
            result_str = "**FAIL**"; 
        end

        row_str = $sformatf("|    0x%02h    |    0x%02h    | %s |  %12t  |", 
                            item.data, exp_item.data, result_str, $time);

        if (result_str == "**FAIL**") begin
            `uvm_error("SCB", row_str)
            check_error_limit();
        end else begin
            $display(row_str); 
        end

    endfunction

    function void report_phase(uvm_phase phase);
        $display("");
        $display("+-------------------------+");
        $display("|    FINAL REPORT CARD    |");
        $display("+-------------------------+");
        $display("|  Matches : %5d        |", match_count);
        $display("|  Errors  : %5d        |", error_count);
        $display("+-------------------------+");
        
        if(error_count == 0)
            $display("|      RESULT: PASS       |"); 
        else
            $display("|      RESULT: FAIL       |");
            
        $display("+-------------------------+");
        $display("");
    endfunction

    function void check_phase(uvm_phase phase);
        if(expect_queue.size() > 0) begin
            `uvm_error("SCB", $sformatf("Simulation ended but %0d items still in queue! (Monitor lost data?)", expect_queue.size()))
        end
        `uvm_info("SCB", $sformatf("Final Report: Matches=%0d, Errors=%0d", match_count, error_count), UVM_LOW)
    endfunction

    function void check_error_limit();
        if (error_count >= 4) begin
            $display("+------------------------------------------------------+");
            $display("|            🛑  CRITICAL FAILURE  🛑                  |");
            $display("+------------------------------------------------------+");
            
            `uvm_fatal("SCB", $sformatf("Error count reached %0d! Simulation Aborted.", error_count))
        end
    endfunction
endclass

`endif
