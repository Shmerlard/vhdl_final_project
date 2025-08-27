library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cond_comilation_package.all;
use work.aux_package.all;


ENTITY tb_top_timing IS
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
    port(
        rst_i               : in std_logic;
        clk_i               : in std_logic; 
        bpaddr_i            : in std_logic_vector(7 downto 0);
        keys_i              : in std_logic_vector(2 downto 0);
        switches_i          : in std_logic_vector(7 downto 0);

        hex_arr_o           : out t_hex_array(0 to 5);
        leds_o              : out std_logic_vector(7 downto 0);

        pc_o                :OUT    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        alu_result_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        read_data1_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        read_data2_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        write_data_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        instruction_top_o   :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        Branch_ctrl_o       :OUT    STD_LOGIC;
        Zero_o              :OUT    STD_LOGIC;
        MemWrite_ctrl_o     :OUT    STD_LOGIC;
        int_ack_o           : out   std_logic;
        int_req_o           : out   std_logic;
        RegWrite_ctrl_o     :OUT    STD_LOGIC;
        mclk_cnt_o          :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
        inst_cnt_o          :OUT    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
        pwm_out             : out   std_logic;
        flush_cnt           :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
        hf_cnt              :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
        strigger_o          :OUT    std_logic;

        data_bus_o          : out   std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0)

        );
END tb_top_timing ;


ARCHITECTURE struct OF tb_top_timing IS

        signal s_i_rst_i               : std_logic;
        signal s_i_clk_i               : std_logic; 
        signal s_i_bpaddr_i            : std_logic_vector(7 downto 0);
        signal s_i_keys_i              : std_logic_vector(2 downto 0);
        signal s_i_switches_i          : std_logic_vector(7 downto 0);

        signal s_o_hex_arr_o           :  t_hex_array(0 to 5);
        signal s_o_leds_o              :  std_logic_vector(7 downto 0);

        signal s_o_pc_o                :    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        signal s_o_alu_result_o        :    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal s_o_read_data1_o        :    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal s_o_read_data2_o        :    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal s_o_write_data_o        :    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal s_o_instruction_top_o   :    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        signal s_o_Branch_ctrl_o       :    STD_LOGIC;
        signal s_o_Zero_o              :    STD_LOGIC;
        signal s_o_MemWrite_ctrl_o     :    STD_LOGIC;
        signal s_o_int_ack_o           :    std_logic;
        signal s_o_int_req_o           :    std_logic;
        signal s_o_RegWrite_ctrl_o     :    STD_LOGIC;
        signal s_o_mclk_cnt_o          :    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
        signal s_o_inst_cnt_o          :    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
        signal s_o_pwm_out             :    std_logic;
        signal s_o_flush_cnt           :    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
        signal s_o_hf_cnt              :    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
        signal s_o_strigger_o          :    std_logic;

        signal s_o_data_bus_o          :    std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);

BEGIN
    -- top_proc : entity work.mips_top
    -- generic map(
    --     WORD_GRANULARITY            => WORD_GRANULARITY,
    --     MODELSIM                    => 0,
    --     DATA_BUS_WIDTH              => DATA_BUS_WIDTH,
    --     ITCM_ADDR_WIDTH             => ITCM_ADDR_WIDTH,
    --     DTCM_ADDR_WIDTH             => DTCM_ADDR_WIDTH,
    --     PC_WIDTH                    => PC_WIDTH,
    --     -- FUNCT_WIDTH                 => FUNCT_WIDTH,
    --     DATA_WORDS_NUM              => DATA_WORDS_NUM,
    --     CLK_CNT_WIDTH               => CLK_CNT_WIDTH,
    --     INST_CNT_WIDTH              => INST_CNT_WIDTH,
    --
    --     DTCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/interupt_IO/test4/bin/M9K/DTCM.hex",
    --     ITCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/interupt_IO/test4/bin/M9K/ITCM.hex"
    --
    -- )
    -- PORT MAP (
    --     rst_i               => rst_tb_i,
    --     clk_i               => clk_tb_i,
    --     bpaddr_i            => "00000000",
    --     keys_i              => keys_s,
    --     switches_i          => switches_s,
    --     leds_o              => leds_s
    -- );
    top_tb: entity work.mips_top
     generic map(
        WORD_GRANULARITY => WORD_GRANULARITY,
        -- USE_ALT_CLK => USE_ALT_CLK,
        MODELSIM => MODELSIM,
        DATA_BUS_WIDTH => DATA_BUS_WIDTH,
        ITCM_ADDR_WIDTH => ITCM_ADDR_WIDTH,
        DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH,
        PC_WIDTH => PC_WIDTH,
        -- NEXT_PC_WIDTH => NEXT_PC_WIDTH,
        DATA_WORDS_NUM => DATA_WORDS_NUM,
        CLK_CNT_WIDTH => CLK_CNT_WIDTH,
        INST_CNT_WIDTH => INST_CNT_WIDTH,
        DTCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/interupt_IO/test4/bin/M9K/DTCM.hex",
        ITCM_PATH                   => "/home/elad/Desktop/vhdl_final_project/src/SW/interupt_IO/test4/bin/M9K/ITCM.hex"
    )
     port map(
        rst_i => s_i_rst_i,
        clk_i => s_i_clk_i,
        bpaddr_i => s_i_bpaddr_i,
        keys_i => s_i_keys_i,
        switches_i => s_i_switches_i,
        hex_arr_o => s_o_hex_arr_o,
        leds_o => s_o_leds_o,
        pc_o => s_o_pc_o,
        alu_result_o => s_o_alu_result_o,
        read_data1_o => s_o_read_data1_o,
        read_data2_o => s_o_read_data2_o,
        write_data_o => s_o_write_data_o,
        instruction_top_o => s_o_instruction_top_o,
        Branch_ctrl_o => s_o_Branch_ctrl_o,
        Zero_o => s_o_Zero_o,
        MemWrite_ctrl_o => s_o_MemWrite_ctrl_o,
        int_ack_o => s_o_int_ack_o,
        int_req_o => s_o_int_req_o,
        RegWrite_ctrl_o => s_o_RegWrite_ctrl_o,
        mclk_cnt_o => s_o_mclk_cnt_o,
        inst_cnt_o => s_o_inst_cnt_o,
        pwm_out => s_o_pwm_out,
        flush_cnt => s_o_flush_cnt,
        hf_cnt => s_o_hf_cnt,
        strigger_o => s_o_strigger_o,
        data_bus_o => s_o_data_bus_o
    );
    for i in 0 to 25 generate
        
    end generate;
END struct;
