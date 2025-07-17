library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_gen is
    generic( n : integer := 8);
    port (
        -- inputs
        x_i, y_i, counter_i     : in std_logic_vector(n-1 downto 0);
        clk_i, en_i             : in std_logic;
        pwm_mode_i              : in STD_LOGIC_VECTOR(1 downto 0);

        -- outpus
        pwm_out_o, equy_o       : out std_logic
    );
end entity pwm_gen;

architecture behavioral of pwm_gen is
    signal  pwm_out_r, mode_01_out:  std_logic;
begin
    -- PWM_out logic
    process(clk_i)
    begin 
        if rising_edge(clk_i) then
            if en_i = '1' then
                if (pwm_mode_i = "10") then
                    if (counter_i = x_i) then
                        pwm_out_r <= not pwm_out_r;
                    end if;
                elsif (counter_i > x_i) then
                    pwm_out_r <= mode_01_out;
                else
                    pwm_out_r <= not mode_01_out;
                end if;
            end if;
        end if;
    end process;

    mode_01_out <= '0' when (pwm_mode_i = "01") else '1';
    pwm_out_o   <= pwm_out_r;


    -- EQUY logic
    equy_o <= '0' when (counter_i < y_i) else '1';

end architecture behavioral;
