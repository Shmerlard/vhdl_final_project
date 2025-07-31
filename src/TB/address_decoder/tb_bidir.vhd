library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bidir is
    port (
        clk       : in  std_logic;
        we_r0     : in  std_logic;  -- write enable for reg0
        we_r1     : in  std_logic;  -- write enable for reg1
        re_r0     : in  std_logic;  -- read enable for reg0
        re_r1     : in  std_logic;  -- read enable for reg1
        switches : in std_logic_vector(3 downto 0);
        switch_en: in std_logic;
        data_bus  : inout std_logic_vector(3 downto 0);
        leds      : out std_logic_vector(7 downto 0)
    );
end tb_bidir;

architecture rtl of tb_bidir is
    signal reg0 : std_logic_vector(3 downto 0) := (others => '0');
    signal reg1 : std_logic_vector(3 downto 0) := (others => '0');
    signal bus_out : std_logic_vector(3 downto 0);
    signal bus_en  : std_logic := '0';
begin
    -- Register write
    process(clk)
    begin
        if rising_edge(clk) then
            if we_r0 = '1' then
                reg0 <= data_bus;
            end if;
            if we_r1 = '1' then
                reg1 <= data_bus;
            end if;
        end if;
    end process;

    -- Tristate drive logic
    bus_out <= reg0 when re_r0 = '1' else
               reg1 when re_r1 = '1' else
               (others => 'Z');

    bus_en <= re_r0 or re_r1;

    data_bus <= bus_out when bus_en = '1' else
                switches when switch_en = '1' else
                (others => 'Z');

    -- LEDs show both registers
    leds(3 downto 0) <= reg0;
    leds(7 downto 4) <= reg1;

end rtl;
