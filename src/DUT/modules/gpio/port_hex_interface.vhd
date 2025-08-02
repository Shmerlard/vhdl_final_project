library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity port_hex_interface is
    port (
        data_i      : in STD_LOGIC_VECTOR(3 downto 0);
        cs_i        : in STD_LOGIC_Vector(1 downto 0);
        hex_o       : out t_hex_array(0 to 1)
    );
end entity port_hex_interface;

ARCHITECTURE rtl OF port_hex_interface IS
    signal lsb_hex_out_s : STD_LOGIC_VECTOR(3 downto 0);
    signal msb_hex_out_s : STD_LOGIC_VECTOR(3 downto 0);
    signal lsb_hex_write_s : STD_LOGIC;
    signal msb_hex_write_s : STD_LOGIC;

-- BUG: check the adress space and if he meant that hex is one
    -- dispaly or 2
BEGIN
    lsb_hex_latch: entity work.nbit_latch
    generic map( n => 4 )
    port map
    (   en => lsb_hex_write_s,
        d_in => data_i(3 downto 0),
        q_out => lsb_hex_out_s);

    msb_hex_latch: entity work.nbit_latch
    generic map( n => 4 )
    port map
    (   en => msb_hex_write_s,
        d_in => data_i(3 downto 0),
        q_out => msb_hex_out_s);

    lsb_hex_driver: entity work.hex_driver
    port map
    (   num_in => lsb_hex_out_s,
        en => '1',
        num_out => hex_o(0));

    msb_hex_driver: entity work.hex_driver
    port map
    (   num_in => msb_hex_out_s,
        en => '1',
        num_out => hex_o(1));

    lsb_hex_write_s <= cs_i(0);
    msb_hex_write_s <= cs_i(1);

END ARCHITECTURE rtl;
