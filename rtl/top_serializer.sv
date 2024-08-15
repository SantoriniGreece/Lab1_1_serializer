`timescale 1ns / 1ps

module top_serializer (
    input  logic            clk,
    input  logic            i_srst,
    input  logic [15 : 0]   i_data,
    input  logic [ 3 : 0]   i_data_mod,
    input  logic            i_data_val,
    output logic            o_ser_data,
    output logic            o_ser_data_val,
    output logic            o_busy
);

    logic [15 : 0] tmp;
    logic [ 3 : 0] cnt;
    logic [ 3 : 0] threshold;
    logic          enable;
    logic          busy;
    logic          mod_val;
    logic          mod_zero;

    assign mod_val      = (i_data_mod == 0) | (i_data_mod > 2);
    assign enable       = i_data_val & ~busy & mod_val;
    
    always_ff @( posedge clk ) begin 
        if (enable)
            threshold <= i_data_mod;
    end

    always_ff @( posedge clk ) begin : shift_register
        if (i_srst)
            tmp <= '0;
        else if (enable)
            tmp <= i_data;
        else
            tmp <= tmp << 1;
    end
    
    always_ff @( posedge clk ) begin : counter
        if (i_srst) begin
            cnt  <= '0;
            busy <= 0;
        end
        else if (enable) begin
            cnt  <= 4'd1;
            busy <= 1;
        end
        else if (cnt == threshold) begin
            cnt  <= '0;
            busy <= 0;
        end 
        else
            cnt  <= cnt + 4'd1;
    end

    assign o_ser_data       = tmp[15] & busy;
    assign o_ser_data_val   = busy;
    assign o_busy           = busy;
    
endmodule
