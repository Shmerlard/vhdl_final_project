LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.aux_package.all;

ENTITY tb_interrupt_controller_core_1 IS
END ENTITY;

ARCHITECTURE tb OF tb_interrupt_controller_core_1 is
    -- constant REG_SIZE: integer :=8;
    constant clk_period: time := 1 ns;
    constant address_bus_width: integer := 4;
    constant data_bus_width: integer := 8;

    -- constant int_mem_map : t_addr_array := ( 0 => 16#D#,
    --    1 => 16#E#,
    --    2 => 16#F#
    -- );

    signal clk: std_logic := '0';
    signal rst: std_logic := '1';

    signal gie_i: std_logic := '1';
    signal inta_i_b : std_logic := '1';
    signal interrupt_src_i : std_logic_vector(8 downto 0) := "000000000";

    -- signal eint_i : std_logic_vector(6 downto 0) := "0000000";
    signal eint_i : std_logic_vector(6 downto 0) := "1111111";

    signal ifg_o : std_logic_vector(6 downto 0);
    signal type_reg_d_in_o : std_logic_vector(7 downto 0);
    signal int_req_o : std_logic;


    -- signal address_bus_s: std_logic_vector(address_bus_width-1 downto 0) := "0000";
    -- signal data_bus_s: std_logic_vector(data_bus_width-1 downto 0) := "00000000";

BEGIN

    clk_proc: process
    begin
        wait for clk_period / 2;
        while true loop
            wait for clk_period / 2;
            clk <= not clk;
        end loop;
    end process;

    rst_proc : process
    begin
        rst <= '1';
        wait for 1.75 ns;
        rst <= '0';

        wait;
    end process;

    sim_proc : process
    begin
        wait for 2.2 ns;
        interrupt_src_i(6) <= '1';

        wait for 0.8 ns;
        inta_i_b <= '0';
        ------------------

        wait for 1 ns;
        gie_i <= '0';
        ------------------

        wait for 0.75 ns;
        interrupt_src_i(5) <= '1';
        wait for 0.05 ns;
        interrupt_src_i(6) <= '0';
        wait for 0.2 ns;

        ---------------------

        wait;
        -- logic here
    end process;

    int_ctrl_core_inst: entity work.interrupt_controller_core
    port map(
        clk_i => clk,
        rst_i => rst,
        inta_i_b => inta_i_b,
        interrupt_src_i => interrupt_src_i,
        eint_i => eint_i,
        gie_i => gie_i,
        ifg_o => ifg_o,
        type_reg_d_in_o => type_reg_d_in_o,
        int_req_o => int_req_o
    );



END ARCHITECTURE;

