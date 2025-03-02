`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module fifo_mem #(
    parameter DEPTH = 16,
    parameter PTR_W = $clog2(DEPTH),
    parameter WIDTH = 8
    ) (
    input   wire                        i_wclk,
    input   wire                        i_winc,
    input   wire                        i_full,
    input   wire    [PTR_W   : 0]       i_b_rptr,
    input   wire    [PTR_W   : 0]       i_b_wptr,
    input   wire    [WIDTH-1 : 0]       i_data_in,
    output  wire    [WIDTH-1 : 0]       o_data_out
    );


    reg             [WIDTH-1 : 0]       mem         [0 : DEPTH-1];


    // write
    always @(posedge i_wclk)
    begin            
        if(i_winc & ~i_full)
            mem[i_b_wptr[PTR_W-1 : 0]] <= i_data_in;
    end


/*
    // read
    always @(posedge i_rclk, negedge i_rrst_n)
    begin
        if (~i_rrst_n)
            o_data_out <= 'b0;
        else if(i_rinc & ~i_empty)
            o_data_out <= mem[i_b_rptr[PTR_W-1 : 0]];
    end
*/


assign o_data_out = mem[i_b_rptr[PTR_W-1 : 0]];




endmodule
