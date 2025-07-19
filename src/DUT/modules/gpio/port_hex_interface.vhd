library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity port_hex_interface is
    port (
        data_i      : in STD_LOGIC_VECTOR(7 downto 0);
        mem_wr_i    : in STD_LOGIC;
        cs_i        : in STD_LOGIC;
        addr_lsb_i  : in STD_LOGIC;
        hex_o       : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity port_hex_interface;

ARCHITECTURE rtl OF port_hex_interface IS
    signal lsb_hex_out_s : STD_LOGIC_VECTOR(7 downto 0);
    signal msb_hex_out_s : STD_LOGIC_VECTOR(7 downto 0);
    signal lsb_hex_write_s : STD_LOGIC;
    signal msb_hex_write_s : STD_LOGIC;

BEGIN
    lsb_hex_latch: entity work.nbit_latch       -- TODO: need testing
    generic map( n => 7 )
    port map
    (   en => lsb_hex_write_s,
        d_in => data_i,
        q_out => lsb_hex_out_s);

    msb_hex_latch: entity work.nbit_latch
    generic map( n => 7 )
    port map
    (   en => msb_hex_write_s,
        d_in => data_i,
        q_out => msb_hex_out_s);

    lsb_hex_driver: entity work.hex_driver
    port map
    (   num_in => lsb_hex_out_s,
        en => '1',
        num_out => hex_o(3 downto 0));

    msb_hex_driver: entity work.hex_driver
    port map
    (   num_in => msb_hex_out_s,
        en => '1',
        num_out => hex_o(7 downto 4));

    lsb_hex_write_s <= cs_i and mem_wr_i and (not addr_lsb_i);
    msb_hex_write_s <= cs_i and mem_wr_i and addr_lsb_i;

END ARCHITECTURE rtl;
