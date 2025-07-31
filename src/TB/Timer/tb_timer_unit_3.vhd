library ieee;USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.aux_package.all;

entity tb_timer_unit_3 is
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;

        data_switches : in std_logic_vector(7 downto 0);
        data_switches_en: in std_logic;
        addr_switches : in std_logic_vector(3 downto 0);
        -- addr_switches_en: in std_logic;

        mem_write_c_i : in std_logic;
        mem_read_c_i : in std_logic;

        data_bus_out : out std_logic_vector(7 downto 0);
        addr_bus_out : out std_logic_vector(3 downto 0);

        hex_out : out t_hex_array(0 to 7);

        bt_ifg : out std_logic;
        pwm_o : out std_logic
    );
end entity tb_timer_unit_3;

ARCHITECTURE tb OF tb_timer_unit_3 IS
    signal clk: std_logic;
    signal rst: std_logic;

    signal data_bus: std_logic_vector(7 downto 0);
    signal addr_bus: std_logic_vector(3 downto 0);

    -- signal timer_unit_data_bus: std_logic_vector(7 downto 0);
    -- signal timer_unit_addr_bus: std_logic_vector(7 downto 0);

    signal mem_write_c_i_s: std_logic;
    signal mem_read_c_i_s: std_logic;

    signal btctl_o_s: std_logic_vector(7 downto 0);             -- the state of BTCTL reg
    signal btcnt_o_s: std_logic_vector(7 downto 0);    -- the state of BTCNT reg
    signal btccr0_o_s: std_logic_vector(7 downto 0);   -- the state of BTCCR0 reg
    signal btccr1_o_s: std_logic_vector(7 downto 0);   -- the state of BTCCR1 reg

    constant timer_mem_map : t_addr_array := (
       0 => 16#C#,
       1 => 16#D#,
       2 => 16#E#,
       3 => 16#F#
    );
BEGIN
    clk <= not clk_i;
    rst <= not rst_i;

    addr_bus_out <= addr_bus;
    data_bus_out <= data_bus;

    addr_bus <= addr_switches;

    mem_read_c_i_s <= '1' when data_switches_en = '0' and mem_read_c_i = '1'
                      else '0';
    mem_write_c_i_s <= mem_write_c_i;

    data_bus <= data_switches when data_switches_en = '1' else
                (others => 'Z');


    timer_unit_ins: entity work.timer_unit
    generic map(
        REG_SIZE => 8,
        TIMER_UNIT_ADDRESS_ARRAY => timer_mem_map,
        ADDRESS_BUS_WIDTH => 4,
        DATA_BUS_WIDTH => 8
    )
    port map(
        mclk_i => clk,
        rst_i => rst,
        mem_write_c_i => mem_write_c_i_s,
        mem_read_c_i => mem_read_c_i_s,
        address_bus_i => addr_bus,
        data_bus_io => data_bus,
        BTIFG => bt_ifg,
        PWMOUT => pwm_o,
        debug_btctl_o => btctl_o_s,
        debug_btcnt_o => btcnt_o_s,
        debug_btccr0_o => btccr0_o_s,
        debug_btccr1_o => btccr1_o_s
    );

    btctl_hex_driver_l: entity work.hex_driver
    port map(
        num_in => btctl_o_s(3 downto 0),
        en => '1',
        num_out => hex_out(0)
    );
    btctl_hex_driver_h: entity work.hex_driver
    port map(
        num_in => btctl_o_s(7 downto 4),
        en => '1',
        num_out => hex_out(1)
    );
    btcnt_hex_driver_l: entity work.hex_driver
    port map(
        num_in => btcnt_o_s(3 downto 0),
        en => '1',
        num_out => hex_out(2)
    );
    btcnt_hex_driver_h: entity work.hex_driver
    port map(
        num_in => btcnt_o_s(7 downto 4),
        en => '1',
        num_out => hex_out(3)
    );
    btccr0_hex_driver_l: entity work.hex_driver
    port map(
        num_in => btccr0_o_s(3 downto 0),
        en => '1',
        num_out => hex_out(4)
    );
    btccr0_hex_driver_h: entity work.hex_driver
    port map(
        num_in => btccr0_o_s(7 downto 4),
        en => '1',
        num_out => hex_out(5)
    );
    btccr1_hex_driver_l: entity work.hex_driver
    port map(
        num_in => btccr1_o_s(3 downto 0),
        en => '1',
        num_out => hex_out(6)
    );
    btccr1_hex_driver_h: entity work.hex_driver
    port map(
        num_in => btccr1_o_s(7 downto 4),
        en => '1',
        num_out => hex_out(7)
    );
END ARCHITECTURE tb;
