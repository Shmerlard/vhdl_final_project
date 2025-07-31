library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nbit_counter is
    generic (
        n : integer := 8  -- default size = 8 bits
    );
    port(
        clk_i    : in  std_logic;
        rst    : in  std_logic;     -- asynchronous reset
        en     : in  std_logic;     -- enable count
        equy   : in  std_logic;     -- synchronous reset

        d_in    : in std_logic_vector(n-1 downto 0);
        w_en_i  : in std_logic;
        q_out  : out std_logic_vector(n-1 downto 0)
    );
end entity nbit_counter;

architecture behavioral of nbit_counter is
    signal q_reg : std_logic_vector(n-1 downto 0) := (others => '0');
begin

    process(clk_i, rst)
    begin
        if rst = '1' then
            q_reg <= (others => '0');    -- async reset to 0
        elsif rising_edge(clk_i) then
            if w_en_i = '1' then
                q_reg <= d_in;
            else
                if en = '1' then
                    if equy = '0' then
                        q_reg <= q_reg + 1;
                    else -- equy = '1'
                        q_reg <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process;

    q_out <= q_reg; -- connect internal register to output

end architecture behavioral;

