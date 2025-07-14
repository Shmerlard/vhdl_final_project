-- hex_driver.vhd
-- 
-- This module converts a 4-bit binary input (`num_in`) into a 7-segment display encoding (`num_out`).
-- The output is enabled by the `en` signal. When `en` is low, all segments are off.
-- The encoding matches a common-cathode 7-segment display.

library ieee;
use ieee.std_logic_1164.all;

entity hex_driver is
    port(
        num_in: IN std_logic_vector(3 downto 0);
        en:     IN std_logic;
        num_out:OUT std_logic_vector(6 downto 0)
        );
end entity;

ARCHITECTURE rtl OF hex_driver IS
    signal decoded: STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
BEGIN
    with num_in select decoded <=
        "0111111" when "0000",
        "0000110" when "0001",
        "1011011" when "0010",
        "1001111" when "0011",
        "1100110" when "0100",
        "1101101" when "0101",
        "1111101" when "0110",
        "0000111" when "0111",
        "1111111" when "1000",
        "1101111" when "1001",
        "1110111" when "1010",
        "1111100" when "1011",
        "0111001" when "1100",
        "1011110" when "1101",
        "1111001" when "1110",
        "1110001" when others;

    with en select num_out <=
        "0000000" when '0',
        not decoded when others;
END ARCHITECTURE rtl;
