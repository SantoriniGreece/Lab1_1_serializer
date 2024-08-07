`timescale 1ns/1ps

module dec_counter (
    input  logic            clk,
    input  logic            i_srst,
    input  logic            i_threshold_val,
    input  logic [ 3 : 0]   i_threshold,
    output logic            o_busy,
    output logic [ 3 : 0]   o_data_counter
);

    logic           busy = 0;
    logic [ 3 : 0]  counter;
    logic [ 3 : 0]  threshold;

    // always_comb begin
    //     if (~busy & i_threshold_val) begin
    //         threshold = i_threshold;
    //         busy      = 1;
    //     end
    // end

    // always_ff @( posedge clk ) begin
    //     if (i_srst | (counter == threshold)) begin
    //         counter <= '0;
    //         busy    <= 0;
    //     end
    //     else begin
    //         counter <= counter + 1;
    //     end
    // end
   
    always_ff @( posedge clk ) begin : decrement_counter
        if (i_srst) begin
            counter <= 4'd0;
        end
        else 
            if (~busy & i_threshold_val) begin
                counter <= i_threshold;
                busy    <= 1;
            end 
            else begin
                counter <= counter - 1'd1;
            end
    end

    always_ff @( posedge clk ) begin : isbusy_proc
        if (i_srst | (counter == 4'd1) )
            busy <= 0;
    end

     assign o_data_counter = counter & {4{busy}};
     assign o_busy         = busy;
    
endmodule