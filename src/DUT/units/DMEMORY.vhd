---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
--  Dmemory module (implements the data memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
    generic(
        DATA_BUS_WIDTH : integer := 32;
        DTCM_ADDR_WIDTH : integer := 10;
        WORDS_NUM : integer := 256;
        DTCM_PATH : string
    );
    PORT(   
        clk_i               : in    std_logic;
        -- rst_i               : in    std_logic;
        dtcm_addr_i         : in    std_logic_vector(DTCM_ADDR_WIDTH-1 DOWNTO 0);
        dtcm_data_wr_i      : in    std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
        MemRead_ctrl_i      : in    std_logic;
        MemWrite_ctrl_i     : in    std_logic;
        dtcm_data_rd_o      : out   std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0)
    );
END dmemory;


architecture behavior of dmemory is
    signal wrclk_w : std_logic;
begin
    data_memory : altsyncram
    GENERIC MAP  (
        operation_mode => "SINGLE_PORT",
        width_a => DATA_BUS_WIDTH,
        widthad_a => DTCM_ADDR_WIDTH,
        numwords_a => WORDS_NUM,
        lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
        lpm_type => "altsyncram",
        outdata_reg_a => "UNREGISTERED",
        init_file => DTCM_PATH,
        intended_device_family => "Cyclone"
    )
    PORT MAP (
        wren_a => MemWrite_ctrl_i,
        clock0 => wrclk_w,
        address_a => dtcm_addr_i,
        data_a => dtcm_data_wr_i,
        q_a => dtcm_data_rd_o   
    );

    wrclk_w <= NOT clk_i;   -- Load memory address register with write clock
END behavior;

