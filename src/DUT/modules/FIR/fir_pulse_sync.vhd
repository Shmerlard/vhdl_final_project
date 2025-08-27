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
    signal q1_s, q2_s, q3_s, q4_s, FIRENA_s   : std_logic;
    begin
        q1_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIRCLK,
            rst     => rst_i,
            en      => '1',
            d_in(0)    => FIRENA_s,
            q_out(0)   => q1_s
        );

        q2_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIFOCLK,
            rst     => rst_i,
            en      => '1',
            d_in(0)    => q1_s,
            q_out(0)   => q2_s
        );

        q3_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIFOCLK,
            rst     => rst_i,
            en      => '1',
            d_in(0)    => q2_s,
            q_out(0)   => q3_s
        );

        q4_reg: entity work.nbit_dff
        generic map(n => 1)
        port map(
            clk     => FIFOCLK,
            rst     => rst_i,
            en      => '1',
            d_in(0)    => q3_s and FIRCLK,
            q_out(0)   => q4_s
        );

        FIRENA_s <= FIRENA;
        FIFOREN  <= not(q4_s) and (q3_s and FIRCLK);

end architecture rtl;
