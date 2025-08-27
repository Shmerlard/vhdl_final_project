onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/top_proc/clk_i
add wave -noupdate -group clock /tb_mips_top/top_proc/mclk_s
add wave -noupdate -group clock /tb_mips_top/top_proc/mclk2_s
add wave -noupdate -group clock /tb_mips_top/top_proc/mclk4_s
add wave -noupdate -group clock /tb_mips_top/top_proc/mclk8_s
add wave -noupdate -group clock /tb_mips_top/top_proc/mclk64_s
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/rst_i
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/pc_o
add wave -noupdate /tb_mips_top/top_proc/instruction_top_o
add wave -noupdate -divider <NULL>
add wave -noupdate -group IO /tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins/led_o
add wave -noupdate -group IO /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins/lsb_hex_out_s
add wave -noupdate -group IO /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins/msb_hex_out_s
add wave -noupdate -group IO /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins2/lsb_hex_out_s
add wave -noupdate -group IO /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins2/msb_hex_out_s
add wave -noupdate -group IO /tb_mips_top/top_proc/switches_i
add wave -noupdate -group interrupts /tb_mips_top/top_proc/mips_core_inst/interrupt_handler/int_ack_o
add wave -noupdate -group interrupts /tb_mips_top/top_proc/mips_core_inst/interrupt_handler/icc_s
add wave -noupdate -group interrupts /tb_mips_top/top_proc/mips_core_inst/int_req_i
add wave -noupdate -group interrupts /tb_mips_top/top_proc/mips_core_inst/ID/gie_o
add wave -noupdate -expand -group buses /tb_mips_top/top_proc/ctrl_bus_s
add wave -noupdate -expand -group buses /tb_mips_top/top_proc/addr_bus_s
add wave -noupdate -expand -group buses /tb_mips_top/top_proc/data_bus_o
add wave -noupdate -divider <NULL>
add wave -noupdate -label RF /tb_mips_top/top_proc/mips_core_inst/ID/RF_q
add wave -noupdate -divider <NULL>
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16949034 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 151
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {14502179 ps} {20673338 ps}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
