library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity tb_address_decoder is
end entity;

architecture sim of tb_address_decoder is
    constant ADDRESS_BUS_WIDTH : integer := 12;
    constant ADDRESS_ARRAY : t_addr_array := (16#800#, 16#804#, 16#808#);

    signal mem_write_c_in : std_logic := '0';
    signal mem_read_c_in  : std_logic := '0';
    signal address_bus_i  : std_logic_vector(ADDRESS_BUS_WIDTH - 1 downto 0) := (others => '0');
    signal cs_mem_write_o : std_logic_vector(ADDRESS_ARRAY'length - 1 downto 0);
    signal cs_mem_read_o  : std_logic_vector(ADDRESS_ARRAY'length - 1 downto 0);
begin
    uut: entity work.address_decoder
        generic map (
            ADDRESS_BUS_WIDTH => ADDRESS_BUS_WIDTH,
            ADDRESS_ARRAY => ADDRESS_ARRAY
        )
        port map (
            mem_write_c_in => mem_write_c_in,
            mem_read_c_in  => mem_read_c_in,
            address_bus_i  => address_bus_i,
            cs_mem_write_o => cs_mem_write_o,
            cs_mem_read_o  => cs_mem_read_o
        );

    stim_proc: process
    begin
        for i in 0 to 3 loop
            address_bus_i <= std_logic_vector(to_unsigned(16#800# + i * 4, ADDRESS_BUS_WIDTH));
            mem_write_c_in <= '1';
            mem_read_c_in <= '0';
            wait for 10 ns;

            mem_write_c_in <= '0';
            mem_read_c_in <= '1';
            wait for 10 ns;
        end loop;

        wait;
    end process;
end architecture;
