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
        clk_i     : in std_logic;
        rst_i     : in std_logic;
        fir_en_i  : in std_logic;           -- TODO: check
        x_i       : in std_logic_vector(w-1 downto 0);
        coeff_i   : in t_vec_array(0 to M-1)(q-1 downto 0);

        -- fir_ifg_o : out std_logic;          -- TODO: implement
        y_o       : out STD_LOGIC_VECTOR(w+q-1 downto 0)

    );
end entity fir_reg_arr;

ARCHITECTURE rtl OF fir_reg_arr IS
    signal x_i_arr_s    : t_vec_array(0 to M-1)(w-1 downto 0);
    signal s_i_arr_s    : t_vec_array(0 to M-1)(w+q-1 downto 0);
    signal mul_arr_s    : t_vec_array(0 to M-1)(w+q-1 downto 0);
    signal y_reg_out_s  : std_logic_vector(w+q-1 downto 0);
BEGIN
    x_i_arr_s(0) <= x_i;
    mul_arr_s(0) <= std_logic_vector(   signed(coeff_i(0)) * signed(x_i_arr_s(0))  );
    s_i_arr_s(0) <= mul_arr_s(0);

    fir_reg_gen : for i in 1 to M-1 generate
    begin
        x_i_dff_ins: entity work.nbit_dff
        generic map( n => w)
        port map(
            clk => clk_i,
            rst => rst_i,
            en => fir_en_i,             -- TODO: check if connected correctly
            d_in => x_i_arr_s(i-1),
            q_out => x_i_arr_s(i)
        );

        mul_arr_s(i) <= std_logic_vector(  signed(coeff_i(i))     * signed(x_i_arr_s(i))    );
        s_i_arr_s(i) <= std_logic_vector(  signed(s_i_arr_s(i-1)) + signed(mul_arr_s(i))    );

    end generate;

    -- create the output DFF
    y_dff_ins: entity work.nbit_dff
    generic map( n => w+q)
    port map(
        clk => clk_i,
        rst => rst_i,
        en => fir_en_i,
        d_in => s_i_arr_s(M-1),
        q_out => y_reg_out_s
    );

    y_o <= y_reg_out_s;

END ARCHITECTURE rtl;
