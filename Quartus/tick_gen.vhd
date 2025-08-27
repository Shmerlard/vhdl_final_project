library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tick_gen is
  generic (
    F_IN_HZ  : integer := 50_000_000; -- set to 50_000_000 for 50 MHz, or 50 for 50 Hz
    TICK_HZ  : integer := 1           -- how often you want a 1-cycle pulse
  );
  port (
    clk_i  : in  std_logic;
    rst_i  : in  std_logic;           -- active high
    tick_o : out std_logic            -- '1' for 1 clock at TICK_HZ rate
  );
end entity;

architecture rtl of tick_gen is
  constant CNT_MAX : integer := F_IN_HZ / TICK_HZ - 1; -- integer division
  signal cnt       : integer range 0 to CNT_MAX := 0;
  signal tick_s    : std_logic := '0';
begin
  tick_o <= tick_s;

  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_i = '1' then
        cnt    <= 0;
        tick_s <= '0';
      else
        if cnt = CNT_MAX then
          cnt    <= 0;
          tick_s <= '1';
        else
          cnt    <= cnt + 1;
          tick_s <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;
