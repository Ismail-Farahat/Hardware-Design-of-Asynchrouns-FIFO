`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////
module FIFO_TOP #(
    parameter DEPTH = 16,
    parameter WIDTH = 8 
    ) (
    input   wire                    i_wclk,
    input   wire                    i_rclk,
    input   wire                    i_wrst_n,
    input   wire                    i_rrst_n,
    input   wire                    i_winc,
    input   wire                    i_rinc,
    input   wire    [WIDTH-1 : 0]   i_data_in,
    output  wire    [WIDTH-1 : 0]   o_data_out,
    output  wire                    o_full,
    output  wire                    o_empty
    );


    localparam PTR_W = $clog2(DEPTH);


    wire            [PTR_W   : 0]   b_rptr;
    wire            [PTR_W   : 0]   g_rptr;
    wire            [PTR_W   : 0]   g_rptr_sync;

    wire            [PTR_W   : 0]   b_wptr;
    wire            [PTR_W   : 0]   g_wptr;
    wire            [PTR_W   : 0]   g_wptr_sync;




    fifo_mem #(
        .DEPTH(DEPTH),
        .PTR_W(PTR_W),
        .WIDTH(WIDTH)
                                ) MEM (
        .i_wclk(i_wclk),
        .i_winc(i_winc),
        .i_full(o_full),
        .i_b_rptr(b_rptr),
        .i_b_wptr(b_wptr),
        .i_data_in(i_data_in),
        .o_data_out(o_data_out)
    );


    sync #(
        .DATA_WIDTH(PTR_W+1) 
                                ) R2W_SYNC (
        .i_clk(i_wclk),
        .i_rst_n(i_wrst_n),
        .i_un_sync_data(g_rptr),
        .o_sync_data(g_rptr_sync)
    );


    sync #(
        .DATA_WIDTH(PTR_W+1) 
                                ) W2R_SYNC (
        .i_clk(i_rclk),
        .i_rst_n(i_rrst_n),
        .i_un_sync_data(g_wptr),
        .o_sync_data(g_wptr_sync)
    );


    wr_ptr_handler #(
        .DEPTH(DEPTH),
        .PTR_W(PTR_W)
                                ) WR_PTR (
        .i_wclk(i_wclk),
        .i_wrst_n(i_wrst_n),
        .i_winc(i_winc),
        .i_g_rptr_sync(g_rptr_sync),
        .o_g_wptr(g_wptr),
        .o_b_wptr(b_wptr),
        .o_full(o_full)
    );


    rd_ptr_handler #(
        .DEPTH(DEPTH),
        .PTR_W(PTR_W)
                                ) RD_PTR (
        .i_rclk(i_rclk),
        .i_rrst_n(i_rrst_n),
        .i_rinc(i_rinc),
        .i_g_wptr_sync(g_wptr_sync),
        .o_g_rptr(g_rptr),
        .o_b_rptr(b_rptr),
        .o_empty(o_empty)
    );






endmodule
