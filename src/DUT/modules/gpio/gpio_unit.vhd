library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
use work.memory_map.all;

entity gpio_unit is
    generic(
        ADDRESS_BUS_WIDTH: integer := 12;
        DATA_BUS_WIDTH: integer := 32;
        ADDRESS_ARRAY : t_addr_array := GPIO_UNIT_ADDRESS_ARRAY;

        LED_ARR_CNT: natural := 1;
        HEX_ARR_CNT: natural := 3;
        SW_ARR_CNT: natural := 1
    );
    port (
        -- clk_i : in std_logic;
        rst_i : in std_logic;
        mem_wr_c_in : in std_logic;
        mem_rd_c_in : in std_logic;
        address_bus_i : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
        switches_in : in std_logic_vector;

        data_bus_io : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        hex_out: out t_hex_array;
        leds_out: out std_logic_vector

    );
end entity gpio_unit;

-- BUG: set initial conditions
architecture rtl of gpio_unit is
    signal gpio_wr_cs_s : std_logic_vector(ADDRESS_ARRAY'length-1 downto 0);
    signal gpio_rd_cs_s : std_logic_vector(ADDRESS_ARRAY'length-1 downto 0);

    constant first_hex_idx: natural := LED_ARR_CNT;
    constant first_sw_idx: natural := first_hex_idx + HEX_ARR_CNT*2;
begin
    gpio_addr_decoder_inst: entity work.address_decoder
    generic map(
        ADDRESS_BUS_WIDTH => ADDRESS_BUS_WIDTH,
        ADDRESS_ARRAY => ADDRESS_ARRAY
    )
    port map(
        mem_write_c_in => mem_wr_c_in,
        mem_read_c_in => mem_rd_c_in,
        address_bus_i => address_bus_i,
        cs_mem_write_o => gpio_wr_cs_s,
        cs_mem_read_o => gpio_rd_cs_s
    );

    gen_leds: if LED_ARR_CNT > 0 generate
        gen_leds_loop: for i in 0 to LED_ARR_CNT-1 generate
            led_inter_ins: entity work.port_led_interface
            port map(
                data_i => data_bus_io(7 downto 0),
                cs_i => gpio_wr_cs_s(i),
                led_o => leds_out(i*8+7 downto i*8));
            end generate;
    end generate;

    gen_hex: if HEX_ARR_CNT > 0 generate
        gen_hex_loop: for i in 0 to HEX_ARR_CNT-1 generate
            hex_inter_ins: entity work.port_hex_interface
            port map(
                data_i => data_bus_io(3 downto 0),
                cs_i => gpio_wr_cs_s(first_hex_idx+2*i +1 downto first_hex_idx+2*i),
                hex_o => hex_out(2*i to 2*i+1)
            );
        end generate;
    end generate;

    gen_sw: if SW_ARR_CNT > 0 generate
        gen_sw_loop: for i in 0 to SW_ARR_CNT-1 generate
            sw_inter_ins: entity work.port_sw_interface
            generic map( n => 8)
            port map(
                        sw_i => switches_in(i*8+7 downto 0),
                        cs_i => gpio_rd_cs_s(first_sw_idx+i),
                        data_o => data_bus_io(7 downto 0)
                    );
            end generate;
    end generate;

end architecture rtl;
