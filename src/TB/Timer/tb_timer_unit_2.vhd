LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.aux_package.all;

ENTITY tb_timer_unit_2 IS
END ENTITY;

ARCHITECTURE tb OF tb_timer_unit_2 is
    -- constant REG_SIZE: integer :=8;
    constant clk_period: time := 1 ns;
    constant address_bus_width: integer := 4;
    constant data_bus_width: integer := 8;

    constant timer_mem_map : t_addr_array := (
       0 => 16#C#,
       1 => 16#D#,
       2 => 16#E#,
       3 => 16#F#
    );

    signal clk: std_logic := '0';
    signal rst: std_logic := '1';

    signal mem_write_c_s : std_logic := '0';
    signal mem_read_c_s : std_logic := '0';

    signal address_bus_s: std_logic_vector(address_bus_width-1 downto 0);
    signal data_bus_s: std_logic_vector(data_bus_width-1 downto 0);

    signal btifg_s: std_logic;
    signal pwm_out_s: std_logic;
BEGIN

    clk_proc: process
    begin
        wait for clk_period / 2;
        clk <= not clk;
    end process;

    DUT: timer_unit
    generic map(
        REG_SIZE => 8,
        TIMER_UNIT_ADDRESS_ARRAY => timer_mem_map,
        ADDRESS_BUS_WIDTH => 4,
        DATA_BUS_WIDTH => 8)
    port map(
        mclk_i => clk,
        mclk_i2_i => clk,
        mclk_i4_i => clk,
        mclk_i8_i => clk,
        rst_i => rst,
        mem_write_c_i => mem_write_c_s,
        mem_read_c_i => mem_read_c_s,
        address_bus_i => address_bus_s,
        data_bus_io => data_bus_s,
        BTIFG => btifg_s,
        PWMOUT => pwm_out_s
    );


    sim_proc: process
    begin
        rst <= '1';
        wait for 2 ns;
        rst <= '0';

        address_bus_s <= x"F";
        data_bus_s <= x"FF";
        mem_write_c_s <= '1';

        wait for 3 ns;
        address_bus_s <= x"0";
        data_bus_s <= x"00";
        mem_write_c_s <= '0';

        wait for 2 ns;
        address_bus_s <= x"E";
        data_bus_s <= x"AA";
        mem_write_c_s <= '1';

        wait for 3 ns;
        address_bus_s <= x"0";
        data_bus_s <= (others => 'Z');
        mem_write_c_s <= '0';


        wait for 2 ns;
        address_bus_s <= x"F";
        -- data_bus_s <= x"AA";
        mem_read_c_s <= '1';
        wait for 2 ns;
        address_bus_s <= x"E";
        -- data_bus_s <= x"AA";
        mem_read_c_s <= '1';
        wait for 2 ns;
        mem_read_c_s <= '0';
        wait for 2 ns;
        address_bus_s <= x"D";
        data_bus_s <= x"CC";
        mem_write_c_s <= '1';


        wait;

    end process;



END ARCHITECTURE;

