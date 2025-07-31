library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_2_bidir is
    port (
        clk_i     : in  std_logic;
        rst_i     : in  std_logic;
        we_r0     : in  std_logic;  -- write enable for reg0
        we_r1     : in  std_logic;  -- write enable for reg1
        re_r0     : in  std_logic;  -- read enable for reg0
        re_r1     : in  std_logic;  -- read enable for reg1
        switches  : in std_logic_vector(3 downto 0);
        switch_en : in std_logic;
        data_bus  : out std_logic_vector(3 downto 0);
        reg_leds  : out std_logic_vector(7 downto 0)
    );
end tb_2_bidir;

architecture rtl of tb_2_bidir is
    signal bus_out : std_logic_vector(3 downto 0);
    -- signal man_bus : std_logic_vector(3 downto 0);
    signal clk: std_logic;
    signal rst: std_logic;

    signal reg0_q_in: std_logic_vector(3 downto 0);
    signal reg1_q_in: std_logic_vector(3 downto 0);
    signal reg0_q_out: std_logic_vector(3 downto 0);
    signal reg1_q_out: std_logic_vector(3 downto 0);

    signal we_r1_s: std_logic;
    signal we_r0_s: std_logic;
    signal re_r1_s: std_logic := '0';
    signal re_r0_s: std_logic := '0';
begin
    clk <= not clk_i;
    rst <= not rst_i;
    data_bus <= bus_out;

    re_r1_s <=  re_r1 when switch_en = '0' and re_r0_s = '0' else '0';
    re_r0_s <=  re_r0 when switch_en = '0' and re_r1_s = '0' else '0';

    bus_out <= switches when switch_en = '1' else
               (others => 'Z');

    reg_a: entity work.nbit_dff
    generic map( n => 4)
    port map (
        clk => clk,
        rst => rst,
        en => we_r0,
        d_in => reg0_q_in,
        q_out => reg0_q_out
    );
    reg_a_buffer: entity work.BidirPin
    generic map( width => 4)
    port map (
        Dout => reg0_q_out,
        en => re_r0_s,
        Din => reg0_q_in,
        IOpin => bus_out
    );
    reg_b: entity work.nbit_dff
    generic map( n => 4)
    port map (
        clk => clk,
        rst => rst,
        en => we_r1,
        d_in => reg1_q_in,
        q_out => reg1_q_out
    );
    reg_b_buffer: entity work.BidirPin
    generic map( width => 4)
    port map (
        Dout => reg1_q_out,
        en => re_r1_s,
        Din => reg1_q_in,
        IOpin => bus_out
    );
    reg_leds(3 downto 0) <= reg0_q_out;
    reg_leds(7 downto 4) <= reg1_q_out;



end rtl;
