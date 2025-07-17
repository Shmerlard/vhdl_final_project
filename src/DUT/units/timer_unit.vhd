LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

entity timer_unit is
    port (
        mclk_i : in std_logic;
        mclk_i2 : in std_logic;
        mclk_i4 : in std_logic;
        mclk_i8 : in std_logic;
        BTCLR: in std_logic;
        BTHOLD: in std_logic;
        BTSSEL: in std_logic_vector(1 downto 0);
        BTOUTMD: in std_logic;
        BTOUTEN: in std_logic;
        BTCCR0: in std_logic_vector(31 downto 0);
        BTCCR1: in std_logic_vector(31 downto 0);
        BTIP: in std_logic_vector(1 downto 0);
        BTIFG: out std_logic;
        PWMOUT: out std_logic

    );
end entity timer_unit;

ARCHITECTURE rtl OF timer_unit IS
    signal sel_clk_src_s : std_logic;                 -- the selected clock source signal


BEGIN



    with BTSSEL select
        sel_clk_src_s <=
            mclk_i  when "00",
            mclk_i2 when "01",
            mclk_i4 when "10",
            mclk_i8 when others;

END ARCHITECTURE rtl;



