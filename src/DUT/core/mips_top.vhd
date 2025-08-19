LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

ENTITY mips_top IS
    generic( 
            WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
            MODELSIM : integer          := G_MODELSIM;
            DATA_BUS_WIDTH : integer    := 32;
            ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            PC_WIDTH : integer          := 10;
            NEXT_PC_WIDTH : integer     := 8;
            FUNCT_WIDTH : integer       := 6;
            DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
            CLK_CNT_WIDTH : integer     := 16;
            INST_CNT_WIDTH : integer    := 16
    );
    PORT(   rst_i               :IN STD_LOGIC;
            clk_i               :IN STD_LOGIC; 
            bpaddr_i            :IN STD_LOGIC_VECTOR(7 downto 0);
            -- Output important signals to pins for easy display in SignalTap
            pc_o                :OUT    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
            alu_result_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data1_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            write_data_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            instruction_top_o   :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            Branch_ctrl_o       :OUT    STD_LOGIC;
            Zero_o              :OUT    STD_LOGIC;
            MemWrite_ctrl_o     :OUT    STD_LOGIC;
            RegWrite_ctrl_o     :OUT    STD_LOGIC;
            mclk_cnt_o          :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
            inst_cnt_o          :OUT    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
            hex_o               :OUT    t_hex_array(0 to 7);
            flush_cnt           :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            hf_cnt              :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            strigger_o          :OUT    std_logic
    );
END mips_top;
