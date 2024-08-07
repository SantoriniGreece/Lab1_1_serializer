`timescale 1ns / 1ps

module tb_top;
 
    bit             clk = 1'b0;
    bit             i_srst;
    logic           i_data_val;
    logic [15 : 0]  i_data;
    logic [ 3 : 0]  i_data_mod;
    logic           o_ser_data, o_ser_data_val, o_busy;
    
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
    //    #100;
    //    @( posedge clk);
    //    i_srst <= 1'b1;
    //    @( posedge clk);
    //    i_srst <= 1'b0; 
    end
    
    initial begin
        i_data_val <= 1'b0;
        // Тест 1
        #40;
        @( posedge clk);
        i_data_val <= 1'b1;
        @( posedge clk);
        i_data_val <= 1'b0; 

        // Тест 2
        #80;
        @( posedge clk);
        i_data_val <= 1'b1;
        @( posedge clk);
        i_data_val <= 1'b0; 

        // Тест 3
        #20;
        @( posedge clk);
        i_data_val <= 1'b1;
        @( posedge clk);
        i_data_val <= 1'b0; 

        // Тест 4
        #170;
        @( posedge clk);
        i_data_val <= 1'b1;
        @( posedge clk);
        i_data_val <= 1'b0;

        // Тест 5
        #80;
        @( posedge clk);
        i_data_val <= 1'b1;
        @( posedge clk);
        i_data_val <= 1'b0;
    end
    
    initial begin
        i_data <= '0;
        i_data_mod <= '0;

        // Тест 1
        #40;
        @( posedge clk);
        i_data <= 16'b0010_1001_1100_1010;
        i_data_mod <= 4'b0110;
        @( posedge clk);
        i_data <= '0;
        i_data_mod <= '0;

        // Тест 2
        #80;
        @( posedge clk);
        i_data <= '1;
        i_data_mod <= 4'b0001;
        @( posedge clk);
        i_data <= '0;
        i_data_mod <= '0;

        // Тест 3
        #20;
        @( posedge clk);
        i_data <= '1;
        i_data_mod <= 4'b0000;
        @( posedge clk);
        i_data <= '0;
        i_data_mod <= '0;
        
        // Тест 4
        #170;
        @( posedge clk);
        i_data <= 16'b1101_0110_1010_1111;
        i_data_mod <= 4'b1110;
        @( posedge clk);
        i_data <= '0;
        i_data_mod <= '0;

        // Тест 5
        #80;
        @( posedge clk);
        i_data <= '1;
        i_data_mod <= '1;
        @( posedge clk);
        i_data <= '0;
        i_data_mod <= '0;
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
