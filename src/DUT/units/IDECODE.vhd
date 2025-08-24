LIBRARY IEEE;       
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


ENTITY Idecode IS
    generic(
        DATA_BUS_WIDTH : integer := 32;
        NEXT_PC_WIDTH  : integer := 8
    );
    PORT(   clk_i,rst_i     : IN    STD_LOGIC;
            instruction_i   : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            RegWrite_ctrl_i : IN    STD_LOGIC;
            write_reg_addr_i: in    STD_LOGIC_VECTOR(4 DOWNTO 0);
            write_reg_data_i: in    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            pc_plus4_i      : in    STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
            pc_latch_i      : in    STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
            c1_cmp_i        : in    std_logic;
            c3_cmp_i        : in    std_logic;
            gie_mask_i      : in    std_logic;
            INTR_i          : in    std_logic;
            gie_o           : out    std_logic;
            read_data1_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            sign_extend_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            zero_extend_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            jta_o           : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
            bta_o           : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0)
    );
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

    SIGNAL RF_q                 : register_file;
    SIGNAL rs_register_w        : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL rt_register_w        : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL rd_register_w        : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL imm_value_w          : STD_LOGIC_VECTOR( 15 DOWNTO 0 );
    signal slt_res_w            : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal sign_extend_w        : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal write_reg_addr_s     : std_logic_vector(4 DOWNTO 0);
    signal write_reg_data_s     : std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal id_pc_latch_s        : std_logic_vector(NEXT_PC_WIDTH-1 DOWNTO 0);
    signal RF_wren_s            : std_logic;
    signal gie_mask_s           : std_logic;

BEGIN
    rs_register_w           <= instruction_i(25 DOWNTO 21);
    rt_register_w           <= instruction_i(20 DOWNTO 16);
    rd_register_w           <= instruction_i(15 DOWNTO 11);
    imm_value_w             <= instruction_i(15 DOWNTO 0);

    -- Read Register 1 Operation
    read_data1_o <= RF_q(to_integer(unsigned(rs_register_w)));

    -- Read Register 2 Operation         
    read_data2_o <= RF_q(to_integer(unsigned(rt_register_w)));

    -- Sign Extend 16-bits to 32-bits
    sign_extend_w <=    (X"0000" & imm_value_w) WHEN (imm_value_w(15) = '0') ELSE
                        (X"FFFF" & imm_value_w);
    sign_extend_o <= sign_extend_w;

    -- Branch target address
    bta_o <= std_logic_vector(unsigned(pc_plus4_i) + unsigned(imm_value_w(NEXT_PC_WIDTH-1 downto 0)) -1 );

    -- Jump target address
    jta_o <= instruction_i(7 downto 0);

    -- Zero Extend 16-bits to 32-bits
    zero_extend_o <= x"0000" & imm_value_w;

    process(clk_i,rst_i)
    begin
        if (rst_i='1') then
            FOR i IN 0 TO 31 LOOP
                -- RF_q(i) <= CONV_STD_LOGIC_VECTOR(i,32);
                RF_q(i) <= x"00000000";
            END LOOP;
        elsif (clk_i'event and clk_i='0') then
            if (RF_wren_s = '1' AND unsigned(write_reg_addr_s) /= 0) then
                RF_q(to_integer(unsigned(write_reg_addr_s))) <= write_reg_data_s;
                -- index is integer type so we must use conv_integer for type casting
            end if;
        end if;
    end process;

-- Insert ID_PC to $K1 when ICC = 3
    RF_wren_s           <= RegWrite_ctrl_i or c3_cmp_i;
    write_reg_addr_s    <= write_reg_addr_i when (c3_cmp_i = '0') else "11011";
    write_reg_data_s    <= write_reg_data_i when (c3_cmp_i = '0') else (x"00000" & "00" & pc_latch_i & "00");

-- GIE logic
    gie_o <= RF_q(26)(0) and gie_mask_i;

END behavior;

