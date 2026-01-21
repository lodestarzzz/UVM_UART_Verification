//----------------------------------------------------------------------
//  File Name:    uart_item.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-20 11:45:26
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------

//`ifdef  UART_ITEM_SV
//`define UART_ITEM_SV

class uart_item extends uvm_sequence_item;
    rand bit [7:0] data;
    rand bit       start_bit;
    rand bit       stop_bit;
    rand int       delay;

    `uvm_object_utils_begin(uart_item)
        `uvm_field_int(data,         UVM_ALL_ON)
        `uvm_field_int(start_bit,    UVM_ALL_ON)
        `uvm_field_int(stop_bit,     UVM_ALL_ON)
        `uvm_field_int(delay,        UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end

    constraint c_default_frame{
        start_bit == 1'b0;
        stop_bit  == 1'b1;
    }

    constraint c_data_dist {
        data dist {
            8'h00 := 10,  
            8'hFF := 10,  
            [8'h01 : 8'hFE] :/ 80 
            };
    }

    constraint c_delay_range {
        delay inside {[0:20]}; 
    }

    function new(string name = "uart_item");
        super.new(name);
    endfunction

endclass

//`endif
