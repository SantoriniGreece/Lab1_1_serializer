`timescale 1ns / 1ps

module top_serializer_wrapper (
    input  logic            clk,
    input  logic            i_srst,
    input  logic [15 : 0]   i_data,
    input  logic [ 3 : 0]   i_data_mod,
    input  logic            i_data_val,
    output logic            o_ser_data,
    output logic            o_ser_data_val,
    output logic            o_busy
);

    logic            wr_i_srst;
    logic [15 : 0]   wr_i_data;
    logic [ 3 : 0]   wr_i_data_mod;
    logic            wr_i_data_val;
    logic            wr_o_ser_data;
    logic            wr_o_ser_data_val;
    logic            wr_o_busy;

    always_ff @( posedge clk ) begin : i_ff
        wr_i_srst       <= i_srst;
        wr_i_data       <= i_data;
        wr_i_data_mod   <= i_data_mod;
        wr_i_data_val   <= i_data_val;
    end

    top_serializer dut_top_serializer(
        .clk                (clk),
        .i_srst             (wr_i_srst),
        .i_data             (wr_i_data),
        .i_data_mod         (wr_i_data_mod),
        .i_data_val         (wr_i_data_val),
        .o_ser_data         (wr_o_ser_data),
        .o_ser_data_val     (wr_o_ser_data_val),
        .o_busy             (wr_o_busy)
    );

    always_ff @( posedge clk ) begin : o_ff
        o_ser_data      <= wr_o_ser_data;
        o_ser_data_val  <= wr_o_ser_data_val;
        o_busy          <= wr_o_busy;
    end
    
endmodule
