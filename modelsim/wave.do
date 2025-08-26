onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/top_proc/clk_i
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/rst_i
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/pc_o
add wave -noupdate -radix decimal /tb_mips_top/top_proc/pc_o
add wave -noupdate /tb_mips_top/top_proc/instruction_top_o
add wave -noupdate -divider <NULL>
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/Group1 -group {Region: sim:/tb_mips_top/top_proc} /tb_mips_top/top_proc/ctrl_bus_s
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/Group1 -group {Region: sim:/tb_mips_top/top_proc} /tb_mips_top/top_proc/addr_bus_s
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/Group1 -group {Region: sim:/tb_mips_top/top_proc} /tb_mips_top/top_proc/data_bus_o
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/hazard_unit/lw_hazard_rd1_o
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/hazard_unit/lw_hazard_rd2_o
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(8)
add wave -noupdate -label sim:/tb_mips_top/top_proc/mips_core_inst/ID/Group1 -group {Region: sim:/tb_mips_top/top_proc/mips_core_inst/ID} /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(9)
add wave -noupdate -label sim:/tb_mips_top/top_proc/mips_core_inst/ID/Group1 -group {Region: sim:/tb_mips_top/top_proc/mips_core_inst/ID} /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(10)
add wave -noupdate -label sim:/tb_mips_top/top_proc/mips_core_inst/ID/Group1 -group {Region: sim:/tb_mips_top/top_proc/mips_core_inst/ID} /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(11)
add wave -noupdate -label sim:/tb_mips_top/top_proc/mips_core_inst/ID/Group1 -group {Region: sim:/tb_mips_top/top_proc/mips_core_inst/ID} /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(12)
add wave -noupdate -label sim:/tb_mips_top/top_proc/mips_core_inst/ID/Group1 -group {Region: sim:/tb_mips_top/top_proc/mips_core_inst/ID} /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(13)
add wave -noupdate -label sim:/tb_mips_top/top_proc/mips_core_inst/ID/Group1 -group {Region: sim:/tb_mips_top/top_proc/mips_core_inst/ID} /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(14)
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/switches_i
add wave -noupdate -divider <NULL>
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins/Group1 -group {Region: sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins} /tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins/led_o
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins/Group1 -group {Region: sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins} /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins/lsb_hex_out_s
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins/Group1 -group {Region: sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins} /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins/msb_hex_out_s
add wave -noupdate -expand -label sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins/Group1 -group {Region: sim:/tb_mips_top/top_proc/gpio_unit_inst/led_inter_ins} /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins2/lsb_hex_out_s
add wave -noupdate /tb_mips_top/top_proc/gpio_unit_inst/hex_inter_ins2/msb_hex_out_s
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/int_req_i
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/interrupt_handler/int_ack_o
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/interrupt_handler/icc_s
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/gie_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {658711 ps} 0}
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
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4606671 ps}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
