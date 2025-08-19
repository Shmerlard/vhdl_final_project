LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;


ENTITY Ifetch IS
    generic(
        WORD_GRANULARITY : boolean  := True;
        DATA_BUS_WIDTH : integer    := 32;
        PC_WIDTH : integer          := 10;
        NEXT_PC_WIDTH : integer     := 8; -- NEXT_PC_WIDTH = PC_WIDTH-2
        ITCM_ADDR_WIDTH : integer   := 8;
        WORDS_NUM : integer         := 256;
        INST_CNT_WIDTH : integer    := 16
    );
    PORT(   
        clk_i, rst_i    : in    std_logic;
        bta_i, jta_i    : in    std_logic_vector(7 downto 0);
        branch_ctl_i    : in    std_logic;
        j_ctl_i         : in    std_logic;
        jr_ctl_i        : in    std_logic;
        read_data1_i    : in    std_logic_vector(data_bus_width-1 downto 2);
        c3_cmp_i        : in    std_logic;
        isr_i           : in    std_logic_vector(next_pc_width-1 downto 0);
        pc_o            : out   std_logic_vector(pc_width-1 downto 0);
        pc_plus4_o      : out   std_logic_vector(next_pc_width-1 downto 0);
        instruction_o   : out   std_logic_vector(data_bus_width-1 downto 0);
        inst_cnt_o      : out   std_logic_vector(inst_cnt_width-1 downto 0) 
    );
END Ifetch;


ARCHITECTURE behavior OF Ifetch IS
    signal  pc_din_s, pc_plus4_s    : std_logic_vector(next_pc_width-1 downto 0);
    signal itcm_addr_w          : std_logic_vector(itcm_addr_width-1 downto 0);
    signal inst_cnt_q           : std_logic_vector(inst_cnt_width-1 downto 0);
    signal pc_prev_q            : std_logic_vector(pc_width-1 downto 0); 
    signal instruction_w        : std_logic_vector(data_bus_width-1 downto 0);
    signal pc_s                 : std_logic_vector(next_pc_width-1 downto 0);
BEGIN

--ROM for Instruction Memory
    inst_memory: altsyncram
    GENERIC MAP (
        operation_mode => "ROM",
        width_a => DATA_BUS_WIDTH,
        widthad_a => ITCM_ADDR_WIDTH,
        numwords_a => WORDS_NUM,
        lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = ITCM",
        lpm_type => "altsyncram",
        outdata_reg_a => "UNREGISTERED",
        -- init_file => "C:\Users\nitza\Desktop\School\University\Year_D\Semester_B\CPU lab\lab5\vhdl_lab5\src\SW\test3\bin\ITCM.hex",
        init_file => "/home/elad/Desktop/vhdl_lab5/src/SW/test2/bin/ITCM.hex",
        -- init_file => "/home/elad/Desktop/vhdl_lab5/src/SW/test1/bin/ITCM.hex",
        intended_device_family => "Cyclone"
    )
    PORT MAP (
        clock0     => clk_i,
        address_a  => itcm_addr_w, 
        q_a        => instruction_w 
    );

    -- send address to inst. memory address register
    G1: 
    if (WORD_GRANULARITY = True) generate       -- i.e. each WORD has unike address
        itcm_addr_w <= pc_din_s;
    elsif (WORD_GRANULARITY = False) generate   -- i.e. each BYTE has unike address
        itcm_addr_w <= pc_din_s & "00";
    end generate;


-- PC Register
    PC_Reg : entity work.nbit_dff
    generic map(n => NEXT_PC_WIDTH)
    port map(
        clk     => clk_i,
        rst     => rst_i,
        en      => '1',
        d_in    => pc_din_s,
        q_out   => pc_s
    );
        
-- PC data input logic
    process(rst_i, bta_i, jta_i, branch_ctl_i, read_data1_i, j_ctl_i, jr_ctl_i, pc_plus4_s)
    begin
        if (rst_i = '1') then 
            pc_din_s <= (others => '0');
        elsif (c3_cmp_i = '1') then 
            pc_din_s <= isr_i;
        elsif (branch_ctl_i = '1') then
            pc_din_s <= bta_i;
        elsif (j_ctl_i = '1') then
            pc_din_s <= jta_i;
        elsif (jr_ctl_i = '1') then
            pc_din_s <= read_data1_i;
        else pc_din_s <= pc_plus4_s;
        end if;
    end process;

    pc_plus4_s <= pc_s + 1;

---------------------------------------------------------------------------------------
--                      IPC - instruction counter register
---------------------------------------------------------------------------------------
    process (clk_i , rst_i)
    begin
        if rst_i = '1' then
            pc_prev_q   <=  (others => '0');
        elsif falling_edge(clk_i) then
            pc_prev_q   <=  pc_s;
        end if;
    end process;
---------------------------------------------------------------------------------------
    process (clk_i , rst_i)
    begin
        if rst_i = '1' then
            inst_cnt_q  <=  (others => '0');
        elsif rising_edge(clk_i) then
            if pc_prev_q = pc_s then
                inst_cnt_q  <=  inst_cnt_q + '1';
            end if;
        end if;
    end process;
---------------------------------------------------------------------------------------
    -- copy output signals - allows read inside module
    pc_o                <=  pc_s;
    pc_plus4_o          <=  pc_plus4_s;
    inst_cnt_o          <=  inst_cnt_q;
    instruction_o       <=  instruction_w;
END behavior;


