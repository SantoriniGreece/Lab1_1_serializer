vlib work

vlog -sv top_serializer.sv
vlog -sv tb_top.sv

vsim -novopt sim_top_tb

add log -r /*
add wave -r *
run -all