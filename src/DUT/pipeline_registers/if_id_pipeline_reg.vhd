LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

entity if_id_pipeline_reg is
    generic(
            DATA_BUS_WIDTH : integer    := 32;
            NEXT_PC_WIDTH : integer     := 8

    );
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;

        instruction_i : in std_logic_vector;
        instruction_o : out std_logic_vector;

        pc_plus4_i : in std_logic_vector;
        pc_plus4_o : out std_logic_vector;

        -- TODO: find better names
        pc_i : in std_logic_vector;
        pc_o : out std_logic_vector
    );
end entity if_id_pipeline_reg;

ARCHITECTURE rtl OF if_id_pipeline_reg IS
    signal delayed_w_en_s : std_logic;
BEGIN
    process(clk_i, rst_i)
    begin
        if (rst_i = '1') then 
            delayed_w_en_s <= '0';
        elsif rising_edge(clk_i) then
            delayed_w_en_s <= '1';
        end if;
    end process;

    IF_ID_PLR_instruction : entity work.nbit_dff
    generic map ( n => DATA_BUS_WIDTH )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => delayed_w_en_s,
        d_in   => instruction_i,
        q_out  => instruction_o
    );

    IF_ID_PLR_pc_plus4 : entity work.nbit_dff
    generic map ( n => NEXT_PC_WIDTH)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => delayed_w_en_s,
        d_in   => pc_plus4_i,
        q_out  => pc_plus4_o
    );

    -- TODO: find better name
    IF_ID_PLR_ssssssss : entity work.nbit_dff
    generic map ( n => NEXT_PC_WIDTH)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => delayed_w_en_s,
        d_in   => pc_i,
        q_out  => pc_o
    );
END ARCHITECTURE rtl;
