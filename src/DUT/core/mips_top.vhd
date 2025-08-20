LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

ENTITY mips_top IS
    generic( 
            WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
            MODELSIM : integer          := G_MODELSIM;
            DATA_BUS_WIDTH : integer    := 32;
            ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            PC_WIDTH : integer          := 10;
            NEXT_PC_WIDTH : integer     := 8;
            FUNCT_WIDTH : integer       := 6;
            DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
            CLK_CNT_WIDTH : integer     := 16;
            INST_CNT_WIDTH : integer    := 16;
            DTCM_PATH : string;
            ITCM_PATH : string
    );
    PORT(   rst_i               :IN STD_LOGIC;
            clk_i               :IN STD_LOGIC; 
            bpaddr_i            :IN STD_LOGIC_VECTOR(7 downto 0);
            -- Output important signals to pins for easy display in SignalTap
            -- pc_o                :OUT    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
            -- alu_result_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            -- read_data1_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            -- read_data2_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            -- write_data_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            -- instruction_top_o   :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            -- Branch_ctrl_o       :OUT    STD_LOGIC;
            -- Zero_o              :OUT    STD_LOGIC;
            -- MemWrite_ctrl_o     :OUT    STD_LOGIC;
            -- RegWrite_ctrl_o     :OUT    STD_LOGIC;
            -- mclk_cnt_o          :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
            -- inst_cnt_o          :OUT    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
            hex_o               :OUT    t_hex_array(0 to 7)
            -- flush_cnt           :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            -- hf_cnt              :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            -- strigger_o          :OUT    std_logic
    );
END mips_top;

ARCHITECTURE rtl OF mips_top IS
    signal int_req_s : std_logic;
    signal int_ack_s : std_logic;
    signal int_src_s : std_logic_vector(8 downto 0);
    signal gie_s     : std_logic;

    signal data_bus_s    :STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal     addr_bus_s:  STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
    signal     ctrl_bus_s:  STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    mips_core_inst: entity work.mips_core
    generic map(
        WORD_GRANULARITY => WORD_GRANULARITY,
        MODELSIM => MODELSIM,
        DATA_BUS_WIDTH => DATA_BUS_WIDTH,
        ITCM_ADDR_WIDTH => ITCM_ADDR_WIDTH,
        DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH,
        PC_WIDTH => PC_WIDTH,
        NEXT_PC_WIDTH => NEXT_PC_WIDTH,
        FUNCT_WIDTH => FUNCT_WIDTH,
        DATA_WORDS_NUM => DATA_WORDS_NUM,
        CLK_CNT_WIDTH => CLK_CNT_WIDTH,
        INST_CNT_WIDTH => INST_CNT_WIDTH,
        DTCM_PATH => DTCM_PATH,
        ITCM_PATH => ITCM_PATH
    )
    port map(
        rst_i => rst_i,
        clk_i => clk_i,
        bpaddr_i => bpaddr_i,
        int_req_i => int_req_s,
        interrupt_src_i =>  int_src_s,

        data_bus_o => data_bus_s,
        addr_bus_o => addr_bus_s,
        ctrl_bus_o => ctrl_bus_s,
        -- pc_o => pc_o,
        -- alu_result_o => alu_result_o,
        -- read_data1_o => read_data1_o,
        -- read_data2_o => read_data2_o,
        -- write_data_o => write_data_o,
        int_ack_o => int_ack_s,
        gie_o   => gie_s
        -- instruction_top_o => instruction_top_o,
        -- Branch_ctrl_o => Branch_ctrl_o,
        -- Zero_o => Zero_o,
        -- MemWrite_ctrl_o => MemWrite_ctrl_o,
        -- RegWrite_ctrl_o => RegWrite_ctrl_o,
        -- mclk_cnt_o => mclk_cnt_o,
        -- inst_cnt_o => inst_cnt_o,
        -- hex_o => hex_o,
        -- flush_cnt => flush_cnt,
        -- hf_cnt => hf_cnt,
        -- strigger_o => strigger_o
    );

    -- int_req_s <= '0';
    interrupt_controller_unit_inst: entity work.interrupt_controller_unit
    generic map(
        ADDRESS_BUS_WIDTH => DTCM_ADDR_WIDTH,
        DATA_BUS_WIDTH => DATA_BUS_WIDTH
        -- INT_UNIT_ADDRESS_ARRAY => INT_UNIT_ADDRESS_ARRAY,
        -- INT_SRC_COUNT => INT_SRC_COUNT,
        -- INT_IFG_COUNT => INT_IFG_COUNT
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        inta_i => int_ack_s,
        interrupt_src_i => int_src_s,
        -- reti_i => reti_i,
        gie_i => gie_s,
        mem_write_c_i => ctrl_bus_s(0),
        mem_read_c_i => ctrl_bus_s(1),
        address_bus_i => addr_bus_s,
        data_bus_io => data_bus_s,
        int_req_o => int_req_s
    );
END ARCHITECTURE rtl;
