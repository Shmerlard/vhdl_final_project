onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_interrupt_controller_core_1/clk
add wave -noupdate /tb_interrupt_controller_core_1/rst
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_interrupt_controller_core_1/eint_i
add wave -noupdate /tb_interrupt_controller_core_1/gie_i
add wave -noupdate /tb_interrupt_controller_core_1/ifg_o
add wave -noupdate /tb_interrupt_controller_core_1/int_req_o
add wave -noupdate /tb_interrupt_controller_core_1/inta_i_b
add wave -noupdate /tb_interrupt_controller_core_1/interrupt_src_i
add wave -noupdate -radix hexadecimal -childformat {{/tb_interrupt_controller_core_1/type_reg_d_in_o(6) -radix hexadecimal} {/tb_interrupt_controller_core_1/type_reg_d_in_o(5) -radix hexadecimal} {/tb_interrupt_controller_core_1/type_reg_d_in_o(4) -radix hexadecimal} {/tb_interrupt_controller_core_1/type_reg_d_in_o(3) -radix hexadecimal} {/tb_interrupt_controller_core_1/type_reg_d_in_o(2) -radix hexadecimal} {/tb_interrupt_controller_core_1/type_reg_d_in_o(1) -radix hexadecimal} {/tb_interrupt_controller_core_1/type_reg_d_in_o(0) -radix hexadecimal}} -expand -subitemconfig {/tb_interrupt_controller_core_1/type_reg_d_in_o(6) {-height 16 -radix hexadecimal} /tb_interrupt_controller_core_1/type_reg_d_in_o(5) {-height 16 -radix hexadecimal} /tb_interrupt_controller_core_1/type_reg_d_in_o(4) {-height 16 -radix hexadecimal} /tb_interrupt_controller_core_1/type_reg_d_in_o(3) {-height 16 -radix hexadecimal} /tb_interrupt_controller_core_1/type_reg_d_in_o(2) {-height 16 -radix hexadecimal} /tb_interrupt_controller_core_1/type_reg_d_in_o(1) {-height 16 -radix hexadecimal} /tb_interrupt_controller_core_1/type_reg_d_in_o(0) {-height 16 -radix hexadecimal}} /tb_interrupt_controller_core_1/type_reg_d_in_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3513 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 1000
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {11782 ps}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
