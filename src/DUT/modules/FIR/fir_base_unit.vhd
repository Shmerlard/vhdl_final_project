library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_base_unit is
    generic(
        w: integer := 24;
        q: integer := 8
    );
    port (
        clk_i   : in STD_LOGIC;
        rst_i   : in STD_LOGIC;
        x_i     : in STD_LOGIC_VECTOR(w-1 downto 0);
        sum_i   : in STD_LOGIC_VECTOR(w+q-1 downto 0);
        coef_i  : in STD_LOGIC_VECTOR(q-1 downto 0);

        x_o     : out STD_LOGIC_VECTOR(w-1 downto 0);
        sum_o   : out STD_LOGIC_VECTOR(w+q-1 downto 0)
    );
end entity fir_base_unit;

ARCHITECTURE rtl OF fir_base_unit IS
    signal mult_s : STD_LOGIC_VECTOR(w+q-1 downto 0);
BEGIN
    mult_s <= std_logic_vector(unsigned(coef_i) * unsigned(x_i));
    sum_o <= std_logic_vector(unsigned(sum_i) + unsigned(mult_s));

    x_reg : nbit_dff
    generic map(n => w)
    port map (
        clk => clk_i,
        rst => rst_i,
        en => '1',
        d_in => x_i,
        q_out => x_o);

END ARCHITECTURE rtl;
