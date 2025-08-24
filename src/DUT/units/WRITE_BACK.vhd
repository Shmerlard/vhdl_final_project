LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE work.aux_package.ALL;

ENTITY WRITE_BACK IS
    PORT( 
        MemtoReg_ctl_i              : in  std_logic_vector(1 DOWNTO 0);
        RegDst_ctl_i                : in  std_logic_vector(1 DOWNTO 0);
        -- RegWrite_ctl_i              : in  std_logic;
        WDSel_ctl_i                 : in  std_logic;
        ALU_Result_i, dtcm_data_i   : in  std_logic_vector(31 DOWNTO 0);
        imm_i                       : in  std_logic_vector(15 DOWNTO 0);
        PC_plus_4_i                 : in  std_logic_vector(7 DOWNTO 0);
        rt_rd_i                     : in  std_logic_vector(9 DOWNTO 0);
        write_data_o                : out std_logic_vector(31 DOWNTO 0);
        write_reg_addr_o            : out std_logic_vector(4 DOWNTO 0)
        );
END WRITE_BACK;

ARCHITECTURE structure OF WRITE_BACK IS
    SIGNAL MemtoReg_data_w  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal slt_res_w        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal imm_w            : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal pc_plus4_w       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal rt_addr_w        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal rd_addr_w        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal pc_sig           : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    pc_sig      <= std_logic_vector(unsigned(PC_plus_4_i) - 1);
    slt_res_w   <= x"0000000" & "000" & ALU_Result_i(31);
    imm_w       <= imm_i & x"0000";
    pc_plus4_w  <= x"00000" & "00" & pc_sig & "00";
    rt_addr_w   <= rt_rd_i(9 downto 5);
    rd_addr_w   <= rt_rd_i(4 downto 0);

    with MemtoReg_ctl_i select
        MemtoReg_data_w <= 
            ALU_Result_i    when "00",
            dtcm_data_i     when "01",
            slt_res_w       when "10",
            imm_w           when others;

    with WDSel_ctl_i select
        write_data_o <= 
            MemtoReg_data_w when '0',
            pc_plus4_w      when others;

    with RegDst_ctl_i select 
        write_reg_addr_o <= 
            rt_addr_w   when "00",
            rd_addr_w   when "01",
            "11111"     when others;


END structure;
