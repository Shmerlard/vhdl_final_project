library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity port_led_interface is
    port (
        rst_i       : in STD_LOGIC;
        clk_i       : in STD_LOGIC;
        data_i      : in STD_LOGIC_VECTOR(7 downto 0);
        cs_i        : in STD_LOGIC;
        led_o       : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity port_led_interface;

ARCHITECTURE rtl OF port_led_interface IS
BEGIN
    -- hex_latch: entity work.nbit_latch       -- TODO: need testing
    -- generic map( n => 8 )                   -- TODO: start latch at 0?
    -- port map
    -- (
    --     en => cs_i,
    --     d_in => data_i,
    --     q_out => led_o
    -- );
    led_r: entity work.nbit_dff       -- TODO: need testing
    generic map( n => 8 )                   -- TODO: start latch at 0?
    port map
    (
        rst => rst_i,
        clk => clk_i,
        en => cs_i,
        d_in => data_i,
        q_out => led_o
    );

END ARCHITECTURE rtl;
