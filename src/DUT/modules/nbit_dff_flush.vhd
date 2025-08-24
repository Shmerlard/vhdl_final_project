library ieee;
use ieee.std_logic_1164.all;

entity nbit_dff_flush is
    generic (
        n : integer := 8  -- default size = 8 bits
    );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;  -- asynchronous reset
        en     : in  std_logic;
        flush  : in  std_logic;
        d_in   : in  std_logic_vector(n-1 downto 0);
        q_out  : out std_logic_vector(n-1 downto 0)
    );
end entity nbit_dff_flush;

architecture behavioral of nbit_dff_flush is
    signal q_reg : std_logic_vector(n-1 downto 0) := (others => '0');
begin

    process(clk, rst)
    begin
        if rst = '1' then
            q_reg <= (others => '0');    -- async reset to 0
        elsif rising_edge(clk) then
            if flush = '1' then 
                q_reg <= (others => '0');
            elsif en = '1' then
                q_reg <= d_in;
            end if;
        end if;
    end process;

    q_out <= q_reg; -- connect internal register to output

end architecture behavioral;
