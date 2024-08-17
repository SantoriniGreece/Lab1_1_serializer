`timescale 1ns / 1ns

module tb_top3;
 
    bit             clk;
    bit             i_srst;
    logic           i_data_val;
    logic [15 : 0]  i_data;
    logic [ 3 : 0]  i_data_mod;
    logic           o_ser_data, o_ser_data_val, o_busy;

    parameter BITS  = 16;
    logic [15 : 0]  fixed_data;
    logic [ 3 : 0]  cnt;
    logic           res_ser_data;
    logic           en;

    int max_res     = 1000;
    int max_err     = 50;
    
    int res_cnt     = 0;
    int err_cnt     = 0;
    int bit_cntr    = 0;
    int errbit_cntr = 0;
    bit iserr       = 0;
    
    enum logic [1 : 0] {OK, ERROR, IDLE} res_val = IDLE;
    
    initial
      forever
        #5 clk = !clk;
        
    initial $timeformat(-9, 0, " ns", 8);
        
    default clocking cb @ (posedge clk);
    endclocking

    initial begin
       i_srst <= 1'b0;
       #15;
       @( posedge clk);
       i_srst <= 1'b1;
       @( posedge clk);
       i_srst <= 1'b0; 
    end
    
    task getRandomData (); 
        i_data      = $urandom%(2**BITS);
        i_data_val  = $urandom%(2);
        i_data_mod  = $urandom%(2**$clog2(BITS));
    endtask
    
    task testSerializer ();
        en = i_data_val & ~o_busy & ( (i_data_mod == 0) | (i_data_mod > 2) );
        if (en) begin
            fixed_data  = i_data;
            res_cnt     = res_cnt + 1;
            bit_cntr    = bit_cntr + {~|i_data_mod, i_data_mod};
            iserr       = 0;
            cnt         = '1;
        end else begin 
            cnt     = cnt + 1'b1;          
        end
        res_ser_data = fixed_data[15 - cnt];
    endtask
    
    task state ();
        if (o_ser_data_val) begin
            if (o_ser_data !== res_ser_data) begin
                res_val     = ERROR;
                errbit_cntr = errbit_cntr + 1;
                if (!iserr) begin 
                    err_cnt = err_cnt + 1;
                    iserr   = 1;
                end
            end else
                res_val = OK;
        end else begin
            res_val = IDLE;
        end
    endtask
    
    task errs_log ();
        if (res_val == ERROR) begin
            $display("\tError (time %t): expected %b in position %2d (%b)", $time, res_ser_data, 15-cnt, fixed_data[15 : 0]);
        end
    endtask

    initial begin
        forever begin
            ##1
            getRandomData();
            testSerializer();
            state();
            errs_log();
            if ( ( res_cnt >= max_res) || ( err_cnt >= max_err) )
                break;
        end
        $display("----------------------------------------------------------------");
        if (res_cnt >= max_res) 
            $display("\tSimulation is done (time %t): maximum number of words transmited (%0d)", $time, max_res);
        else
            $display("\tSimulation is done (time %t): maximum number of errors detected (%0d)", $time, max_err);
        $display("\t%0d words transmited,\t%0d errors found", res_cnt, err_cnt);
        $display("\t%0d bits transmited,\t%0d bit-errors found", bit_cntr, errbit_cntr);
        $display("----------------------------------------------------------------");
        $stop;
    end

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
