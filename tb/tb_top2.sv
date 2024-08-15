`timescale 1ns / 1ps

module tb_top2;
 
    bit             clk;
    bit             i_srst;
    logic           i_data_val;
    logic [15 : 0]  i_data;
    logic [ 3 : 0]  i_data_mod;
    logic           o_ser_data, o_ser_data_val, o_busy;

    logic [15 : 0]  fixed_data;
    logic [ 4 : 0]  fixed_data_mod;
    logic [ 3 : 0]  cnt;
    logic           res_ser_data;
    logic           en;

    int res_cntr    = 0;
    int max_res     = 200;
    int err_cntr    = 0;
    enum logic [1 : 0] {OK, ERROR, IDLE} res_val = IDLE;
    
    assign en = i_data_val & ~o_busy & ( (i_data_mod == 0) | (i_data_mod > 2) );
    
    initial
      forever
        #5 clk = !clk;

    initial begin
       i_srst <= 1'b0;
       #15;
       @( posedge clk);
       i_srst <= 1'b1;
       @( posedge clk);
       i_srst <= 1'b0; 
    end

    // initial begin
    //     if (res_cntr == max_res) begin
    //         $display("\tSimulation is done (time %t): %d errors found", $time, err_cntr);
    //         $display("\t%d tests performed, %d errors found", max_res, err_cntr);
    //         $stop;
    //     end
            
    // end

    generate
        always_ff @( posedge clk ) begin
            i_data <= $urandom%(2**16);
            i_data_val <= $urandom%(2);
            i_data_mod <= $urandom%(2**4);  
            if (en) begin
                fixed_data      <= i_data;
                fixed_data_mod  <= {~|i_data_mod, i_data_mod};
                cnt <= '0;
                res_cntr <= res_cntr + 1;
            end
            else cnt <= cnt + 1'b1;
        end
        
        always_comb begin
            res_ser_data = fixed_data[15 - cnt];
//            res_ser_data = '0; // for display test
            if (o_ser_data_val) begin
                if (o_ser_data != res_ser_data) begin
                    res_val = ERROR;
                    err_cntr = err_cntr + 1;
                end else
                    res_val = OK;
            end else begin
                res_val = IDLE;
            end
        end
        
        always_comb begin
            if (res_val == ERROR) begin
                $display("\tError (time %t): expected %b in position %d (%b)", $time, res_ser_data, 15-cnt, fixed_data[15 : 0]);
            end
        end

        always_comb begin 
            if (res_cntr > max_res) begin
                $display("\tSimulation is done (time %t): %d errors found", $time, err_cntr);
                $display("\t%d tests performed, %d bit errors found", max_res, err_cntr);
                $stop;
            end
        end

    endgenerate

    top_serializer dut_top_serializer(
        .clk                (clk),
        .i_srst             (i_srst),
        .i_data             (i_data),
        .i_data_mod         (i_data_mod),
        .i_data_val         (i_data_val),
        .o_ser_data         (o_ser_data),
        .o_ser_data_val     (o_ser_data_val),
        .o_busy             (o_busy)
    );


endmodule
