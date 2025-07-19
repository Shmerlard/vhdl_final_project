onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /timer_unit_tb/mclk_i
add wave -noupdate /timer_unit_tb/mclk_i2
add wave -noupdate /timer_unit_tb/mclk_i4
add wave -noupdate /timer_unit_tb/mclk_i8
add wave -noupdate /timer_unit_tb/BTCLR
add wave -noupdate -radix hexadecimal /timer_unit_tb/BTCCR0
add wave -noupdate -radix hexadecimal /timer_unit_tb/BTCCR1
add wave -noupdate /timer_unit_tb/BTHOLD
add wave -noupdate /timer_unit_tb/BTIFG
add wave -noupdate /timer_unit_tb/BTIP
add wave -noupdate /timer_unit_tb/BTOUTEN
add wave -noupdate /timer_unit_tb/BTOUTMD
add wave -noupdate /timer_unit_tb/BTSSEL
add wave -noupdate /timer_unit_tb/clk_period
add wave -noupdate /timer_unit_tb/n
add wave -noupdate /timer_unit_tb/PWMOUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5438 ps} 0}
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
WaveRestoreZoom {0 ps} {34650 ps}
