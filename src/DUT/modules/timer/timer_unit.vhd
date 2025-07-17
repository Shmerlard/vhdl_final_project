LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
use work.aux_package.all;

entity timer_unit is
    generic ( n: integer := 32);
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
        BTCCR0: in std_logic_vector(n-1 downto 0);
        BTCCR1: in std_logic_vector(n-1 downto 0);
        BTIP: in std_logic_vector(1 downto 0);
        BTIFG: out std_logic;
        PWMOUT: out std_logic

    );
end entity timer_unit;

ARCHITECTURE rtl OF timer_unit IS
    signal sel_clk_src_s : std_logic;                 -- the selected clock source signal
    signal btcnt_out_s: STD_LOGIC_VECTOR(n-1 downto 0);

    signal btccr0_latched_s : STD_LOGIC_VECTOR(n-1 downto 0);
    signal btccr1_latched_s : STD_LOGIC_VECTOR(n-1 downto 0);

    signal hue0_s : STD_LOGIC;
    signal btcnt_q24_s : STD_LOGIC;
    signal btcnt_q28_s : STD_LOGIC;
    signal btcnt_q32_s : STD_LOGIC;
    signal btctn_eq_0_s: STD_LOGIC;
BEGIN
    btctn_eq_0_s <= '1' when (btcnt_out_s = (others => '0')) else '0';

    BTCNT : nbit_timer
    generic map (n => n)
    port map
    (
        clk => sel_clk_src_s,
        rst => BTCLR,
        en => not BTHOLD,
        equy => '0',                    --- TODO: check wether clk or equy
        q_out => btcnt_out_s            --- TODO: imlement hue0
                                        --- TODO: implement Q24 Q28 Q32
    );

    timer_output_unit_inst: timer_output_unit
    generic map ( n => n )
    port map
    (
        x_i => btccr0_latched_s,
        y_i => btccr1_latched_s,
        btcnt_i => btcnt_out_s,
        clk_i => sel_clk_src_s,
        en_i => BTOUTEN,
        mode_i => BTOUTMD,
        pwm_out_o => PWMOUT,
        hue0_o => hue0_s
    );

    BTCL0_LATCH: nbit_latch
    generic map( n => n)
    port map
    (
        en => '1',
        d_in => BTCCR0,
        q_out => btccr0_latched_s
    );

    BTCL1_LATCH: nbit_latch
    generic map( n => n)
    port map
    (
        en => '1',
        d_in => BTCCR1,
        q_out => btccr1_latched_s
    );

    -- input clock selector
    with BTSSEL select
        sel_clk_src_s <=
            mclk_i  when "00",
            mclk_i2 when "01",
            mclk_i4 when "10",
            mclk_i8 when others;

    -- output ifg selector
    with BTIP select
        BTIFG <= hue0_s    when "00",
                 btcnt_q24_s when "01",
                 btcnt_q28_s when "10",
                 btcnt_q32_s when others;

END ARCHITECTURE rtl;



