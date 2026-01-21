//----------------------------------------------------------------------
//  File Name:    uart_env.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-21 10:23:47
//  Version:      No Git Repo
//  Description:  IC code
//  Modify Log:   [开始记录修改日志]
//----------------------------------------------------------------------
`ifndef UART_ENV_SV
`define UART_ENV_SV
class uart_env extends uvm_env;
    
    `uvm_component_utils(uart_env)

    uart_agent      agt;
    uart_scoreboard scb;
    uart_coverage   cov;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = uart_agent::type_id::create("agt", this);
        scb = uart_scoreboard::type_id::create("scb", this);
        cov = uart_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.mon_port.connect(scb.act_export);
        if(agt.get_is_active() == UVM_ACTIVE) begin
            agt.drv.drv_port.connect(scb.exp_export);
        end
        agt.mon.mon_port.connect(cov.analysis_export);
    endfunction

endclass

`endif
