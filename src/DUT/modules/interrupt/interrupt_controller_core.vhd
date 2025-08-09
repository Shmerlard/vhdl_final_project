library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.const_package.all;
use work.memory_map.all;

entity interrupt_controller_core is
    generic (
        INT_UNIT_ADDRESS_ARRAY : t_addr_array := INT_UNIT_ADDRESS_ARRAY
            );
    port 
    (
        rst_i               : in std_logic;
        inta_i              : in std_logic;
        interrupt_src_i     : in std_logic_vector(7 downto 0);
        eint_i              : in std_logic_vector(7 downto 0);

        interrupt_done_o    : out std_logic_vector(7 downto 0);
        ifg_o               : out std_logic_vector(7 downto 0);
        type_o              : out std_logic_vector(7 downto 0);
        int_req_o           : out std_logic
    );
end entity interrupt_controller_core;


architecture rtl of interrupt_controller_core is
    signal irq_s        : std_logic_vector(7 downto 0);
    signal ifg_s        : std_logic_vector(7 downto 0);
    signal clr_irq_s    : std_logic_vector(7 downto 0);
    signal type_s       : std_logic_vector(7 downto 0);
    signal alt_type_s   : std_logic_vector(7 downto 0);
    signal is_interrupt : std_logic;
    signal gie_s        : std_logic;
begin
    ifg_s <= irq_s and eint_i;
    is_interrupt <= '0' when ifg_s = (others => '0') else '1';
    ifg_o <= ifg_s;
    int_req_o <= gie_s and is_interrupt;

-- generate dff input to irq for synchronuos request
    for i in 0 to 7 generate
        signal irq_bit : std_logic_vector(0 downto 0);
    begin
        sync : nbit_dff
        generic map (n => 1)
        port map (
            clk     => interrupt_src_i(i),
            rst     => clr_irq_s(i),
            en      => '1',
            d_in    => "1",
            q_out   => irq_bit
        );

        irq_s(i) <= irq_bit(0);
    end generate;

    -- GIE
    gie_s <= inta_i;

    -- TYPE
    with ifg_s select type_s <= 
        x"04" when x"01",   -- RXIFG
        x"08" when x"02",   -- TXIFG
        x"0C" when x"04",   -- BTIFG
        x"10" when x"08",   -- KEY1IFG
        x"14" when x"10",   -- KEY2IFG
        x"18" when x"20",   -- KEY3IFG
        x"1C" when x"40",   -- FIRIFG
        x"FF" when others;
    type_o <= type_s;



end architecture rtl;

