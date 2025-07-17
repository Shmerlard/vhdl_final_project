library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;

entity nbit_sr is
    generic
    (
        n: integer := 1;            -- size of data
        k: integer := 8             -- number of dff
    );
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;

        d_in : in std_logic_vector(n-1 downto 0);
        q_out: out std_logic_vector(n-1 downto 0)
    );
end entity nbit_sr;

architecture rtl of nbit_sr is
    signal d_arr_s : t_vec_array(0 to k)(n-1 downto 0);
begin
    d_arr_s(0) <= d_in;
    q_out <= d_arr_s(k-1);

    n_bit_reg_gen : for i in 0 to k-1 generate
    begin
        nbit_dff_inst: nbit_dff
        generic map ( n => n )
        port map
        (
            clk => clk_i,
            rst => rst_i,
            en => '1',
            d_in => d_arr_s(i),
            q_out => d_arr_s(i+1)
        );
    end generate;
end architecture rtl;
