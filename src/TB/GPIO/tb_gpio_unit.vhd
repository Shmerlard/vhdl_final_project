
library ieee;USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.aux_package.all;

entity tb_gpio_unit is
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

        hex_out : out t_hex_array(0 to 5);
        leds_out: out std_logic_vector(7 downto 0);
        sw_in: in std_logic_vector(7 downto 0)
    );
end entity tb_gpio_unit;

ARCHITECTURE tb OF tb_gpio_unit IS
    signal clk: std_logic;
    signal rst: std_logic;

    signal data_bus: std_logic_vector(7 downto 0);
    signal addr_bus: std_logic_vector(3 downto 0);

    -- signal timer_unit_data_bus: std_logic_vector(7 downto 0);
    -- signal timer_unit_addr_bus: std_logic_vector(7 downto 0);

    signal mem_write_c_i_s: std_logic;
    signal mem_read_c_i_s: std_logic;

    constant gpio_address_array_debug: t_addr_array := (
        -- REG_ADDR(PORT_KEY)
        16#6#,
        16#7#,
        16#8#,
        16#9#,
        16#C#,
        16#D#,
        16#E#,
        16#F#
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

    gpio_unit_inst: entity work.gpio_unit
     generic map(
        ADDRESS_BUS_WIDTH => 4,
        DATA_BUS_WIDTH => 8,
        ADDRESS_ARRAY => gpio_address_array_debug
        -- LED_ARR_CNT => LED_ARR_CNT,
        -- HEX_ARR_CNT => HEX_ARR_CNT,
        -- SW_ARR_CNT => SW_ARR_CNT
    )
     port map(
        rst_i => rst_i,
        mem_wr_c_in => mem_write_c_i_s,
        mem_rd_c_in => mem_read_c_i_s,
        address_bus_i => addr_bus,
        switches_in => sw_in,
        data_bus_io => data_bus,
        hex_out => hex_out,
        leds_out => leds_out
    );
END ARCHITECTURE tb;
