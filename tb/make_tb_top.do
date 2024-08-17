vlib work

vlog -sv ../rtl/top_serializer.sv
vlog -sv tb_top3.sv

vsim -novopt tb_top3

add log -r /*

add wave -divider "INPUT SIGNALS"
add wave                    tb_top3/clk
add wave                    tb_top3/i_srst
add wave                    tb_top3/i_data_val
add wave -radix unsigned    tb_top3/i_data_mod
add wave -radix binary      tb_top3/i_data

add wave -divider "OUTPUT SIGNALS"
add wave                    tb_top3/o_ser_data
add wave                    tb_top3/o_ser_data_val
add wave                    tb_top3/o_busy

add wave -divider "INTERNAL SIGNALS"
add wave -radix binary      tb_top3/fixed_data
add wave                    tb_top3/en

add wave -divider "CHECK"
add wave                    tb_top3/res_ser_data
add wave                    tb_top3/res_val
add wave -radix unsigned    tb_top3/res_cnt
add wave -radix unsigned    tb_top3/err_cnt

run -all