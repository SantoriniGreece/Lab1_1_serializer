vlib work

vlog -sv ../rtl/top_serializer.sv
vlog -sv tb_top2.sv

vsim -novopt tb_top2

add log -r /*

add wave -divider "INPUT SIGNALS"
add wave                    tb_top2/clk
add wave                    tb_top2/i_srst
add wave                    tb_top2/i_data_val
add wave -radix unsigned    tb_top2/i_data_mod
add wave -radix binary      tb_top2/i_data

add wave -divider "OUTPUT SIGNALS"
add wave                    tb_top2/o_ser_data
add wave                    tb_top2/o_ser_data_val
add wave                    tb_top2/o_busy

add wave -divider "INTERNAL SIGNALS"
add wave -radix unsigned    tb_top2/fixed_data_mod
add wave -radix binary      tb_top2/fixed_data
add wave -radix unsigned    tb_top2/cnt
add wave                    tb_top2/en

add wave -divider "CHECK"
add wave                    tb_top2/res_ser_data
add wave                    tb_top2/res_val

run -all