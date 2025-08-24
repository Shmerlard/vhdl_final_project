onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/top_proc/clk_i
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/rst_i
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/pc_o
add wave -noupdate /tb_mips_top/top_proc/instruction_top_o
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/hazard_unit/hazard_stall_ctl_o
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/ctrl_bus_s
add wave -noupdate /tb_mips_top/top_proc/addr_bus_s
add wave -noupdate /tb_mips_top/top_proc/data_bus_o
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(8)
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(9)
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(10)
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(11)
add wave -noupdate /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(12)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {573611 ps} 0}
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
WaveRestoreZoom {0 ps} {3150 ns}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
