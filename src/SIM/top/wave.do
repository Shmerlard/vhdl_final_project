onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips_top/CORE/rst_i
add wave -noupdate /tb_mips_top/CORE/clk_i
add wave -noupdate -divider <NULL>
add wave -noupdate -label fetch_ins -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/IFE/instruction_o
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/addr_bus_o
add wave -noupdate -radix hexadecimal -childformat {{/tb_mips_top/CORE/mips_core_inst/ID/RF_q(0) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(1) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(2) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(3) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(4) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(5) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(6) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(7) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(8) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(9) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(10) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(11) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(12) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(13) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(14) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(15) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(16) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(17) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(18) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(19) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(20) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(21) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(22) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(23) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(24) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(25) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(26) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(27) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(28) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(29) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(30) -radix hexadecimal} {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(31) -radix hexadecimal}} -subitemconfig {/tb_mips_top/CORE/mips_core_inst/ID/RF_q(0) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(1) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(2) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(3) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(4) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(5) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(6) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(7) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(8) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(9) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(10) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(11) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(12) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(13) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(14) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(15) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(16) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(17) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(18) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(19) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(20) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(21) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(22) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(23) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(24) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(25) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(26) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(27) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(28) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(29) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(30) {-height 16 -radix hexadecimal} /tb_mips_top/CORE/mips_core_inst/ID/RF_q(31) {-height 16 -radix hexadecimal}} /tb_mips_top/CORE/mips_core_inst/ID/RF_q
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/data_bus_s
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/data_bus_o
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/mem_rd2_wi
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/ex_rd2_final_w
add wave -noupdate -radix hexadecimal /tb_mips_top/CORE/mips_core_inst/ex_rd2_wi
add wave -noupdate /tb_mips_top/keys_s
add wave -noupdate /tb_mips_top/CORE/int_ack_s
add wave -noupdate /tb_mips_top/CORE/int_req_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1339037 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 152
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
WaveRestoreZoom {939755 ps} {2055803 ps}
bookmark add wave bookmark2 {{746193 ps} {12451153 ps}} 11
