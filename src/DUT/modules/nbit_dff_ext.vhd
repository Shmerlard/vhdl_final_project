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
--
-- Dependencies : aux_package (defines t_bits_array and constants like EMP_BITS_ARR)
--=============================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;
-- use work.const_package.all;

entity nbit_dff_ext is
    generic (
        n              : integer := 8;  -- default size = 8 bits
        IGN_BITS_ARRAY : t_bits_array := EMP_BITS_ARR;
        RST_BITS_ARRAY : t_bits_array := EMP_BITS_ARR
    );
    port(
        clk_i       : in  std_logic;
        asc_rst_i   : in  std_logic := '0';  -- asynchronous reset
        syn_rst_i   : in  std_logic := '0';
        wr_en_i     : in  std_logic;
        d_in        : in  std_logic_vector(n-1 downto 0);
        ign_d_in    : in  std_logic_vector(n-1 downto 0) := (others => '0');
        q_out       : out std_logic_vector(n-1 downto 0)
    );
end entity nbit_dff_ext;

architecture behavioral of nbit_dff_ext is
    signal q_reg : std_logic_vector(n-1 downto 0) := (others => '0');

    function is_in_array(val: natural; arr : t_bits_array ) return boolean is
    begin
        for i in  arr'range loop
            if arr(i) = val then return true;
            end if;
        end loop;
        return false;
    end function;
begin

    process(clk_i, asc_rst_i)
    begin
        if asc_rst_i = '1' then
            q_reg <= (others => '0');    -- async reset to 0
        elsif rising_edge(clk_i) then
            if syn_rst_i = '1' then         -- PERF: currently mux is redundent
                q_reg <= (others => '0');
            else
                if RST_BITS_ARRAY(0) /= -1 then
                    for i in 0 to n-1 loop
                        if is_in_array(i, RST_BITS_ARRAY) then
                            if (q_reg(i) = '1') then
                                q_reg(i) <= '0';
                            end if;
                        end if;
                    end loop;
                end if;

                if wr_en_i = '1' then
                    if IGN_BITS_ARRAY(0) /= -1 then
                        for i in 0 to n-1 loop
                            if is_in_array(i, IGN_BITS_ARRAY) then
                                q_reg(i) <= ign_d_in(i);
                            else
                                q_reg(i) <= d_in(i);
                            end if;
                        end loop;
                    else
                        q_reg <= d_in;
                    end if;
                end if;
            end if;
        end if;
    end process;

    q_out <= q_reg; -- connect internal register to output

end architecture behavioral;
