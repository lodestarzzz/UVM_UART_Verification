//----------------------------------------------------------------------
//  File Name:    apb_if.sv
//  Author:       zyc <824701198@qq.com>
//  Create Date:  2026-01-22 10:39:29
//  Version:      9dd099bacaea4c9e761d74254662c788cff20659
//  Description:  IC code
//  Modify Log:   [begin]
//----------------------------------------------------------------------
interface apb_if(input clk, input rst_n);

    // -------------------------------------------------------
    // 1. Signal Definition
    // -------------------------------------------------------
    logic [31:0] paddr;
    logic        psel;
    logic        penable;
    logic        pwrite;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        pready; // always 1 in my prj

    // -------------------------------------------------------
    // 2. Clocking Block for Driver
    // -------------------------------------------------------
    clocking drv_cb @(posedge clk);
        default input #1ns output #1ns;
        
        output paddr, psel, penable, pwrite, pwdata;
        input  prdata, pready; 
    endclocking

    // -------------------------------------------------------
    // 3. Clocking Block for Monitor
    // -------------------------------------------------------
    clocking mon_cb @(posedge clk);
        default input #1ns output #1ns;

        input paddr, psel, penable, pwrite, pwdata;
        input prdata, pready;
    endclocking

    // -------------------------------------------------------
    // 4. Modport
    // -------------------------------------------------------
    modport DRV (clocking drv_cb);
    modport MON (clocking mon_cb);

endinterface
