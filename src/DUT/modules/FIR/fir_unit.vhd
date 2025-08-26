library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.const_package.all;
use work.memory_map.all;

entity fir_unit is
    generic (
        ADDRESS_BUS_WIDTH: INTEGER := 12;
        DATA_BUS_WIDTH: INTEGER := 32;
        INT_UNIT_ADDRESS_ARRAY : t_addr_array := FIR_UNIT_ADDRESS_ARRAY
    );
    port 
    (
        clk_i               : in std_logic;
        rst_i               : in std_logic;

        mem_write_c_i       : in std_logic;             -- '1' when we want to write to the registers
        mem_read_c_i        : in std_logic;             -- '1' when we want to read from the registers

        address_bus_i       : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
        data_bus_io         : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        
        fifo_clk_i          : in std_logic;
        fir_clk_i           : in std_logic
    );
end entity fir_unit;


architecture rtl of fir_unit is
    signal cs_mem_write_s   : std_logic_vector(INT_UNIT_ADDRESS_ARRAY'length - 1 downto 0);
    signal cs_mem_read_s    : std_logic_vector(INT_UNIT_ADDRESS_ARRAY'length - 1 downto 0);

    signal fifo_wen_s : std_logic;
    signal fifo_ren_s : std_logic;
    signal fir_rst_s  : std_logic;
    signal fifo_rst_s  : std_logic;
    signal fir_ena_s : std_logic;
    signal fifo_full_s : std_logic;
    signal fifo_empty_s : std_logic;
    signal fir_ifg_s : std_logic;

    signal fir_out_reg_in_s : std_logic_vector(31 downto 0);
    signal fir_out_reg_out_s : std_logic_vector(31 downto 0);
    signal fir_in_s  : std_logic_vector(23 downto 0);
    signal fir_ctl_s : std_logic_vector(5 downto 0);
    signal coef_s    : t_vec_array(0 to 7)(7 downto 0);

    --
    -- signal ifg_in_s : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    -- signal int_req_s : std_logic;
    -- signal ifg_o_s  : std_logic_vector(6 downto 0);
    -- signal ifg_in_from_bus : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    -- signal ifg_in_from_core : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    --
    -- signal int_en_dff_d_out_s   : std_logic_vector(6 downto 0);
    -- signal int_en_dff_d_in_s    : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    -- signal type_in_s            : std_logic_vector(7 downto 0);
    -- signal type_out_s           : std_logic_vector(7 downto 0);
begin
    fir_unit_addr_decoder_inst: entity work.address_decoder
    generic map(
        ADDRESS_BUS_WIDTH => ADDRESS_BUS_WIDTH,
        ADDRESS_ARRAY => FIR_UNIT_ADDRESS_ARRAY 
    )
    port map
    (
        mem_write_c_in => mem_write_c_i,
        mem_read_c_in => mem_read_c_i,
        address_bus_i => address_bus_i,
        cs_mem_write_o => cs_mem_write_s,
        cs_mem_read_o => cs_mem_read_s
    );

    fir_core_inst: entity work.fir_core
    generic map(
        w => 24,
        m => 8,
        q => 8,
        k => 8,
        k_log => 3
    )
    port map(
        FIFOCLK => fifo_clk_i,
        FIFORST => fifo_rst_s,
        FIFOWEN => fifo_wen_s,
        FIFOREN => fifo_ren_s,
        FIRCLK => fir_clk_i,
        FIRRST => fir_rst_s,
        FIRENA => fir_ena_s,
        FIRIN => fir_in_s,
        COEF_I => coef_s,
        FIFOFULL => fifo_full_s,
        FIFOEMPTY => fifo_empty_s,
        FIRIFG => fir_ifg_s,
        FIROUT => fir_out_reg_in_s
    );

    fir_in_dff_inst: entity work.nbit_dff
    generic map( n => 24)
    port map(
        clk => clk_i,
        rst => rst_i,
        en => cs_mem_write_s(1),
        d_in => data_bus_io(23 downto 0),
        q_out => fir_in_s
    );
    fir_in_bidi_inst: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => x"00" & fir_in_s,
        en => cs_mem_read_s(1),
        -- Din => Din,
        IOpin => data_bus_io
    );

    fir_ctl_inst: entity work.nbit_dff
    generic map( n => 6 )
    port map(
        clk => clk_i,
        rst => rst_i,
        en => cs_mem_write_s(0),
        d_in => data_bus_io(5 downto 0),
        q_out => fir_ctl_s
    );
    fir_ctl_bidi_inst: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => x"000000" & fir_ctl_s,
        en => cs_mem_read_s(0),
        -- Din => Din,
        IOpin => data_bus_io
    );

    fir_out_ins : entity work.nbit_dff
    generic map( n => 32 )
    port map(
        clk => clk_i,
        rst => rst_i,
        en => fir_ena_s,
        d_in => fir_out_reg_in_s,
        q_out => fir_out_reg_out_s 
    );

    fir_out_bidi_inst: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => fir_out_reg_out_s,
        en => cs_mem_read_s(2),
        -- Din => Din,
        IOpin => data_bus_io
    );

    coeff_gen : for i in 0 to 3 generate
    begin
        coeff_reg_3_0_ins: entity work.nbit_dff
        generic map ( n => 8 )
        port map
        (
            clk => clk_i,
            rst => rst_i,
            en => cs_mem_write_s(3),
            d_in => data_bus_io(8*i + 7 downto 8*i),
            q_out => coef_s(i)
        );
        coeff_reg_7_4_ins: entity work.nbit_dff
        generic map ( n => 8 )
        port map
        (
            clk => clk_i,
            rst => rst_i,
            en => cs_mem_write_s(3),
            d_in => data_bus_io(8*i + 7 downto 8*i),
            q_out => coef_s(i+4)
        );
    end generate;

    coeff_reg_7_4_bidir_ins : entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => coef_s(7) & coef_s(6) & coef_s(5) & coef_s(4),
        en => cs_mem_read_s(4),
        -- Din => Din,
        IOpin => data_bus_io
    );
    coeff_reg_3_0_bidir_ins : entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => coef_s(3) & coef_s(2) & coef_s(1) & coef_s(0),
        en => cs_mem_read_s(3),
        -- Din => Din,
        IOpin => data_bus_io
    );
    
end architecture rtl;

