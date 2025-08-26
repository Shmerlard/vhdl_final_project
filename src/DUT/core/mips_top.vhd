LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;
use work.memory_map.all;

ENTITY mips_top IS
    generic( 
        WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
        USE_ALT_CLK: boolean        := false;
        -- MODELSIM : integer          := G_MODELSIM;
        MODELSIM : integer          := 0;
        DATA_BUS_WIDTH : integer    := 32;
        ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
        DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
        PC_WIDTH : integer          := 10;
        NEXT_PC_WIDTH : integer     := 8;
        DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
        CLK_CNT_WIDTH : integer     := 16;
        INST_CNT_WIDTH : integer    := 16;
        DTCM_PATH : string := "/home/elad/Desktop/vhdl_final_project/src/SW/JR_test/DTCM.hex";
        ITCM_PATH : string := "/home/elad/Desktop/vhdl_final_project/src/SW/JR_test/ITCM.hex"
        -- DTCM_PATH : string := "/home/elad/Desktop/vhdl_final_project/src/SW/GPIO/test0/bin/M9K/DTCM.hex";
        -- ITCM_PATH : string := "/home/elad/Desktop/vhdl_final_project/src/SW/GPIO/test0/bin/M9K/ITCM.hex"
    );
    PORT(
        rst_i               : in std_logic;
        clk_i               : in std_logic; 
        bpaddr_i            : in std_logic_vector(7 downto 0);
        keys_i              : in std_logic_vector(2 downto 0);
        switches_i          : in std_logic_vector(7 downto 0);

        hex_arr_o           : out t_hex_array(0 to 5);
        leds_o              : out std_logic_vector(7 downto 0);

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
END mips_top;

ARCHITECTURE rtl OF mips_top IS
    signal int_req_s    : std_logic;
    signal int_ack_s    : std_logic;
    signal int_src_s    : std_logic_vector(8 downto 0) := (others => '0');
    signal gie_s        : std_logic;

    signal rst_s        : std_logic;
    signal rst_asy      : std_logic;

    signal data_bus_s   : std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0);
    signal addr_bus_s   : std_logic_vector((PC_WIDTH + 2)-1 DOWNTO 0);
    signal ctrl_bus_s   : std_logic_vector(1 DOWNTO 0);
    signal mclk_s       : std_logic;
    signal mclk2_s      : std_logic;
    signal mclk4_s      : std_logic;
    signal mclk8_s      : std_logic;
    signal mclk64_s     : std_logic;

    signal pwm_out_s    : std_logic;
    signal btifg_out_s  : std_logic;
    signal fir_ifg_s    : std_logic;
    signal fifo_empty_s : std_logic;

    -- signal btifg_int_req_s : std_logi

BEGIN
    rst_gen:
        if (MODELSIM = 0) generate
            rst_asy <= not rst_i;
        else generate
            rst_asy <= rst_i;
        end generate;

    synchronized_rst: process(mclk_s)
    begin
        if rising_edge(mclk_s) then
            rst_s <= rst_asy;
        end if;
    end process;


    mips_core_inst: entity work.mips_core
    generic map(
        WORD_GRANULARITY => WORD_GRANULARITY,
        -- MODELSIM => MODELSIM,
        DATA_BUS_WIDTH => DATA_BUS_WIDTH,
        ITCM_ADDR_WIDTH => ITCM_ADDR_WIDTH,
        DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH,
        PC_WIDTH => PC_WIDTH,
        NEXT_PC_WIDTH => NEXT_PC_WIDTH,
        -- FUNCT_WIDTH => FUNCT_WIDTH,
        DATA_WORDS_NUM => DATA_WORDS_NUM,
        CLK_CNT_WIDTH => CLK_CNT_WIDTH,
        INST_CNT_WIDTH => INST_CNT_WIDTH,
        DTCM_PATH => DTCM_PATH,
        ITCM_PATH => ITCM_PATH
    )
    port map(
        rst_i => rst_s,
        clk_i => mclk_s,
        bpaddr_i => bpaddr_i,
        int_req_i => int_req_s,
        -- interrupt_src_i =>  int_src_s,

        data_bus_o => data_bus_s,
        addr_bus_o => addr_bus_s,
        ctrl_bus_o => ctrl_bus_s,
        int_ack_o => int_ack_s,
        gie_o   => gie_s,

        strigger_o => strigger_o,

        -- Quartus
        pc_o => pc_o,
        alu_result_o => alu_result_o,
        read_data1_o => read_data1_o,
        read_data2_o => read_data2_o,
        write_data_o => write_data_o,
        instruction_top_o => instruction_top_o,
        Branch_ctrl_o => Branch_ctrl_o,
        Zero_o => Zero_o,
        MemWrite_ctrl_o => MemWrite_ctrl_o,
        RegWrite_ctrl_o => RegWrite_ctrl_o,
        mclk_cnt_o => mclk_cnt_o,
        inst_cnt_o => inst_cnt_o,
        flush_cnt => flush_cnt,
        hf_cnt => hf_cnt

    );

    pll_gen:
    if (MODELSIM = 0 and USE_ALT_CLK = false) generate
        MCLK: entity work.pll_50
        PORT MAP (
            inclk0  => clk_i,
            -- c0      => mclk_s,
            -- c1      => mclk2_s,
            c0      => mclk_s,         -- TODO: change later
            c1      => mclk2_s,
            c2      => mclk4_s,
            c3      => mclk8_s,
            c4      => mclk64_s
            );
    else generate
        mclk_s <= clk_i;
        mclk2_s <= clk_i;
        mclk4_s <= clk_i;
        mclk8_s <= clk_i;
        -- TODO: connect others
    end generate;

    interrupt_controller_unit_inst: entity work.interrupt_controller_unit
    generic map(
        ADDRESS_BUS_WIDTH => PC_WIDTH+2,
        DATA_BUS_WIDTH => DATA_BUS_WIDTH
    )
    port map(
        clk_i => mclk_s,
        rst_i => rst_s,
        inta_i => int_ack_s,
        interrupt_src_i => int_src_s,
        gie_i => gie_s,
        mem_write_c_i => ctrl_bus_s(0),
        mem_read_c_i => ctrl_bus_s(1),
        address_bus_i => addr_bus_s,
        data_bus_io => data_bus_s,
        int_req_o => int_req_s
    );

    timer_unit_inst: entity work.timer_unit
    port map(
        mclk_i        => mclk_s,
        mclk_i2_i     => mclk2_s,
        mclk_i4_i     => mclk4_s,
        mclk_i8_i     => mclk8_s,
        rst_i         => rst_s,
        mem_write_c_i => ctrl_bus_s(0),
        mem_read_c_i  => ctrl_bus_s(1),
        address_bus_i => addr_bus_s,
        data_bus_io   => data_bus_s,
        BTIFG         => btifg_out_s,
        PWMOUT        => pwm_out_s
    );

    gpio_unit_inst: entity work.gpio_unit
    port map(
        clk_i         => mclk_s,
        rst_i         => rst_s,
        mem_wr_c_in   => ctrl_bus_s(0),
        mem_rd_c_in   => ctrl_bus_s(1),
        address_bus_i => addr_bus_s,
        switches_in   => switches_i,
        data_bus_io   => data_bus_s,
        hex_out       => hex_arr_o,
        leds_out      => leds_o
    );

    fir_unit_inst: entity work.fir_unit
    generic map(
        DATA_BUS_WIDTH => DATA_BUS_WIDTH,
        INT_UNIT_ADDRESS_ARRAY => INT_UNIT_ADDRESS_ARRAY
    )
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        mem_write_c_i => ctrl_bus_s(0),
        mem_read_c_i => ctrl_bus_s(1),
        address_bus_i => addr_bus_s,
        data_bus_io => data_bus_s,
        fifo_clk_i => mclk_s,
        fir_clk_i => mclk64_s,
        fir_ifg_o => fir_ifg_s,
        fifo_empty_o => fifo_empty_s
    );

    int_req_o   <= int_req_s;
    int_ack_o   <= int_ack_s;
    data_bus_o <= data_bus_s;
    int_src_s(6 downto 4) <= keys_i;
    int_src_s(3) <= btifg_out_s;        -- BUG: connect others
    int_src_s(2 downto 0) <= "000";
    int_src_s(7) <= fifo_empty_s;
    int_src_s(8) <= fir_ifg_s;

    pwm_out <= pwm_out_s;
END ARCHITECTURE rtl;
