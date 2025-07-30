library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity address_decoder is
    generic
    (
        -- DATA_BUS_WIDTH: integer := 32;
        ADDRESS_BUS_WIDTH: INTEGER := 12;

        -- ADDRESS_LOW: NATURAL := 16#800#;        -- NOTE: instead of x"800" which doesnt work
        -- ADDRESS_HIGH: NATURAL := 16#801#;
        -- ADRESS_COUNT: NATURAL := 
        ADDRESS_ARRAY : t_addr_array
    );
    port (
         mem_write_c_in : in std_logic;
         mem_read_c_in : in std_logic;
         address_bus_i : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);

         cs_mem_write_o : out std_logic_vector(ADDRESS_ARRAY'length - 1 downto 0);
         cs_mem_read_o  : out std_logic_vector(ADDRESS_ARRAY'length - 1 downto 0)
    );
end entity address_decoder;


ARCHITECTURE rtl OF address_decoder IS
    signal cs_s :std_logic_vector(ADDRESS_ARRAY'length - 1 downto 0);
BEGIN
    process (address_bus_i)
        variable addr_int : natural;
    begin
        addr_int := to_integer(unsigned(address_bus_i));
        for i in ADDRESS_ARRAY'range loop
            if (addr_int = ADDRESS_ARRAY(i)) then
                cs_s(i) <= '1';
            else
                cs_s(i) <= '0';
            end if;
        end loop;
    end process;

    cs_mem_write_o  <= cs_s when mem_write_c_in = '1' else (others => '0');
    cs_mem_read_o   <= cs_s when mem_read_c_in = '1' else (others => '0');
END ARCHITECTURE rtl;
