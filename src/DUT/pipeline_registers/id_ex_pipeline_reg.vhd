LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

entity id_ex_pipeline_reg is
    generic(
        controls_count_JJJJ : natural := 18;
            DATA_BUS_WIDTH : integer    := 32;
            NEXT_PC_WIDTH : integer     := 8

    );
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;
        flush_i : in std_logic;

        controls_i : in std_logic_vector;
        controls_o : out std_logic_vector;

        pc_i : in std_logic_vector;
        pc_o : out std_logic_vector;

        pc_plus4_i : in std_logic_vector;
        pc_plus4_o : out std_logic_vector;

        -- shamt_i : in std_logic_vector;
        -- shamt_o : out std_logic_vector;

        instruction_i : in std_logic_vector;
        instruction_o : out std_logic_vector;

        rd1_i : in std_logic_vector;
        rd1_o : out std_logic_vector;

        rd2_i : in std_logic_vector;
        rd2_o : out std_logic_vector;

        zero_ext_i : in std_logic_vector;
        zero_ext_o : out std_logic_vector;

        sign_ext_i : in std_logic_vector;
        sign_ext_o : out std_logic_vector;

        jump_controls_i : in std_logic;
        jump_controls_o : out std_logic
    );
end entity id_ex_pipeline_reg;

ARCHITECTURE rtl OF id_ex_pipeline_reg IS
BEGIN

    ID_EX_PLR_controls : entity work.nbit_dff_flush
    generic map ( n => controls_count_JJJJ )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => controls_i,
        q_out  => controls_o
    );

    ID_EX_PLR_pc_inst : entity work.nbit_dff_flush
    generic map ( n => NEXT_PC_WIDTH)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => pc_i,
        q_out  => pc_o
    );

    ID_EX_PLR_pc_plus4 : entity work.nbit_dff_flush
    generic map ( n => NEXT_PC_WIDTH)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => pc_plus4_i,
        q_out  => pc_plus4_o
    );

    -- ID_EX_PLR_shamt : entity work.nbit_dff_flush
    -- generic map ( n => shamt_count)
    -- port map (
    --     clk    => clk_i,
    --     rst    => rst_i,
    --     flush => flush_i,
    --     en     => '1',
    --     d_in   => shamt_i,
    --     q_out  => shamt_o
    -- );

    ID_EX_PLR_instruction : entity work.nbit_dff_flush
    generic map ( n => DATA_BUS_WIDTH)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => instruction_i,
        q_out  => instruction_o
    );

    ID_EX_PLR_rd1 : entity work.nbit_dff_flush
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => rd1_i,
        q_out  => rd1_o
    );

    ID_EX_PLR_rd2 : entity work.nbit_dff_flush
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => rd2_i,
        q_out  => rd2_o
    );

    ID_EX_PLR_zero_ext : entity work.nbit_dff_flush
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => zero_ext_i,
        q_out  => zero_ext_o
    );

    ID_EX_PLR_sign_ext : entity work.nbit_dff_flush
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => flush_i,
        en     => '1',
        d_in   => sign_ext_i,
        q_out  => sign_ext_o
    );

    ID_EX_PLR_jump_control : entity work.nbit_dff_flush
    generic map ( n => 1 )
    port map (
        clk       => clk_i,
        rst       => rst_i,
        flush     => flush_i,
        en        => '1',
        d_in(0)   => jump_controls_i,
        q_out(0)  => jump_controls_o
    );
END ARCHITECTURE rtl;
