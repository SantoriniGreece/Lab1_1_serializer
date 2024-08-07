# Полная пересборка библиотеки с рекомпиляцией
proc	rr {} {
    # Выход из режима моделирования (в режиме моделирования нельзя сменить текущую папку)
    quit    -sim
    cd     ../    
    source modelsim_tb_top.tcl	}
# Выход из Modelsim
proc    q  {} {quit -force							}

# Создаем папку, в которой будет скомпилированная библиотека
file    mkdir sim_tb_top
cd      sim_tb_top

# Компиляция своих исходников
vlog   -sv         ../../rtl/top_serializer.sv
vlog   -sv         ../tb_top.sv

# vopt -64 +acc -work work work.tb_top -o tb_top_opt
# vsim -t 1ps tb_top_opt

# add wave -divider "INPUT SIGNALS"
# add wave                    tb_top/clk
# add wave                    tb_top/i_srst
# add wave -radix binary      tb_top/i_data
# add wave -radix unsigned    tb_top/i_data_mod
# add wave                    tb_top/i_data_val

# add wave -divider "OUTPUT SIGNALS"
# add wave                    tb_top/o_ser_data
# add wave                    tb_top/o_ser_data_val
# add wave                    tb_top/o_busy

# add wave -divider "INTERNAL SIGNALS"
# add wave -radix unsigned    tb_top/dut_top_serializer/*

noview memory list
noview objects
noview processes

run -all
wave zoom full