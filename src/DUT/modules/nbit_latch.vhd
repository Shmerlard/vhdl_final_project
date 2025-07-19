library ieee;
use ieee.std_logic_1164.all;

entity nbit_latch is
    generic ( n : integer := 8 ); -- bus width
    port (
        en   :      in  std_logic;                            -- Enable (transparency control)
        d_in :      in  std_logic_vector(n-1 downto 0);       -- Data input
        q_out:      out std_logic_vector(n-1 downto 0)       -- Latched output
    );
end nbit_latch;

architecture behavioral of nbit_latch is
    signal latch_o_s : std_logic_vector(n-1 downto 0) := (others => '0');
begin
    q_out <= latch_o_s;
    process(en, d_in)
    begin
        if en = '1' then
            latch_o_s <= d_in;
        end if;

    end process;
end architecture behavioral;

