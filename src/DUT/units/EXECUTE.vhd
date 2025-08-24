----------------------------------------------------------------------------------------------- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.aux_package.all;


ENTITY Execute IS
    generic(
        DATA_BUS_WIDTH : integer := 32
        -- FUNCT_WIDTH : integer := 6;
        -- PC_WIDTH : integer := 10
    );
    PORT(   
        read_data1_i    : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        read_data2_i    : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        sign_extend_i   : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        zero_extend_i   : in    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        shamt_i         : in    std_logic_vector(4 downto 0);
        shamt_ctl_i     : in    STD_LOGIC;
        ALUSrc_ctrl_i   : IN    STD_LOGIC_VECTOR(1 downto 0);
        bne_ctl_i       : in    std_logic;
        beq_ctl_i       : in    std_logic;
        alufn_i         : in    STD_LOGIC_VECTOR(4 downto 0);
        alu_res_o       : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 downto 0);
        slt_res_o       : out   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 downto 0);
        lui_res_o       : out   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 downto 0);
        zero_o          : out   std_logic;
        branch_ctl_o    : out   std_logic
    );
END Execute;


ARCHITECTURE behavior OF Execute IS
    SIGNAL a_input_w, b_input_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 downto 0);
    SIGNAL alu_out_mux_w            : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 downto 0);
    -- SIGNAL branch_addr_r            : STD_LOGIC_VECTOR(7 downto 0);
    -- SIGNAL alu_ctl_w                : STD_LOGIC_VECTOR(2 downto 0);
    signal zflag_w                  : std_logic;

    -- signal written_buffer           : std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
BEGIN

    a_input_w <=    read_data1_i when (shamt_ctl_i = '0') 
                    else (x"000000" & "000" & shamt_i);

-- ALU input mux
    with ALUSrc_ctrl_i select 
        b_input_w <= 
            read_data2_i    when "00",
            sign_extend_i   when "01",
            zero_extend_i   when "10",
            x"00000000"     when others;

    ALU: entity work.ALU
        generic map(n => DATA_BUS_WIDTH)
        port map(
            y       => a_input_w,
            x       => b_input_w,
            alufn   => alufn_i,
            aluout  => alu_out_mux_w,
            zflag   => zflag_w
        );

    zero_o <= zflag_w;
    alu_res_o <= alu_out_mux_w;
    branch_ctl_o <= (bne_ctl_i and not(zflag_w)) or (beq_ctl_i and zflag_w);
  
    slt_res_o <= x"0000000" & "000" & alu_out_mux_w(31);
    lui_res_o <= zero_extend_i(15 downto 0) & x"0000";

END behavior;

