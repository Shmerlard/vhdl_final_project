library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_reg_arr is
    generic(
        w: integer := 24;
        m: integer := 8;
        q: integer := 8
    );
    port (
        clk_i   : in STD_LOGIC;
        rst_i   : in STD_LOGIC;
        x_i     : in STD_LOGIC_VECTOR(w-1 downto 0);
        coeff_i : in t_vec_array(0 to M-2)(q-1 downto 0);
        y_o     : out STD_LOGIC_VECTOR(w+q-1 downto 0)
    );
end entity fir_reg_arr;

ARCHITECTURE rtl OF fir_reg_arr IS
    signal x_i_arr_s    : t_vec_array(0 to M-1)(w-1 downto 0);
    signal s_i_arr_s    : t_vec_array(0 to M-1)(w-1 downto 0);
    signal y_reg_in_s   : std_logic_vector(w+q-1 downto 0);
    signal mult_s       : std_logic_vector(w+q-1 downto 0);
BEGIN
    x_i_arr_s(0) <= x_i;                    -- the signal array of the input and output of each register
    s_i_arr_s(0) <= (others => '0');        -- the signal array of the input and output of each sum
    mult_s <= std_logic_vector(signed(coeff_i(7)) * signed(x_i_arr_s(M-1)));
    y_reg_in_s <= std_logic_vector(unsigned(s_i_arr_s(M-1)) + unsigned(mult_s));


    -- Generate the first M-1 DFF
    gen_fir_reg : for i in 0 to M-2 generate
    begin
        fir_base_unit_inst: fir_base_unit
        generic map( w => w, q => q)
        port map
        (
            clk_i => clk_i,
            rst_i => rst_i,
            x_i => x_i_arr_s(i),
            sum_i => s_i_arr_s(i),
            coef_i => coeff_i(i),
            x_o => x_i_arr_s(i+1),
            sum_o => s_i_arr_s(i+1)
        );
    end generate;

    -- create the output DFF
    y_dff: entity work.nbit_dff
    generic map ( n => w+q )
    port map
    (
        clk => clk_i,
        rst => rst_i,
        en => '1',
        d_in => y_reg_in_s,
        q_out => y_o
    );
END ARCHITECTURE rtl;
