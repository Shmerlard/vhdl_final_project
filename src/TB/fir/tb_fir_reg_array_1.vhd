LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;


ENTITY tb_fir_reg_array_1 IS
END tb_fir_reg_array_1 ;


ARCHITECTURE struct OF tb_fir_reg_array_1 IS
    constant clk_period: time := 50 ns;
    constant w_l : integer := 8;
    constant m_l : integer := 5;
    constant q_l : integer := 8;



    signal tb_clk_i: std_logic;
    signal tb_rst_i: std_logic;

    signal x_input: std_logic_vector(w_l-1 downto 0);
    signal coeff_i : t_vec_array(0 to m_l-1)(q_l-1 downto 0)
        := ( x"01", x"02", x"03", x"04", x"05");
    -- signal i : t_vec_array(0 to m_l-1)(w_l-1 downto 0)
    --     := ( x"01", x"01", x"01", x"01", x"01");

    signal out_y:  std_logic_vector(w_l+q_l-1 downto 0);


BEGIN
    fir_reg_arr_inst: entity work.fir_reg_arr
    generic map(
        w => w_l,
        m => m_l,
        q => q_l
    )
    port map(
        fir_en_i => '1',
        clk_i => tb_clk_i,
        rst_i => tb_rst_i,
        x_i => x_input,
        coeff_i => coeff_i,
        y_o => out_y
    );

    
    gen_clk : 
    process
        begin
          tb_clk_i <= '1';
          wait for clk_period / 2;
          tb_clk_i <= not tb_clk_i;
          wait for clk_period / 2;
    end process;

    tb_rst_proc : process
    begin
        tb_rst_i <= '1';
        wait for 110 ns;
        tb_rst_i <= '0';
        wait;
    end process;

    x_input_proc : process
    begin
        x_input <= x"06";
        wait for clk_period;


        -- wait;
    end process;
END struct;
