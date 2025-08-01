LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.memory_map.all;

entity timer_unit is
    generic
    (           -- NOTE: maybe REG_SIZE is not needed
        REG_SIZE: integer := 32;                    -- size of btctl, btccr0, btccr1
        TIMER_UNIT_ADDRESS_ARRAY: t_addr_array;     -- the array of addresses for decoding
        ADDRESS_BUS_WIDTH: INTEGER := 12;           -- the width of the address bus
        DATA_BUS_WIDTH: INTEGER := 32;              -- width of the data bus

        BTCTL_RESET_BITS_MASK : std_logic_vector(7 downto 0) := x"04"
    );
    port (
        mclk_i          : in std_logic;
        rst_i           : in std_logic;
        mem_write_c_i   : in std_logic;             -- '1' when we want to write to the registers
        mem_read_c_i    : in std_logic;             -- '1' when we want to read from the registers

        address_bus_i   : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
        data_bus_io     : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);

        BTIFG           : out std_logic;
        PWMOUT          : out std_logic;

        debug_btctl_o  : out std_logic_vector(7 downto 0);
        debug_btcnt_o  : out std_logic_vector(REG_SIZE-1 downto 0);
        debug_btccr0_o  : out std_logic_vector(REG_SIZE-1 downto 0);
        debug_btccr1_o  : out std_logic_vector(REG_SIZE-1 downto 0)
    );
end entity timer_unit;

ARCHITECTURE rtl OF timer_unit IS
    signal mclk_i2_s : std_logic;
    signal mclk_i4_s : std_logic;
    signal mclk_i8_s : std_logic;
    signal clk_div_counter : std_logic_vector(2 downto 0) := (others => '0');

    -- chip select signals for read/write for each register
    signal cs_mem_write_s : std_logic_vector(TIMER_UNIT_ADDRESS_ARRAY'length - 1 downto 0);
    signal cs_mem_read_s : std_logic_vector(TIMER_UNIT_ADDRESS_ARRAY'length - 1 downto 0);

    signal btctl_o_s: std_logic_vector(7 downto 0);             -- the state of BTCTL reg
    signal btcnt_o_s: std_logic_vector(REG_SIZE-1 downto 0);    -- the state of BTCNT reg
    signal btccr0_o_s: std_logic_vector(REG_SIZE-1 downto 0);   -- the state of BTCCR0 reg
    signal btccr1_o_s: std_logic_vector(REG_SIZE-1 downto 0);   -- the state of BTCCR1 reg

    signal btctl_d_in_s: std_logic_vector(7 downto 0);              -- the data input to btctl
    signal btcnt_d_in_s: std_logic_vector(REG_SIZE-1 downto 0);     -- the data input to btcnt
    signal btccr0_d_in_s: std_logic_vector(REG_SIZE-1 downto 0);    -- the data input to btccr0
    signal btccr1_d_in_s: std_logic_vector(REG_SIZE-1 downto 0);    -- the data input to btccr1
BEGIN
    -- Clock handling
    process(mclk_i)
    begin
        if rising_edge(mclk_i) then
            clk_div_counter <= std_logic_vector(unsigned(clk_div_counter) + 1);
            mclk_i2_s <= clk_div_counter(0);
            mclk_i4_s <= clk_div_counter(1);
            mclk_i8_s <= clk_div_counter(2);

            -- auto clear btclr bit
            -- if btctl_o_s(BTCTL_BITS(BTCLR)) = '1' then
            --     btctl_o_s(BTCTL_BITS(BTCLR)) <= '0';
            -- end if;
        end if;
    end process;

    timer_core_inst: entity work.timer_core
    generic map( n => REG_SIZE )
    port map(
        mclk_i => mclk_i,
        mclk_i2 => mclk_i2_s,
        mclk_i4 => mclk_i4_s,
        mclk_i8 => mclk_i8_s,
        rst_i => rst_i,
        BTCLR => btctl_o_s(BTCTL_BITS(BTCLR)),      -- NOTE: btclr is not reset automaticaly
        BTHOLD =>  btctl_o_s(BTCTL_BITS(BTHOLD)),
        BTSSEL =>  btctl_o_s(BTCTL_BITS(BTSSEL_1) downto BTCTL_BITS(BTSSEL_0)),
        BTOUTMD =>  btctl_o_s(BTCTL_BITS(BTOUTMD)),
        BTOUTEN =>  btctl_o_s(BTCTL_BITS(BTOUTEN)),
        BTCCR0 => btccr0_o_s,
        BTCCR1 => btccr1_o_s,
        BTIP =>  btctl_o_s(BTCTL_BITS(BTIP_1) downto BTCTL_BITS(BTIP_0)),
        BTIFG => BTIFG,
        PWMOUT => PWMOUT,
        d_bus_i => btcnt_d_in_s,
        d_bus_o => btcnt_o_s,
        btcnt_wr_en => cs_mem_write_s(1)
    );

    timer_address_decoder: entity work.address_decoder
    generic map(
        ADDRESS_BUS_WIDTH => ADDRESS_BUS_WIDTH,
        ADDRESS_ARRAY => TIMER_UNIT_ADDRESS_ARRAY
    )
    port map
    (
        mem_write_c_in => mem_write_c_i,
        mem_read_c_in => mem_read_c_i,
        address_bus_i => address_bus_i,
        cs_mem_write_o => cs_mem_write_s,
        cs_mem_read_o => cs_mem_read_s
    );

    -- BTCTL_ins: entity work.nbit_dff
    -- generic map( n => 8 )
    -- port map
    -- (
    --     clk => mclk_i,
    --     rst => rst_i,
    --     en =>   cs_mem_write_s(0),
    --     d_in => btctl_d_in_s,
    --     q_out => btctl_o_s
    -- );
    BTCTL_ins: entity work.nbit_dff_ext
    generic map( n => 8,
                 RST_BITS => BTCTL_RESET_BITS_MASK)
    port map
    (
        clk_i   => mclk_i,
        rst_i   => rst_i,
        wr_en_i => cs_mem_write_s(0),
        d_in    => btctl_d_in_s,
        q_out   => btctl_o_s
    );
    BTCTL_bidir_ins: entity work.nbit_bidir
    generic map( width => 8 )
    port map
    (
        Dout => btctl_o_s,
        en => cs_mem_read_s(0),
        Din => btctl_d_in_s,
        IOpin => data_bus_io(7 downto 0) -- take only the 8 MSB's of the data bus
    );

    BTCNT_bidir_ins: entity work.nbit_bidir
    generic map( width => REG_SIZE )
    port map(
                Dout => btcnt_o_s,
                en => cs_mem_read_s(1),
                Din => btcnt_d_in_s,
                IOpin => data_bus_io
    );

    BTCCR0_ins: entity work.nbit_dff
    generic map( n => REG_SIZE )
    port map
    (
        clk => mclk_i,
        rst => rst_i,
        en =>   cs_mem_write_s(2),
        d_in => btccr0_d_in_s,
        q_out => btccr0_o_s
    );
    BTCCR0_bidir_ins: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
                Dout => btccr0_o_s,
                en => cs_mem_read_s(2),
                Din => btccr0_d_in_s,
                IOpin => data_bus_io
    );

    BTCCR1_ins: entity work.nbit_dff
    generic map( n => REG_SIZE )
    port map
    (
        clk => mclk_i,
        rst => rst_i,
        en =>   cs_mem_write_s(3),
        d_in => btccr1_d_in_s,
        q_out => btccr1_o_s
    );
    BTCCR1_bidir_ins: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
                Dout => btccr1_o_s,
                en => cs_mem_read_s(3),
                Din => btccr1_d_in_s,
                IOpin => data_bus_io
    );

    ------ DEBUG ------
    debug_btctl_o  <= btctl_o_s;
    debug_btcnt_o  <= btcnt_o_s;
    debug_btccr0_o <= btccr0_o_s;
    debug_btccr1_o <= btccr1_o_s;

END ARCHITECTURE rtl;
