onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fir_reg_array_1/coeff_i
add wave -noupdate /tb_fir_reg_array_1/tb_clk_i
add wave -noupdate /tb_fir_reg_array_1/tb_rst_i
add wave -noupdate /tb_fir_reg_array_1/x_input
add wave -noupdate /tb_fir_reg_array_1/out_y
add wave -noupdate -expand /tb_fir_reg_array_1/fir_reg_arr_inst/x_i_arr_s
add wave -noupdate -radix unsigned -expand /tb_fir_reg_array_1/fir_reg_arr_inst/s_i_arr_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {70682 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 50000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {3414097 ps}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
