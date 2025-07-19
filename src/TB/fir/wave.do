onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fir_sync_fifo_tb/UUT/FIFOCLK
add wave -noupdate /fir_sync_fifo_tb/UUT/FIFORST
add wave -noupdate -divider wren-rden
add wave -noupdate -radixenum symbolic /fir_sync_fifo_tb/UUT/FIFOWEN
add wave -noupdate /fir_sync_fifo_tb/UUT/FIFOREN
add wave -noupdate -divider d_in-d_out
add wave -noupdate -radix hexadecimal /fir_sync_fifo_tb/UUT/FIFOIN
add wave -noupdate -radix hexadecimal -childformat {{/fir_sync_fifo_tb/UUT/DATAOUT(23) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(22) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(21) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(20) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(19) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(18) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(17) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(16) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(15) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(14) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(13) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(12) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(11) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(10) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(9) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(8) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(7) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(6) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(5) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(4) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(3) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(2) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(1) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/DATAOUT(0) -radix hexadecimal}} -subitemconfig {/fir_sync_fifo_tb/UUT/DATAOUT(23) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(22) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(21) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(20) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(19) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(18) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(17) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(16) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(15) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(14) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(13) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(12) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(11) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(10) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(9) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(8) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(7) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(6) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(5) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(4) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(3) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(2) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(1) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/DATAOUT(0) {-height 16 -radix hexadecimal}} /fir_sync_fifo_tb/UUT/DATAOUT
add wave -noupdate -divider empty-full
add wave -noupdate /fir_sync_fifo_tb/UUT/FIFOFULL
add wave -noupdate /fir_sync_fifo_tb/UUT/FIFOEMPTY
add wave -noupdate -divider ptr
add wave -noupdate /fir_sync_fifo_tb/UUT/reg_wr_en_s
add wave -noupdate /fir_sync_fifo_tb/UUT/wr_ptr_s
add wave -noupdate /fir_sync_fifo_tb/UUT/rd_ptr_s
add wave -noupdate -divider reg_array
add wave -noupdate -radix hexadecimal -childformat {{/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(0) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(1) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(2) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(3) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(4) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(5) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(6) -radix hexadecimal} {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(7) -radix hexadecimal}} -expand -subitemconfig {/fir_sync_fifo_tb/UUT/reg_data_o_arr_s(0) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(1) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(2) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(3) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(4) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(5) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(6) {-height 16 -radix hexadecimal} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s(7) {-height 16 -radix hexadecimal}} /fir_sync_fifo_tb/UUT/reg_data_o_arr_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35415 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 128
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 5000
configure wave -gridperiod 10000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {30225 ps} {124725 ps}
