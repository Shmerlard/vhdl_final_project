library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  timer_output_unit is
    generic( n : integer := 8);
    port (
        -- inputs
        x_i, y_i                : in std_logic_vector(n-1 downto 0);
        btcnt_i                 : in std_logic_vector(n-1 downto 0);

        clk_i                   : in STD_LOGIC;   --- TODO: Why is it needed? maybe because of synchronous?
        en_i                    : in STD_LOGIC;
        mode_i                  : in STD_LOGIC;
        -- outpus
        pwm_out_o               : out std_logic;
        heu0_o                  : out STD_LOGIC     -- TODO: connect it?
    );
end entity  timer_output_unit;

architecture behavioral of  timer_output_unit is
    -- signal  equy_s, en_s, alufn_00  : std_logic;
    -- signal  timer_out_s             : std_logic_vector(n-1 downto 0);
    -- signal  pwm_out_s               : std_logic;
    signal x_bigger_btcnt_s: STD_LOGIC;
    signal y_bigger_btcnt_s: STD_LOGIC;
    signal btcnt_between_s: STD_LOGIC;
    signal selected_out_s: STD_LOGIC;
begin
    x_bigger_btcnt_s <= '1' when (unsigned(x_i) > UNSIGNED(btcnt_i)) else '0';
    y_bigger_btcnt_s <= '1' when (unsigned(y_i) > UNSIGNED(btcnt_i)) else '0';
    -- checking if between two
    btcnt_between_s <= x_bigger_btcnt_s and not y_bigger_btcnt_s;
    -- choosing what to output
    selected_out_s <= btcnt_between_s when mode_i = '0' else not btcnt_between_s;
    -- outputing just when en == '1'
    pwm_out_o <= selected_out_s and en_i;
    -- outputing heu0
    heu0_o <= '1' when btcnt_i = x_i else '0';

end architecture behavioral;
