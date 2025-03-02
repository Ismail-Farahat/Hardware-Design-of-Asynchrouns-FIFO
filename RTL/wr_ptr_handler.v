`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////
module wr_ptr_handler #(
    parameter DEPTH = 16,
    parameter PTR_W = $clog2(DEPTH)
    ) (
    input   wire                    i_wclk,
    input   wire                    i_wrst_n,
    input   wire                    i_winc,    
    input   wire    [PTR_W : 0]     i_g_rptr_sync,
    output  reg     [PTR_W : 0]     o_g_wptr,
    output  reg     [PTR_W : 0]     o_b_wptr,
    output  reg                     o_full
    );

    
    wire            [PTR_W : 0]     b_wptr,
                                    g_wptr;
    wire                            full;


    always @(posedge i_wclk, negedge i_wrst_n)
    begin
        if(~i_wrst_n) begin
            o_b_wptr <=  'b0;
            o_g_wptr <=  'b0;
            o_full   <= 1'b0;
        end
        else begin
            o_b_wptr <= b_wptr;
            o_g_wptr <= g_wptr;
            o_full   <= full;
        end
    end



    assign b_wptr = o_b_wptr + (i_winc & ~o_full);

    assign g_wptr = b_wptr ^ (b_wptr>>1); // binary to gray

    // full flag 
    // full flag raised: @b_rd_ptr = {PTR_W{1'b0}}, @b_wr_ptr = { 1'b1, {PTR_W-1{1'b0}} }
    // full flag raised: @g_rd_ptr = {PTR_W{1'b0}}, @g_wr_ptr = { 2'b11, {PTR_W-2{1'b0}} }
    assign full = (i_g_rptr_sync == {~g_wptr[PTR_W:PTR_W-1], g_wptr[PTR_W-2:0]});
        



endmodule
