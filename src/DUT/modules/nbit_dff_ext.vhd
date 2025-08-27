--=============================================================================
-- Title       : N-bit D Flip-Flop with Extended Features
-- File        : nbit_dff_ext.vhd
-- Author      : Elad Elmakias
-- Created     : 1/8/25
-- Description :
--   Parametrized D Flip-Flop with support for:
--     * Asynchronous and synchronous reset
--     * Selective per-bit reset via RST_BITS_ARRAY
--     * Selective per-bit input ignoring via IGN_BITS_ARRAY
--
--   - RST_BITS_ARRAY: specifies which bits are forcibly reset to '0'
--     on each clock cycle, regardless of reset inputs.
--   - IGN_BITS_ARRAY: specifies which bits use ign_d_in(i) instead of d_in(i)
--     when writing to the register.
--
--   Default behavior:
--     - If IGN_BITS_ARRAY is empty, d_in is used entirely.
--     - If RST_BITS_ARRAY is empty, no selective reset is performed.
--  --TODO: UPDATE
-- Dependencies : aux_package (defines t_bits_array and constants like EMP_BITS_ARR)
--=============================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;
-- use work.const_package.all;

entity nbit_dff_ext is
    generic (
        n              : integer := 8;  -- default size = 8 bits
        ASYNC_RST      : boolean := true;
        IGN_BITS       : std_logic_vector := (0 downto 0 => '0');
        RST_BITS       : std_logic_vector := (0 downto 0 => '0');
        RST_BITS_FALL  : std_logic_vector := (0 downto 0 => '0')
    );
    port(
        clk_i       : in  std_logic;
        rst_i       : in  std_logic := '0';
        wr_en_i     : in  std_logic;
        d_in        : in  std_logic_vector(n-1 downto 0);
        ign_d_in    : in  std_logic_vector(n-1 downto 0) := (others => '0');
        q_out       : out std_logic_vector(n-1 downto 0)
    );
end entity nbit_dff_ext;

architecture behavioral of nbit_dff_ext is
    signal q_reg : std_logic_vector(n-1 downto 0) := (others => '0');
    signal need_reset: std_logic;
    signal need_reset_fall: std_logic;

    signal ignore_bits_s : std_logic_vector(n-1 downto 0);
    signal reset_bits_s : std_logic_vector(n-1 downto 0);
    signal reset_bits_falling_s : std_logic_vector(n-1 downto 0);
begin
    ignore_bits_s <= (n-1 downto 0 => '0') when IGN_BITS'length = 1 else IGN_BITS;
    reset_bits_s  <= (n-1 downto 0 => '0') when RST_BITS'length = 1 else RST_BITS;
    reset_bits_falling_s  <= (n-1 downto 0 => '0') when RST_BITS_FALL'length = 1 else RST_BITS_FALL;

    need_reset <= '0' when (q_reg and reset_bits_s) = (n-1 downto 0 => '0')  else '1';
    need_reset_fall <= '0' when (q_reg and reset_bits_falling_s) = (n-1 downto 0 => '0')  else '1';

    asyn_proc : if ASYNC_RST generate
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            q_reg <= (others => '0');    -- async reset to 0
        elsif rising_edge(clk_i) then
            if wr_en_i = '1' then
                q_reg <= (ignore_bits_s and ign_d_in) or (not ignore_bits_s and d_in);
            else
                q_reg <= (ignore_bits_s and ign_d_in) or (not ignore_bits_s and q_reg);     -- OPTIMIZE: q_reg adds latch
                if need_reset = '1' then                                                    -- use variable
                    q_reg <= q_reg and not reset_bits_s;                                    -- OPTIMIZE: remove latch
                end if;
            end if;
        elsif falling_edge(clk_i) then
            if need_reset_fall = '1' then
                    q_reg <= q_reg and not reset_bits_falling_s;                                    -- OPTIMIZE: remove latch
            end if;
        end if;
    end process;
    end generate;

    syn_proc : if not ASYNC_RST generate
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                q_reg <= (others => '0');
            else
                if wr_en_i = '1' then
                    q_reg <= (ignore_bits_s and ign_d_in) or (not ignore_bits_s and d_in);
                else
                    q_reg <= (ignore_bits_s and ign_d_in) or (not ignore_bits_s and q_reg);
                    if need_reset = '1' then
                        q_reg <= q_reg and not reset_bits_s;
                    end if;
                end if;
            end if;
        end if;
    end process;
    end generate;

    q_out <= q_reg; -- connect internal register to output

end architecture behavioral;
