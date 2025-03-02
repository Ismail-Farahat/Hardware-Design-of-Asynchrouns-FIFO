`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////
module sync #(
    DATA_WIDTH = 8
    ) (
    input   wire                            i_clk,
    input   wire                            i_rst_n,
    input   wire    [DATA_WIDTH-1 : 0]      i_un_sync_data,
    output  wire    [DATA_WIDTH-1 : 0]      o_sync_data
    );

    reg             [DATA_WIDTH-1 : 0]      sync1, 
                                            sync2;


    always @(posedge i_clk, negedge i_rst_n)
    begin
        if(~i_rst_n) begin
            sync1 <= 'b0;
            sync2 <= 'b0;
        end
        else begin
            sync1 <= i_un_sync_data;
            sync2 <= sync1;
        end
    end


    assign o_sync_data = sync2;



endmodule
