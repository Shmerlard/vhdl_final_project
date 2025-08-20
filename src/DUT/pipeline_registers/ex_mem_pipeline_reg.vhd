
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

entity ex_mem_pipeline_reg is
    generic(
        controls_count_JJJJ : natural := 8;
        DATA_BUS_WIDTH : integer    := 32;
        NEXT_PC_WIDTH : integer     := 8

    );
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;

        controls_i : in std_logic_vector;
        controls_o : out std_logic_vector;

        pc_plus4_i : in std_logic_vector;
        pc_plus4_o : out std_logic_vector;

        instruction_i : in std_logic_vector;
        instruction_o : out std_logic_vector;


        rd1_i : in std_logic_vector;
        rd1_o : out std_logic_vector;

        rd2_i : in std_logic_vector;
        rd2_o : out std_logic_vector;

        alu_res_i : in std_logic_vector;
        alu_res_o : out std_logic_vector;

        slt_res_i : in std_logic_vector;
        slt_res_o : out std_logic_vector;

        lui_res_i : in std_logic_vector;
        lui_res_o : out std_logic_vector
    );
end entity ex_mem_pipeline_reg;

ARCHITECTURE rtl OF ex_mem_pipeline_reg IS
BEGIN

    EX_MEM_PLR_controls : entity work.nbit_dff
    generic map ( n => controls_count_JJJJ )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => controls_i,
        q_out  => controls_o
    );

    EX_MEM_PLR_pc_plus4 : entity work.nbit_dff
    generic map ( n => NEXT_PC_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => pc_plus4_i,
        q_out  => pc_plus4_o
    );

    EX_MEM_PLR_inst : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => instruction_i,
        q_out  => instruction_o
    );

    EX_MEM_PLR_rd1 : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => rd1_i,
        q_out  => rd1_o
    );

    EX_MEM_PLR_rd2 : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => rd2_i,
        q_out  => rd2_o
    );

    EX_MEM_PLR_alu_res : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => alu_res_i,
        q_out  => alu_res_o
    );

    EX_MEM_PLR_slt_res : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => slt_res_i,
        q_out  => slt_res_o
    );

    EX_MEM_PLR_lui_res : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => lui_res_i,
        q_out  => lui_res_o
    );

END ARCHITECTURE rtl;
