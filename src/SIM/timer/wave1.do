onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/CORE/clk_i
add wave -noupdate /tb_mips_top/rst_tb_i
add wave -noupdate -divider BUS
add wave -noupdate /tb_mips_top/CORE/data_bus_s
add wave -noupdate /tb_mips_top/CORE/addr_bus_s
add wave -noupdate -radix binary -radixshowbase 1 /tb_mips_top/CORE/ctrl_bus_s
add wave -noupdate -divider IO
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/ID/RF_q(8)
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/ID/RF_q(9)
add wave -noupdate -divider IO
add wave -noupdate /tb_mips_top/CORE/leds_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {475496 ps} 0}
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
WaveRestoreZoom {0 ps} {2100 ns}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
