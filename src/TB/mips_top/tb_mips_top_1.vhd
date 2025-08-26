LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;


ENTITY tb1_mips_top IS
    generic( 
        WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
        MODELSIM : integer          := 0;
        DATA_BUS_WIDTH : integer    := 32;
        ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
        DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
        PC_WIDTH : integer          := 10;
        FUNCT_WIDTH : integer       := 6;
        DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
        CLK_CNT_WIDTH : integer     := 16;
        INST_CNT_WIDTH : integer    := 16
    );
    port(
        clk_i      : std_logic;
        keys_i     : std_logic_vector(3 downto 0);
        switches_i : std_logic_vector(7 downto 0);
        leds_o     : std_logic_vector(7 downto 0)
    );
END tb1_mips_top ;


ARCHITECTURE struct OF tb1_mips_top IS
    signal keys_s               : std_logic_vector(2 downto 0);
   
BEGIN
    CORE : entity work.mips_top
    generic map(
        WORD_GRANULARITY            => WORD_GRANULARITY,
        MODELSIM                    => MODELSIM,
        DATA_BUS_WIDTH              => DATA_BUS_WIDTH,
        ITCM_ADDR_WIDTH             => ITCM_ADDR_WIDTH,
        DTCM_ADDR_WIDTH             => DTCM_ADDR_WIDTH,
        PC_WIDTH                    => PC_WIDTH,
        DATA_WORDS_NUM              => DATA_WORDS_NUM,
        CLK_CNT_WIDTH               => CLK_CNT_WIDTH,
        INST_CNT_WIDTH              => INST_CNT_WIDTH,
        DTCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/interrupt1/DTCM.hex",
        ITCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/interrupt1/ITCM.hex"

    )
    PORT MAP (
        rst_i               => not keys_i(0),
        clk_i               => clk_i,
        bpaddr_i            => "00000000",
        keys_i              => not keys_s,

        switches_i          => switches_i,
        leds_o              => leds_o


        -- pc_o                => pc_tb_o,
        -- alu_result_o        => alu_result_tb_o,
        -- read_data1_o        => read_data1_tb_o,
        -- read_data2_o        => read_data2_tb_o,
        -- write_data_o        => write_data_tb_o,
        -- instruction_top_o   => instruction_top_tb_o,
        -- Branch_ctrl_o       => Branch_ctrl_tb_o,
        -- Zero_o              => Zero_tb_o,
        -- MemWrite_ctrl_o     => MemWrite_ctrl_tb_o,
        -- RegWrite_ctrl_o     => RegWrite_ctrl_tb_o,
        -- mclk_cnt_o          => mclk_cnt_tb_o,
        -- inst_cnt_o          => inst_cnt_tb_o
    );

    keys_s <= not keys_i(3 downto 1);
--------------------------------------------------------------------    
END struct;
