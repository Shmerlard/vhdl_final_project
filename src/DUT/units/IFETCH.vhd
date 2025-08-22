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
        INST_CNT_WIDTH : integer    := 16;
        ITCM_PATH : string
    );
    PORT(   
        clk_i, rst_i    : in    std_logic;
        bta_i, jta_i    : in    std_logic_vector(7 downto 0);
        branch_ctl_i    : in    std_logic;
        j_ctl_i         : in    std_logic;
        jr_ctl_i        : in    std_logic;
        read_data1_i    : in    std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
        c3_cmp_i        : in    std_logic;
        isr_i           : in    std_logic_vector(next_pc_width-1 downto 0);
        pc_o            : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
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
    signal pc_final_s           : std_logic_vector(next_pc_width-1 downto 0);
    signal pc_final_sel_s       : std_logic;
    signal alt_pc_add_s         : std_logic_vector(next_pc_width-1 downto 0);
    signal delayed_reset        : std_logic;
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
        init_file => ITCM_PATH,
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
        itcm_addr_w <= pc_final_s;
    elsif (WORD_GRANULARITY = False) generate   -- i.e. each BYTE has unike address
        itcm_addr_w <=  pc_final_s & "00";
    end generate;


    process(clk_i)
    begin
        if rising_edge(clk_i) then
            delayed_reset <= rst_i;
        end if;
    end process;
-- PC Register
    PC_Reg : entity work.nbit_dff
    generic map(n => NEXT_PC_WIDTH)
    port map(
        clk     => clk_i,
        rst     => delayed_reset,
        en      => '1',
        d_in    => pc_din_s,
        q_out   => pc_s
    );

    pc_din_s <= pc_final_s + 1;

    pc_final_sel_s <= branch_ctl_i or j_ctl_i or jr_ctl_i or c3_cmp_i;
    pc_final_s      <= alt_pc_add_s when pc_final_sel_s = '1' else pc_s;

    process(branch_ctl_i, j_ctl_i, jr_ctl_i, c3_cmp_i,
            bta_i, jta_i, read_data1_i, isr_i)
    begin
        if branch_ctl_i = '1' then
            alt_pc_add_s <= bta_i;
        elsif j_ctl_i = '1' then
            alt_pc_add_s <= jta_i;
        elsif jr_ctl_i = '1' then
            alt_pc_add_s <= read_data1_i;
        else
            alt_pc_add_s <= isr_i;
        end if;
    end process;

-- IPC - instruction counter register
    -- update previous PC signal 
        process (clk_i , rst_i)
        begin
            if rst_i = '1' then
                pc_prev_q   <=  (others => '0');
            elsif falling_edge(clk_i) then
                pc_prev_q(pc_width-1 downto 2)   <=  pc_final_s;
            end if;
        end process;

        pc_prev_q(1 downto 0) <= "00";

    -- update instruction couter signal
        process (clk_i , rst_i)
        begin
            if rst_i = '1' then
                inst_cnt_q  <=  (others => '0');
            elsif rising_edge(clk_i) then
                if pc_prev_q(pc_width-1 downto 2) = pc_s then
                    inst_cnt_q  <=  inst_cnt_q + '1';
                end if;
            end if;
        end process;

-- copy output signals - allows read inside module
    -- pc_o                <=  pc_final_s;
    pc_o                <=  pc_din_s;
    inst_cnt_o          <=  inst_cnt_q;
    instruction_o       <=  instruction_w;
END behavior;


