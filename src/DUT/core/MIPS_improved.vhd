LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;


ENTITY MIPS IS
    generic( 
            WORD_GRANULDCSARITY : boolean  := G_WORD_GRANULARITY;
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
            interrupt_src_i     :in std_logic_vector(7 downto 0);
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
END MIPS;
-------------------------------------------------------------------------------------
ARCHITECTURE structure OF MIPS IS
-- declare signals used to connect VHDL components
    SIGNAL bta_w, jta_w     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL zero_w           : STD_LOGIC;
    SIGNAL mem_read_w       : STD_LOGIC;
    SIGNAL instruction_w    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    SIGNAL MCLK_w           : STD_LOGIC;
    SIGNAL mclk_cnt_q       : STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);    
    SIGNAL inst_cnt_w       : STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);  
    signal write_data_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal write_reg_addr_w : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal hazard_unit_type_w : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal rd1_sel_w        : std_logic_vector(3 downto 0);
    signal rd2_sel_w        : std_logic_vector(3 downto 0);
    signal lw_hazard_rd1_w, lw_hazard_rd2_w     : std_logic;
    signal flush_cnt_s      : std_logic_vector(CLK_CNT_WIDTH-1 DOWNTO 0);
    signal hf_cnt_s         : std_logic_vector(CLK_CNT_WIDTH-1 DOWNTO 0);
    signal pc_s             : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);

-- interrupts
    signal inta_s, intr_s   : std_logic;
    signal interrupt_done_s : std_logic_vector(7 downto 0);
    signal data_input2databus_en_s : std_logic;
    signal c1_cmp_s, c3_cmp_s, c1to3_cmp_s, c2to5_cmp_s : std_logic;

-- Buses
    signal address_bus_s    : std_logic_vector(DTCM_ADDR_WIDTH-1 downto 0);
    signal data_bus_s       : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal control_bus_s    : std_logic_vector(1 downto 0); -- [mem_read, mem_write]
    
-- Pipeline
    -- IF
        signal if_instruction_wo, if_final_inst_w: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal if_pc_plus4_wo   : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
    -- CTL
        signal ctl_memwrite_wo, ctl_beq_wo, ctl_bne_wo, ctl_shamtctl_wo, ctl_regwrite_wo, ctl_wdsel_wo, ctl_regwrite_fwo, ctl_memread_wo : std_logic;
        signal ctl_memtoreg_wo, ctl_alusrc_wo, ctl_regdst_wo, k1_check_s, ctl_reti_s    : STD_LOGIC_VECTOR(1 DOWNTO 0);
        signal ctl_alufn_wo     : STD_LOGIC_VECTOR(4 DOWNTO 0);
        signal ctl_controls_qout_w : STD_LOGIC_VECTOR(17 DOWNTO 0);
    -- ID
        signal id_instruction_wi, id_instruction_si: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal id_pc_plus4_wi, id_pc_s_wi   : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
        signal id_rd1_wo, id_rd2_wo : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal id_zeroext_wo, id_signext_wo : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal id_sub_w: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal id_zflag_w, flush_ctl_w : std_logic;
    -- EX
        signal ex_instruction_wi: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal ex_pc_plus4_wi   : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
        signal ex_memwrite_wi, ex_beq_wi, ex_bne_wi, ex_shamtctl_wi, ex_regwrite_wi, ex_wdsel_wi, ex_memread_wi : std_logic;
        signal ex_memtoreg_wi, ex_alusrc_wi, ex_regdst_wi   : STD_LOGIC_VECTOR(1 DOWNTO 0);
        signal ex_alufn_wi      : STD_LOGIC_VECTOR(4 DOWNTO 0);
        signal ex_shamt_wi      : STD_LOGIC_VECTOR(4 DOWNTO 0);
        signal ex_rd1_wi, ex_rd2_wi, id_rd1_mux_w, id_rd2_mux_w, ex_rd1_final_w, ex_rd2_final_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal ex_zeroext_wi, ex_signext_wi : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal ex_alures_wo     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal ex_sltres_wo     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal ex_luires_wo     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal ex_controls_qout_w : STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- MEM
        signal mem_instruction_wi: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal mem_pc_plus4_wi  : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
        signal mem_memtoreg_wi, mem_regdst_wi   : STD_LOGIC_VECTOR(1 DOWNTO 0);
        signal mem_memwrite_wi, mem_regwrite_wi, mem_wdsel_wi, mem_memread_wi   : std_logic;
        signal mem_rd1_wi, mem_rd2_wi: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal mem_alures_wi, mem_alures_si    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal mem_sltres_wi    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal mem_luires_wi    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal mem_dtcm_data_wo, mem_dtcm_rd_s : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal mem_controls_qout_w : STD_LOGIC_VECTOR(5 DOWNTO 0);
    -- WB
        signal wb_instruction_wi: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal wb_pc_plus4_wi   : STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
        signal wb_regwrite_wi, wb_wdsel_wi : STD_LOGIC;
        signal wb_memtoreg_wi, wb_regdst_wi : STD_LOGIC_VECTOR(1 DOWNTO 0);
        signal wb_rd1_wi, wb_dtcm_data_wi, wb_alures_wi : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal wb_sltres_wi     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal wb_luires_wi     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    
-- Controls
    SIGNAL  MemtoReg_w      : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL  mem_write_w     : STD_LOGIC;
    signal  j_ctl_w         : std_logic;
    signal  beq_ctl_w       : std_logic;
    signal  bne_ctl_w       : std_logic;
    signal  alufn_w         : std_logic_vector(4 downto 0);
    SIGNAL  alu_src_w       : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL  reg_dst_w       : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL  reg_write_w     : STD_LOGIC;
    signal  WDsel_w         : STD_LOGIC;
    signal  lw_ctl_w        : std_logic;
    signal  sw_ctl_w        : std_logic;
    signal  shamt_ctl_w     : std_logic;
    signal  jr_ctl_w        : std_logic;
    signal  branch_ctl_w    : std_logic;

    
BEGIN
-- copy important signals to output pins for easy display in Simulator
    instruction_top_o   <=  if_final_inst_w;
    alu_result_o        <=  ex_alures_wo;
    read_data1_o        <=  id_rd1_mux_w;
    read_data2_o        <=  id_rd2_mux_w;
    write_data_o        <=  write_data_w;
                                
    Branch_ctrl_o       <=  branch_ctl_w;
    Zero_o              <=  zero_w;
    RegWrite_ctrl_o     <=  wb_regwrite_wi;
    MemWrite_ctrl_o     <=  mem_regwrite_wi;    

    
-- connect the PLL component
    G0:
    if (MODELSIM = 0) generate
      MCLK: PLL
        PORT MAP (
            inclk0  => clk_i,
            c0      => MCLK_w
        );
    else generate
        MCLK_w <= clk_i;
    end generate;
    

--------------------------------------------------------------------
-- Create separators between 5 stages
--------------------------------------------------------------------
-- IF ID
    IF_instruction : nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => if_final_inst_w,
        q_out  => id_instruction_si
    );

    id_instruction_wi <= id_instruction_si when (c1_cmp_s = '0') else (others => '0');

    IF_pc_plus4 : nbit_dff
    generic map (
        n => NEXT_PC_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => if_pc_plus4_wo,
        q_out  => id_pc_plus4_wi
    );
    IF_PC_S: nbit_dff
    generic map (
        n => NEXT_PC_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => pc_s,
        q_out  => id_pc_s_wi
    );
-- ID EX
    CTL_controls : nbit_dff
    generic map (
        n => 17
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ctl_memread_wo & ctl_memtoreg_wo & ctl_memwrite_wo & ctl_beq_wo & ctl_bne_wo & ctl_alufn_wo & ctl_alusrc_wo & ctl_regdst_wo & ctl_regwrite_wo & ctl_wdsel_wo & ctl_shamtctl_wo,
        q_out  => ctl_controls_qout_w
    );
    ex_memread_wi   <= ctl_controls_qout_w(17);
    ex_memtoreg_wi  <= ctl_controls_qout_w(16 downto 15);
    ex_memwrite_wi  <= ctl_controls_qout_w(14);
    ex_beq_wi       <= ctl_controls_qout_w(13);
    ex_bne_wi       <= ctl_controls_qout_w(12);
    ex_alufn_wi     <= ctl_controls_qout_w(11 downto 7);
    ex_alusrc_wi    <= ctl_controls_qout_w(6 downto 5);
    ex_regdst_wi    <= ctl_controls_qout_w(4 downto 3);
    ex_regwrite_wi  <= ctl_controls_qout_w(2);
    ex_wdsel_wi     <= ctl_controls_qout_w(1);
    ex_shamtctl_wi  <= ctl_controls_qout_w(0);
    
    ID_pc_plus4 : nbit_dff
    generic map (
        n => NEXT_PC_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_pc_plus4_wi,
        q_out  => ex_pc_plus4_wi
    );
    ID_shamt : nbit_dff
    generic map (
        n => 5
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_instruction_wi(10 downto 6),
        q_out  => ex_shamt_wi
    );
    ID_inst : nbit_dff
    generic map (
        n => 32
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_instruction_wi,
        q_out  => ex_instruction_wi
    );
    ID_rd1 : nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_rd1_mux_w,
        q_out  => ex_rd1_wi 
    );

    -- Generate 8 instances
    gen_hex_drivers : for i in 0 to 7 generate
    begin
        hex_driver_inst : hex_driver
        port map (
                     num_in  => write_data_w(i * 4 + 3 downto i * 4),
                     en      => '1',
                     num_out => hex_o(i)
                 );
    end generate;

    with rd1_sel_w select
        id_rd1_mux_w <= 
            id_rd1_wo           when "0000",
            
            ex_alures_wo        when "0001",
            ex_sltres_wo        when "0010",
            ex_luires_wo        when "0011",
            mem_dtcm_data_wo    when "0100",

            mem_alures_wi       when "0101",
            mem_sltres_wi       when "0110",
            mem_luires_wi       when "0111",
            mem_dtcm_data_wo    when "1000",

            wb_alures_wi        when "1001",
            wb_sltres_wi        when "1010",
            wb_luires_wi        when "1011",
            wb_dtcm_data_wi     when "1100",

            id_rd1_wo           when others;


    ID_rd2 : nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_rd2_mux_w,
        q_out  => ex_rd2_wi
    );

    with rd2_sel_w select
        id_rd2_mux_w <= 
            id_rd2_wo           when "0000",
            
            ex_alures_wo        when "0001",
            ex_sltres_wo        when "0010",
            ex_luires_wo        when "0011",
            mem_dtcm_data_wo    when "0100",

            mem_alures_wi       when "0101",
            mem_sltres_wi       when "0110",
            mem_luires_wi       when "0111",
            mem_dtcm_data_wo    when "1000",

            wb_alures_wi        when "1001",
            wb_sltres_wi        when "1010",
            wb_luires_wi        when "1011",
            wb_dtcm_data_wi     when "1100",

            id_rd2_wo           when others;

    id_zero_ext : nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_zeroext_wo,
        q_out  => ex_zeroext_wi
    );
    id_sign_ext : nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => id_signext_wo,
        q_out  => ex_signext_wi
    );
-- EX MEM
    EX_controls: nbit_dff
    generic map (
        n => 7
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_memread_wi, ex_memtoreg_wi & ex_memwrite_wi & ex_regdst_wi & ex_regwrite_wi & ex_wdsel_wi,
        q_out  => ex_controls_qout_w
    );
    mem_memread_wi  <= ex_controls_qout_w(7);
    mem_memtoreg_wi <= ex_controls_qout_w(6 downto 5);
    mem_memwrite_wi <= ex_controls_qout_w(4);
    mem_regdst_wi   <= ex_controls_qout_w(3 downto 2);
    mem_regwrite_wi <= ex_controls_qout_w(1);
    mem_wdsel_wi    <= ex_controls_qout_w(0);

    -- Control BUS
    control_bus_s <= mem_memread_wi & mem_memwrite_wi;
    
    EX_pc_plus4 : nbit_dff
    generic map (
        n => NEXT_PC_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_pc_plus4_wi,
        q_out  => mem_pc_plus4_wi
    );
    EX_inst : nbit_dff
    generic map (
        n => 32
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_instruction_wi,
        q_out  => mem_instruction_wi
    );
    EX_rd1: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_rd1_wi,
        q_out  => mem_rd1_wi
    );
    EX_rd2: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_rd2_wi,
        q_out  => mem_rd2_wi
    );
    EX_alures: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_alures_wo,
        q_out  => mem_alures_wi
    );

    EX_sltres: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_sltres_wo,
        q_out  => mem_sltres_wi
    );

    EX_luires: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => ex_luires_wo,
        q_out  => mem_luires_wi
    );
-- MEM WB
    MEM_controls: nbit_dff
    generic map (
        n => 6
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_memtoreg_wi & mem_regdst_wi & mem_regwrite_wi & mem_wdsel_wi,
        q_out  => mem_controls_qout_w
    );
    wb_memtoreg_wi  <= mem_controls_qout_w(5 downto 4);
    wb_regdst_wi    <= mem_controls_qout_w(3 downto 2);
    wb_regwrite_wi  <= mem_controls_qout_w(1);
    wb_wdsel_wi     <= mem_controls_qout_w(0);
    
    MEM_pc_plus4 : nbit_dff
    generic map (
        n => NEXT_PC_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_pc_plus4_wi,
        q_out  => wb_pc_plus4_wi
    );
    MEM_inst : nbit_dff
    generic map (
        n => 32
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_instruction_wi,
        q_out  => wb_instruction_wi
    );
    MEM_rd1: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_rd1_wi,
        q_out  => wb_rd1_wi
    );
    MEM_dtcm_data: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_dtcm_data_wo,
        q_out  => wb_dtcm_data_wi
    );
    MEM_alures: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_alures_wi,
        q_out  => wb_alures_wi
    );

    MEM_sltres: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_sltres_wi,
        q_out  => wb_sltres_wi
    );

    MEM_luires: nbit_dff
    generic map (
        n => DATA_BUS_WIDTH
    )
    port map (
        clk    => MCLK_w,
        rst    => not(rst_i),
        en     => '1',
        d_in   => mem_luires_wi,
        q_out  => wb_luires_wi
    );


-- Connect the 5 MIPS stages   
-- IF
    IFE : Ifetch
    generic map(
        WORD_GRANULARITY    =>  WORD_GRANULARITY,
        DATA_BUS_WIDTH      =>  DATA_BUS_WIDTH, 
        PC_WIDTH            =>  PC_WIDTH,
        ITCM_ADDR_WIDTH     =>  ITCM_ADDR_WIDTH,
        WORDS_NUM           =>  DATA_WORDS_NUM,
        INST_CNT_WIDTH      =>  INST_CNT_WIDTH
    )
    PORT MAP (  
        clk_i           => MCLK_w,  
        rst_i           => not(rst_i), 
        bta_i           => bta_w,               -- ID   => IF
        jta_i           => jta_w,
        Branch_ctl_i    => branch_ctl_w,        -- EX   => IF
        j_ctl_i         => j_ctl_w,             -- CTL  => IF
        jr_ctl_i        => jr_ctl_w,            -- CTL  => IF
        read_data1_i    => id_rd1_wo(PC_WIDTH-1 downto 2), -- ID   => IF
        c3_cmp_i        => c3_cmp_s,            -- IH   => IF
        isr_i           => mem_dtcm_data_wo     -- MEM  => IF
        pc_o            => pc_s,                -- IF   => MIPS
        pc_plus4_o      => if_pc_plus4_wo,      -- IF   => ID
        instruction_o   => if_instruction_wo,   -- IF   => ID, CTL
        inst_cnt_o      => inst_cnt_w           -- IF   => MIPS
    );

    if_final_inst_w <= if_instruction_wo when (flush_ctl_w = '0') else (others => '0');
    

-- ID & CTL
    ID : Idecode
    generic map(
        DATA_BUS_WIDTH      =>  DATA_BUS_WIDTH
    )
    PORT MAP (  
        clk_i           => MCLK_w,          
        rst_i           => not(rst_i),
        instruction_i   => id_instruction_wi,   -- IF   => ID, CTL
        RegWrite_ctrl_i => wb_regwrite_wi,      -- CTL  => ID, MIPS
        write_reg_addr_i => write_reg_addr_w,   -- WB   => ID
        write_reg_data_i => write_data_w,       -- WB   => ID
        pc_plus4_i      => id_pc_plus4_wi,      -- IF   => ID
        id_pc_i         => id_pc_s_wi,          -- IF   => ID
        c1_cmp_i        => c1_cmp_s,            -- IH   => ID
        c3_cmp_i        => c3_cmp_s,            -- IH   => ID
        c2to5_cmp_i     => c2to5_cmp_s,         -- IH   => ID
        INTR_i          => intr_s,              -- MIPS => ID
        read_data1_o    => id_rd1_wo,           -- ID   => IF, EX, MIPS
        read_data2_o    => id_rd2_wo,           -- ID   => EX, MEM, MIPS
        sign_extend_o   => id_signext_wo,       -- ID   => EX
        zero_extend_o   => id_zeroext_wo,       -- ID   => EX
        jta_o           => jta_w,               -- ID   => IF
        bta_o           => bta_w                -- ID   => IF
    );

    id_sub_w    <= id_rd1_mux_w - id_rd2_mux_w;
    id_zflag_w  <= '1' when (id_sub_w = x"00000000") else '0';
    flush_ctl_w <= j_ctl_w or jr_ctl_w or (ctl_beq_wo and id_zflag_w) or (ctl_bne_wo and not(id_zflag_w)) or (c1to3_cmp_s = '1');
    branch_ctl_w <= (ctl_beq_wo and id_zflag_w) or (ctl_bne_wo and not(id_zflag_w));

    CTL:   control
    PORT MAP (  
        op          => id_instruction_wi(DATA_BUS_WIDTH-1 DOWNTO 26), -- IF => CTL
        funct       => id_instruction_wi(5 downto 0), -- IF => CTL
        MemtoReg    => ctl_memtoreg_wo, -- CTL  => ID, MIPS
        MemWrite    => ctl_memwrite_wo, -- CTL  => MEM
        jump        => j_ctl_w,         -- CTL  => IF
        beq         => ctl_beq_wo,      -- CTL  => EX
        bne         => ctl_bne_wo,      -- CTL  => EX
        alufn       => ctl_alufn_wo,    -- CTL  => EX
        ALUSrc      => ctl_alusrc_wo,   -- CTL  => EX
        RegDst      => ctl_regdst_wo,   -- CTL  => ID
        RegWrite    => ctl_regwrite_wo, -- CTL  => ID
        WDsel       => ctl_wdsel_wo,    -- CTL  => ID
        lw_o        => lw_ctl_w,        -- CTL  => MIPS
        sw_o        => sw_ctl_w,        -- CTL  => MIPS
        shamt_ctl   => ctl_shamtctl_wo, -- CTL  => EX
        jr          => jr_ctl_w,        -- CTL  => IF
        hazard_unit_type_o => hazard_unit_type_w
    );

    k1_check_s <= '1' when (id_instruction_wi(25 downto 21) = 27) else '0';
    ctl_reti_s <= jr_ctl_w and k1_check_s;
    control_bus_s <= lw_ctl_w & sw_ctl_w;

-- EX
    ex_rd1_final_w <= ex_rd1_wi when (lw_hazard_rd1_w = '0') else mem_dtcm_data_wo;
    ex_rd2_final_w <= ex_rd2_wi when (lw_hazard_rd2_w = '0') else mem_dtcm_data_wo;

    EXE:  Execute
    generic map(
        DATA_BUS_WIDTH      =>  DATA_BUS_WIDTH,
        FUNCT_WIDTH         =>  FUNCT_WIDTH,
        PC_WIDTH            =>  PC_WIDTH
    )
    PORT MAP (  
        read_data1_i    => ex_rd1_final_w,      -- ID   => EX
        read_data2_i    => ex_rd2_final_w,      -- ID   => EX
        sign_extend_i   => ex_signext_wi,   -- ID   => EX
        zero_extend_i   => ex_zeroext_wi,   -- ID   => EX
        shamt_i         => instruction_w(10 downto 6), -- IF    => EX
        shamt_ctl_i     => ex_shamtctl_wi,  -- CTL  => EX
        ALUSrc_ctrl_i   => ex_alusrc_wi,    -- CTL  => EX
        bne_ctl_i       => ex_bne_wi,       -- CTL  => EX
        beq_ctl_i       => ex_beq_wi,       -- CTL  => EX
        alufn_i         => ex_alufn_wi,     -- CTL  => EX
        alu_res_o       => ex_alures_wo,    -- EX   => ID, MEM, MIPS
        slt_res_o       => ex_sltres_wo,
        lui_res_o       => ex_luires_wo,
        zero_o          => zero_w,          -- EX   => MIPS
        branch_ctl_o    => open     -- EX   => IF
        );

-- MEM
    G1: 
    if (WORD_GRANULARITY = True) generate -- i.e. each WORD has a unike address
        MEM:  dmemory
            generic map(
                DATA_BUS_WIDTH      =>  DATA_BUS_WIDTH, 
                DTCM_ADDR_WIDTH     =>  DTCM_ADDR_WIDTH,
                WORDS_NUM           =>  DATA_WORDS_NUM
            )
            PORT MAP (  
                clk_i               => MCLK_w,  
                rst_i               => not(rst_i),
                dtcm_addr_i         => mem_alures_si((DTCM_ADDR_WIDTH+2)-1 DOWNTO 2), -- increment memory address by 4; ID => MEM
                dtcm_data_wr_i      => mem_rd2_wi,          -- ID => MEM
                MemRead_ctrl_i      => mem_memread_wi,      -- no use inside entity
                MemWrite_ctrl_i     => mem_memwrite_wi,     -- CTL => MEM
                dtcm_data_rd_o      => mem_dtcm_rd_s        -- MEM => ID, IF, MIPS
            );  
    elsif (WORD_GRANULARITY = False) generate -- i.e. each BYTE has a unike address 
        MEM:  dmemory
            generic map(
                DATA_BUS_WIDTH      =>  DATA_BUS_WIDTH, 
                DTCM_ADDR_WIDTH     =>  DTCM_ADDR_WIDTH,
                WORDS_NUM           =>  DATA_WORDS_NUM
            )
            PORT MAP (  
                clk_i               => MCLK_w,  
                rst_i               => not(rst_i),
                dtcm_addr_i         => mem_alures_si(DTCM_ADDR_WIDTH-1 DOWNTO 2)&"00",  -- ID => MEM
                dtcm_data_wr_i      => mem_rd2_wi,          -- ID => MEM
                MemRead_ctrl_i      => mem_memread_wi,      -- no use inside entity
                MemWrite_ctrl_i     => mem_memwrite_wi,     -- CTL => MEM
                dtcm_data_rd_o      => mem_dtcm_rd_s        -- MEM => ID, IF, MIPS
            );
    end generate;

-- WB
    WB: WRITE_BACK
        port map(
            MemtoReg_ctl_i      => wb_memtoreg_wi,
            RegDst_ctl_i        => wb_regdst_wi,
            RegWrite_ctl_i      => wb_regwrite_wi,
            WDSel_ctl_i         => wb_wdsel_wi,
            ALU_Result_i        => wb_alures_wi,
            dtcm_data_i         => wb_dtcm_data_wi,
            imm_i               => wb_instruction_wi(15 downto 0),
            PC_plus_4_i         => wb_pc_plus4_wi,
            rt_rd_i             => wb_instruction_wi(20 downto 11),
            write_data_o        => write_data_w,
            write_reg_addr_o    => write_reg_addr_w
        );

-- Connect other cpu inside units
-- Hazard Unit
    hazard_unit: hazardunit
    port map(
        clk_i       => MCLK_w, 
        rst_i       => not(rst_i),
        inst_type_i => hazard_unit_type_w,
        rs_rt_rd_i  => id_instruction_wi(25 downto 11),
        rd1_sel_o   => rd1_sel_w,
        rd2_sel_o   => rd2_sel_w,
        lw_hazard_rd1_o => lw_hazard_rd1_w,
        lw_hazard_rd2_o => lw_hazard_rd2_w
    );

-- Interrupts
    int_ctl_unit: interrupt_controller_unit
    generic map (
        ADDRESS_BUS_WIDTH     => DTCM_ADDR_WIDTH,   -- the width of the address bus
        DATA_BUS_WIDTH        => DATA_BUS_WIDTH,    -- width of the data bus
    )
    port map (
        clk_i               => MCLK_w,
        rst_i               => not(rst_i),
        inta_i              => inta_s,
        interrupt_src_i     => interrupt_src_i,
        address_bus_i       => address_bus_s,
        data_bus_io         => data_bus_s,
        mem_write_c_i       => control_bus_s(1),
        mem_read_c_i        => control_bus_s(0),
        interrupt_done_o    => interrupt_done_s,
        int_req_o           => intr_s
    );

    -- interrupt handler module
        interrupt_handler: interrupt_handler
        generic map(data_bus_width => DATA_BUS_WIDTH)
        port map(
            clk_i               => MCLK_w,
            rst_i               => not(rst_i),
            intr_i              => intr_s,
            reti_ctl_i          => ctl_reti_s,
            instruction_id_i    => id_instruction_wi,
            c1_cmp_o            => c1_cmp_s,
            c3_cmp_o            => c3_cmp_s,
            c1to3_cmp_o         => c1to3_cmp_s,
            c2to5_cmp_o         => c2to5_cmp_s
        );

    -- INTA logic
        process(rst_i, MCLK_w)
        begin
            if not(rst_i) = '1' then
                inta_proc1_s <= '1';
            elsif rising_edge(MCLK_w) then
                inta_proc1_s <= intr_s;
            end if;
        end process;

        process(rst_i, MCLK_w)
        begin
            if not(rst_i) = '1' then
                inta_proc2_s <= '1';
            elsif rising_edge(MCLK_w) then
                inta_proc2_s <= inta_proc1_s;
            end if;
        end process;

        process(rst_i, MCLK_w)
        begin
            if not(rst_i) = '1' then
                inta_proc3_s <= '1';
            elsif rising_edge(MCLK_w) then
                inta_proc3_s <= inta_proc2_s;
            end if;
        end process;

        inta_s <= not(rst_i and not(inta_proc3_s) and inta_proc1_s);

    -- mem addr mux for interrupts
        mem_alures_si <= data_bus_s when (c3_cmp_s = '1') else mem_alures_wi;

    -- address bus written from alures
        address_bus_s <= mem_alures_wi;

    -- write to peripherals using tri-state 
        peripheral_write: nbit_bidir
        generic map (width => DATA_BUS_WIDTH)
        port map (
            Dout    => mem_rd2_wi,
            en      => mem_alures_wi(11),   -- peripherals addresses are 0x800 and above
            Din     => open,
            IOpin   => data_bus_s
        );

    -- Mem Data Read
        mem_dtcm_data_wo <= mem_dtcm_rd_s when ((mem_alures_wi(11) and mem_memread_wi) = '1') else data_bus_s; 

    -- write from dtcm input to data bus enable tri-state
        data_input2databus_en_s <= mem_memwrite_wi and mem_alures_wi(11);
---------------------------------------------------------------------------------------
--                                  IPC - MCLK counter register
---------------------------------------------------------------------------------------
    strigger_o <= '1' when (pc_s(PC_WIDTH - 1 downto 2) = bpaddr_i) else '0';
    pc_o <= pc_s;

    process (MCLK_w , rst_i)
    begin
        if rst_i = '0' then
            mclk_cnt_q  <=  (others => '0');
        elsif falling_edge(MCLK_w) then
            mclk_cnt_q  <=  mclk_cnt_q + '1';
        end if;
    end process;

    process (MCLK_w, rst_i)
    begin
        if rst_i = '0' then
            hf_cnt_s    <=  (others => '0');
        elsif rising_edge(MCLK_w) then
            if (not(rd1_sel_w = "0000") or not(rd2_sel_w = "0000")) then
                hf_cnt_s    <=  hf_cnt_s + '1';
            end if;
        end if;
    end process;

    process (flush_ctl_w , rst_i)
    begin
        if rst_i = '0' then
            flush_cnt_s   <=    (others => '0');
        elsif falling_edge(flush_ctl_w) then
            flush_cnt_s   <=    flush_cnt_s + '1';
        end if;
    end process;

    hf_cnt      <= hf_cnt_s;
    flush_cnt   <= flush_cnt_s;
    mclk_cnt_o  <=  mclk_cnt_q;
    inst_cnt_o  <=  inst_cnt_w;
---------------------------------------------------------------------------------------

END structure;

