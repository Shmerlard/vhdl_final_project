
---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;


ENTITY tb_mips_top IS
    generic( 
        WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
        -- MODELSIM : integer          := G_MODELSIM;
        MODELSIM : integer          := 1;
        DATA_BUS_WIDTH : integer    := 32;
        ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
        DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
        PC_WIDTH : integer          := 10;
        FUNCT_WIDTH : integer       := 6;
        DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
        CLK_CNT_WIDTH : integer     := 16;
        INST_CNT_WIDTH : integer    := 16
    );
END tb_mips_top ;


ARCHITECTURE struct OF tb_mips_top IS
   -- Internal signal declarations
   SIGNAL rst_tb_i              : STD_LOGIC;
   SIGNAL clk_tb_i              : STD_LOGIC;

   signal keys_s               : std_logic_vector(2 downto 0);
   signal switches_s           : std_logic_vector(7 downto 0);
   signal leds_s               : std_logic_vector(7 downto 0);
   
BEGIN
    top_proc : entity work.mips_top
    generic map(
        WORD_GRANULARITY            => WORD_GRANULARITY,
        MODELSIM                    => MODELSIM,
        DATA_BUS_WIDTH              => DATA_BUS_WIDTH,
        ITCM_ADDR_WIDTH             => ITCM_ADDR_WIDTH,
        DTCM_ADDR_WIDTH             => DTCM_ADDR_WIDTH,
        PC_WIDTH                    => PC_WIDTH,
        FUNCT_WIDTH                 => FUNCT_WIDTH,
        DATA_WORDS_NUM              => DATA_WORDS_NUM,
        CLK_CNT_WIDTH               => CLK_CNT_WIDTH,
        INST_CNT_WIDTH              => INST_CNT_WIDTH,
        -- DTCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/GPIO/test0/bin/M9K/DTCM.hex",
        -- ITCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/GPIO/test0/bin/M9K/ITCM.hex"
        ITCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/GPIO/test0/bin/M9K/ITCM.hex",
        DTCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/GPIO/test0/bin/M9K/DTCM.hex"

    )
    PORT MAP (
        rst_i               => rst_tb_i,
        clk_i               => clk_tb_i,
        bpaddr_i            => "00000000",
        keys_i              => keys_s,
        switches_i          => switches_s,
        leds_o              => leds_s
    );
--------------------------------------------------------------------    
    gen_clk : 
    process
        begin
          clk_tb_i <= '1';
          wait for 50 ns;
          clk_tb_i <= not clk_tb_i;
          wait for 50 ns;
    end process;
    
    gen_rst : 
    process
        begin
          rst_tb_i <='1';
          wait for 200 ns;
          rst_tb_i <= '0';
          wait;
    end process;

    int_proc: process
    begin
        keys_s <= "000";
        wait;
    end process;

    switches_proc : process
    begin
        switches_s <= (others => '0');
        keys_s <= (others => '0');
        wait;
    end process;
--------------------------------------------------------------------        
END struct;
