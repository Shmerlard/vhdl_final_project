LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.const_package.all;

entity timer_core is
    generic ( n: integer := 32);
    port (
        mclk_i : in std_logic;
        mclk_i2 : in std_logic;
        mclk_i4 : in std_logic;
        mclk_i8 : in std_logic;
        rst_i   : in std_logic;
        BTCLR: in std_logic;
        BTHOLD: in std_logic;
        BTSSEL: in std_logic_vector(1 downto 0);
        BTOUTMD: in std_logic;
        BTOUTEN: in std_logic;
        BTCCR0: in std_logic_vector(n-1 downto 0);
        BTCCR1: in std_logic_vector(n-1 downto 0);
        BTIP: in std_logic_vector(1 downto 0);
        BTIFG: out std_logic;
        PWMOUT: out std_logic;

        d_bus_i: in std_logic_vector(n-1 downto 0);
        btcnt_wr_en: in std_logic;
        d_bus_o: out std_logic_vector(n-1 downto 0)

    );
end entity timer_core;

ARCHITECTURE rtl OF timer_core IS
    signal sel_clk_src_s : std_logic;                 -- the selected clock source signal
    signal btcnt_out_s: STD_LOGIC_VECTOR(n-1 downto 0);

    signal btccr0_latched_s : STD_LOGIC_VECTOR(n-1 downto 0);
    signal btccr1_latched_s : STD_LOGIC_VECTOR(n-1 downto 0);

    signal hue0_s : STD_LOGIC;
    signal btcnt_q24_s : STD_LOGIC;
    signal btcnt_q28_s : STD_LOGIC;
    signal btcnt_q32_s : STD_LOGIC;
    signal btcnt_eq_0_s: STD_LOGIC;
BEGIN
    -- btcnt_eq_0_s <= '1' when (btcnt_out_s = (others => '0')) else '0';
    btcnt_eq_0_s <= '1' when btcnt_out_s = std_logic_vector(to_unsigned(0, btcnt_out_s'length)) else '0';
    d_bus_o <= btcnt_out_s;

    BTCNT : entity work.nbit_counter
    generic map (n => n)
    port map
    (
        clk_i => sel_clk_src_s,
        rst => hue0_s or rst_i,
        en => not BTHOLD,
        equy => BTCLR,                    --- TODO: check wether clk or equy
        d_in => d_bus_i,
        w_en_i => btcnt_wr_en,
        q_out => btcnt_out_s
    );

    timer_output_unit_inst: timer_output_unit
    generic map ( n => n )
    port map
    (
        btccr0_i => btccr0_latched_s,
        btccr1_i => btccr1_latched_s,
        btcnt_i => btcnt_out_s,
        clk_i => sel_clk_src_s,
        en_i => BTOUTEN,
        mode_i => BTOUTMD,
        pwm_out_o => PWMOUT,
        heu0_o => hue0_s
    );

    BTCL0_LATCH: nbit_latch
    generic map( n => n)
    port map
    (
        en => btcnt_eq_0_s,
        d_in => BTCCR0,
        q_out => btccr0_latched_s
    );

    BTCL1_LATCH: nbit_latch
    generic map( n => n)
    port map
    (
        en => btcnt_eq_0_s,
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
                 btcnt_q32_s when others;       -- TODO: implement Q24 - Q32

    -- when debugging we might have smaller n
    process(btcnt_out_s)
    begin
        if n = 32 then
            btcnt_q32_s <= btcnt_out_s(31);
            btcnt_q28_s <= btcnt_out_s(27);
            btcnt_q24_s <= btcnt_out_s(24);
        end if;
    end process;

END ARCHITECTURE rtl;



