`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////
module FIFO_TOP_tb(); 


//================================================================//
//======================    PARAMETERS    ========================//
//================================================================//
    localparam DEPTH                = 16;
    localparam WIDTH                = 8;


    localparam i_wclk_period        = 8;
    localparam i_rclk_period        = 2;


    localparam PTR_W                = $clog2(DEPTH);


//================================================================//
//======================    PORTS DECLARTION    ==================//
//================================================================//
    logic                    i_wclk;
    logic                    i_rclk;
    logic                    i_wrst_n;
    logic                    i_rrst_n;
    logic                    i_winc;
    logic                    i_rinc;
    logic    [WIDTH-1 : 0]   i_data_in;
    logic    [WIDTH-1 : 0]   o_data_out;
    logic                    o_full;
    logic                    o_empty;



    wire     [PTR_W   : 0]   b_rptr;
    wire     [PTR_W   : 0]   g_rptr;
    wire     [PTR_W   : 0]   g_rptr_sync;
    
    wire     [PTR_W   : 0]   b_wptr;
    wire     [PTR_W   : 0]   g_wptr;
    wire     [PTR_W   : 0]   g_wptr_sync;


    assign b_rptr = DUT.b_rptr;
    assign b_wptr = DUT.b_wptr;
    assign g_rptr = DUT.g_rptr;
    assign g_rptr_sync = DUT.g_rptr_sync;
    assign g_wptr = DUT.g_wptr;
    assign g_wptr_sync = DUT.g_wptr_sync;




//================================================================//
//======================    DUT  =================================//
//================================================================//
FIFO_TOP #( 
    .DEPTH(DEPTH), 
    .WIDTH(WIDTH) 
                                    ) DUT ( 
    .i_wclk(i_wclk), 
    .i_rclk(i_rclk), 
    .i_wrst_n(i_wrst_n), 
    .i_rrst_n(i_rrst_n), 
    .i_winc(i_winc), 
    .i_rinc(i_rinc), 
    .i_data_in(i_data_in), 
    .o_data_out(o_data_out), 
    .o_full(o_full), 
    .o_empty(o_empty) 
    ); 


    //================================================================//
    //======================    DEBUG & OPTIMIZATION    ==============//
    //================================================================//
    integer     log_file;
    initial begin
        log_file = $fopen("./test.log", "w");
        $fdisplay(log_file, "TESTING ...");
    end
    



    //================================================================//
    //======================    TASKS    =============================//
    //================================================================//
    task write();
        i_winc = 1;
        i_rinc = 0;
        if (~o_full) begin
            std::randomize(i_data_in) with {i_data_in[0] == 1'b1;};   // give a sign for the data that must be written in FIFO
            $fdisplay(log_file, "Time: %d, wr_en= 1, rd_en= 0, wr_data = %d", $time, i_data_in);
            $display("Time: %d, wr_en= 1, rd_en= 0, wr_data = %d", $time, i_data_in);
        end
        else begin
            std::randomize(i_data_in) with {i_data_in[0] == 1'b0;};   // give a sign for the data that must not be written in FIFO
            $fdisplay(log_file, "Time: %d, FIFO is full.", $time);
            $display("Time: %d, FIFO is full.", $time);
        end
    endtask


    task read();
        i_winc = 0;
        i_rinc = 1;
        if (~o_empty) begin
            $fdisplay(log_file, "Time: %d, wr_en= 0, rd_en= 1, rd_data = %d", $time, o_data_out);
            $display("Time: %d, wr_en= 0, rd_en= 1, rd_data = %d", $time, o_data_out);
        end
        else begin
            $fdisplay(log_file, "Time: %d, FIFO is empty.", $time);
            $display("Time: %d, FIFO is empty.", $time);
        end
    endtask

//================================================================//
//======================    CLOCKS    ============================//
//================================================================//
always #(i_wclk_period*0.5) i_wclk = ~i_wclk;

always #(i_rclk_period*0.5) i_rclk = ~i_rclk;

initial #(i_wclk_period*100) $finish;



//================================================================//
//======================    TESTS    =============================//
//================================================================//
initial begin
    // initial values
    i_wclk          = 0;
    i_rclk          = 0;
    i_wrst_n        = 0;
    i_rrst_n        = 0;
    i_winc          = 0;
    i_rinc          = 0;
    i_data_in       = 0;

    #(1.5*i_wclk_period) i_wrst_n = 1;
    #(1.5*i_rclk_period) i_rrst_n = 1;

    // tests
    repeat(20) @(posedge i_wclk) #i_wclk_period write();
    repeat(20) @(posedge i_rclk) #i_rclk_period read();
end


//================================================================//
//================================================================//
//================================================================//


endmodule


