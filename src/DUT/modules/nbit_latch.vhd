library ieee;
use ieee.std_logic_1164.all;

entity n_bit_latch is
    generic ( n : integer := 8 ); -- bus width
    port (
        en   :      in  std_logic;                            -- Enable (transparency control)
        d_in :      in  std_logic_vector(n-1 downto 0);       -- Data input
        q_out:      out std_logic_vector(n-1 downto 0)       -- Latched output
    );
end n_bit_latch;

architecture behavioral of n_bit_latch is
begin
    process(en, d_in)
    begin
        if en = '1' then
            q_out <= d_in;  -- Transparent when enabled
        else
            q_out <= (others => '0');
        end if;
    end process;
end architecture behavioral;

