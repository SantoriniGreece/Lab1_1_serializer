`timescale 1ns/1ps

module tb_dec_counter( );
 
    bit clk = 1'b0;
    logic i_srst, i_threshold_val, o_busy;
    logic [ 3 : 0] i_threshold, o_data_counter;
    
    localparam clk_period = 6;
    always #(clk_period/2) clk = ~clk; 

    default clocking cb @ (posedge clk);
    endclocking

    initial
        begin
            i_srst <= 1'b0;
            ##1;
            i_srst <= 1'b1;
            ##1;
            i_srst <= 1'b0;
        end

    initial
        begin
            i_threshold_val <= 1'b0;
            ##3;
            i_threshold_val <= 1'b1;
            ##1;
            i_threshold_val <= 1'b0;
            ##10
            i_threshold_val <= 1'b1;
            ##1;
            i_threshold_val <= 1'b0;
        end

    initial
        begin
            i_threshold <= 4'd0;
            ##3;
            i_threshold <= 4'd0;
            ##1;
            i_threshold <= 4'd0;
            ##10
            i_threshold <= 4'd14;
            ##1;
            i_threshold <= 4'd0;
        end

    // assign i_threshold = 4'd5;

    dec_counter dut_dec_counter(
        .clk                (clk),
        .i_srst             (i_srst),
        .i_threshold_val    (i_threshold_val),
        .i_threshold        (i_threshold),
        .o_busy             (o_busy),
        .o_data_counter     (o_data_counter)
    );


endmodule
