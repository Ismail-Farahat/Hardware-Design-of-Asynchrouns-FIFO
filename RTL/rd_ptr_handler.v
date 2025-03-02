`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////
module rd_ptr_handler #(
    parameter DEPTH = 16,
    parameter PTR_W = $clog2(DEPTH)
    ) (
    input   wire                    i_rclk,
    input   wire                    i_rrst_n,
    input   wire                    i_rinc,
    input   wire    [PTR_W : 0]     i_g_wptr_sync,
    output  reg     [PTR_W : 0]     o_g_rptr,
    output  reg     [PTR_W : 0]     o_b_rptr,
    output  reg                     o_empty
    );


    wire            [PTR_W : 0]     b_rptr,
                                    g_rptr;
    wire                            empty;



    always @(posedge i_rclk, negedge i_rrst_n)
    begin
        if(~i_rrst_n) begin
            o_b_rptr <=  'b0;
            o_g_rptr <=  'b0;
            o_empty  <= 1'b0;
        end
        else begin
            o_b_rptr <= b_rptr;
            o_g_rptr <= g_rptr;
            o_empty  <= empty;
        end
    end



    assign b_rptr = o_b_rptr + (i_rinc & ~o_empty);

    assign g_rptr = b_rptr ^ (b_rptr>>1); // binary to gray

    assign empty = (i_g_wptr_sync == g_rptr);




endmodule
