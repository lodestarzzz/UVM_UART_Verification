//----------------------------------------------------------------------
//  File Name:    uart_sequence.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 11:15:21
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_SEQUENCE_SV
`define UART_SEQUENCE_SV

class uart_sequence extends uvm_sequence #(uart_item);
    
    `uvm_object_utils(uart_sequence) 

    function new(string name = "uart_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("SEQ", "Sequence starting...", UVM_LOW)
        
        repeat(500) begin
            req = uart_item::type_id::create("req"); 
            
            start_item(req); 
            
            if(!req.randomize()) begin 
                `uvm_error("SEQ", "Randomization failed!")
            end
            
            finish_item(req); 
        end
        
        `uvm_info("SEQ", "Sequence finished!", UVM_LOW)
    endtask

endclass

`endif
