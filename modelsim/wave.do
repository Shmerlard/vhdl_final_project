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
add wave -noupdate -expand -group interrupts /tb_mips_top/top_proc/mips_core_inst/interrupt_handler/int_ack_o
add wave -noupdate -expand -group interrupts /tb_mips_top/top_proc/mips_core_inst/interrupt_handler/icc_s
add wave -noupdate -expand -group interrupts /tb_mips_top/top_proc/mips_core_inst/int_req_i
add wave -noupdate -expand -group interrupts /tb_mips_top/top_proc/mips_core_inst/ID/gie_o
add wave -noupdate -expand -group interrupts /tb_mips_top/top_proc/interrupt_controller_unit_inst/interrupt_src_i
add wave -noupdate -expand -group buses /tb_mips_top/top_proc/ctrl_bus_s
add wave -noupdate -expand -group buses /tb_mips_top/top_proc/addr_bus_s
add wave -noupdate -expand -group buses /tb_mips_top/top_proc/data_bus_o
add wave -noupdate -divider <NULL>
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(1)
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(2)
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(3)
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(4)
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(5)
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(6)
add wave -noupdate -group r0-r7 /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(7)
add wave -noupdate -group t_reg -label T0_reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(8)
add wave -noupdate -group t_reg -label T1_reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(9)
add wave -noupdate -group t_reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(10)
add wave -noupdate -group t_reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(11)
add wave -noupdate -group t_reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(12)
add wave -noupdate -group t_reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(13)
add wave -noupdate -group t_reg -label T6-reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(14)
add wave -noupdate -group t_reg -label T7-reg /tb_mips_top/top_proc/mips_core_inst/ID/RF_q(15)
add wave -noupdate -label RF /tb_mips_top/top_proc/mips_core_inst/ID/RF_q
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_mips_top/top_proc/mclk_s
add wave -noupdate /tb_mips_top/top_proc/mclk64_s
add wave -noupdate -label FIR_FIFO_CONTENT -expand /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_sync_fifo_inst/reg_data_o_arr_s
add wave -noupdate -label FIRCTL_CONTENT /tb_mips_top/top_proc/fir_unit_inst/fir_ctl_inst/q_out
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/FIFOREN
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_sync_fifo_inst/FIFOWEN
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_sync_fifo_inst/valid_s
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_sync_fifo_inst/rd_ptr_s
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_sync_fifo_inst/wr_ptr_s
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/FIFOFULL
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_sync_fifo_inst/FIFOEMPTY
add wave -noupdate -label X_ARR_REG /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_reg_arr_inst/x_i_arr_s
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_ifg_o
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/FIROUT
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_core_inst/fir_reg_arr_inst/s_i_arr_s(7)
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_unit_addr_decoder_inst/cs_mem_read_o
add wave -noupdate -label FIROUT_reg /tb_mips_top/top_proc/fir_unit_inst/fir_out_ins/q_out
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_ifg_o
add wave -noupdate /tb_mips_top/top_proc/fir_unit_inst/fir_ena_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81101957 ps} 0} {{ADDI T6 T6 -1} {30175871 ps} 1}
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
WaveRestoreZoom {494747168 ps} {975519568 ps}
bookmark add wave bookmark0 {{746193 ps} {12451153 ps}} 11
