library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_pulse_sync is
    port (
        rst_i       : in    std_logic;
        FIRENA      : in    std_logic;
        FIRCLK      : in    std_logic;
        FIFOCLK     : in    std_logic;

        FIFOREN     : out   std_logic
    );
end entity fir_pulse_sync;

architecture rtl of fir_pulse_sync is
    signal q1_s, q2_s, q3_s, q4_s, FIRENA_s   : STD_LOGIC_VECTOR(0 downto 0);
    begin
        q1_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIRCLK,
            rst     => rst_i,
            en      => '1',
            d_in    => FIRENA_s,
            q_out   => q1_s
        );

        q2_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIFOCLK,
            rst     => rst_i,
            en      => '1',
            d_in    => q1_s,
            q_out   => q2_s
        );

        q3_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIFOCLK,
            rst     => rst_i,
            en      => '1',
            d_in    => q2_s,
            q_out   => q3_s
        );

        q4_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIFOCLK,
            rst     => rst_i,
            en      => '1',
            d_in    => q3_s,
            q_out   => q4_s
        );

        FIRENA_s(0) <= FIRENA;
        FIFOREN  <= not(q4_s(0)) and q3_s(0);

end architecture rtl;
