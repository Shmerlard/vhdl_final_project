library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity port_sw_interface is
    generic(
        n: integer := 8
    );
    port (
        sw_i        : in STD_LOGIC_VECTOR(n-1 downto 0);
        mem_rd_i    : in STD_LOGIC;
        cs_i        : in STD_LOGIC;
        data_o      : out STD_LOGIC_VECTOR(n-1 downto 0)
    );
end entity port_sw_interface;

ARCHITECTURE rtl OF port_sw_interface IS
    signal read_en_s : STD_LOGIC;
BEGIN                                           -- TODO: start latch at 0?
    read_en_s <= mem_rd_i and cs_i;             -- TODO: need testing

    data_o <= sw_i when read_en_s = '1';        -- TODO: make it tri-state
END ARCHITECTURE rtl;
