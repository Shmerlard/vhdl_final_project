LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY timer_unit_tb IS
END ENTITY;

ARCHITECTURE tb OF timer_unit_tb IS
    constant n : integer := 32;
    constant clk_period : time := 1 ns;

    signal mclk_i     : std_logic := '0';
    signal mclk_i2    : std_logic := '0';
    signal mclk_i4    : std_logic := '0';
    signal mclk_i8    : std_logic := '0';
    signal BTCLR      : std_logic := '0';
    signal BTHOLD     : std_logic := '0';
    signal BTSSEL     : std_logic_vector(1 downto 0) := "00";
    signal BTOUTMD    : std_logic := '0';
    signal BTOUTEN    : std_logic := '1';
    signal BTCCR0     : std_logic_vector(n-1 downto 0) := (others => '0');
    signal BTCCR1     : std_logic_vector(n-1 downto 0) := (others => '0');
    signal BTIP       : std_logic_vector(1 downto 0) := "00";

    signal BTIFG      : std_logic;
    signal PWMOUT     : std_logic;

BEGIN

    DUT: entity work.timer_unit
        generic map(n => n)
        port map (
            mclk_i => mclk_i,
            mclk_i2 => mclk_i2,
            mclk_i4 => mclk_i4,
            mclk_i8 => mclk_i8,
            BTCLR => BTCLR,
            BTHOLD => BTHOLD,
            BTSSEL => BTSSEL,
            BTOUTMD => BTOUTMD,
            BTOUTEN => BTOUTEN,
            BTCCR0 => BTCCR0,
            BTCCR1 => BTCCR1,
            BTIP => BTIP,
            BTIFG => BTIFG,
            PWMOUT => PWMOUT
        );

    -- Clock generators
    clk_proc: process
    begin
        wait for clk_period / 2;
        mclk_i  <= not mclk_i;
        mclk_i2 <= not mclk_i2 after 2*(clk_period / 2);
        mclk_i4 <= not mclk_i4 after 4*(clk_period / 2);
        mclk_i8 <= not mclk_i8 after 8*(clk_period / 2);
    end process;

    stim_proc: process
    begin
        -- Reset
        BTCLR <= '1';
        wait for 5 ns;
        BTCLR <= '0';

        -- Set BTCCR0 and BTCCR1
        BTCCR0 <= std_logic_vector(to_unsigned(60, n));
        BTCCR1 <= std_logic_vector(to_unsigned(20, n));

        -- Hold inactive, let counter run
        BTHOLD <= '0';

        -- Sweep BTSSEL
        BTSSEL <= "00"; wait for 100 ns;
        BTSSEL <= "01"; wait for 100 ns;
        BTSSEL <= "10"; wait for 100 ns;
        BTSSEL <= "11"; wait for 100 ns;

        -- Switch IFG source
        BTIP <= "01"; wait for 50 ns;
        BTIP <= "10"; wait for 50 ns;
        BTIP <= "11"; wait for 50 ns;

        wait;
    end process;

END ARCHITECTURE;

