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
        clk_i               : in std_logic;
        rst_i               : in std_logic;
        inta_i              : in std_logic;
        interrupt_src_i     : in std_logic_vector(7 downto 0);
        eint_i              : in std_logic_vector(7 downto 0);
        reti_i              : in std_logic;

        interrupt_done_o    : out std_logic_vector(7 downto 0);
        ifg_o               : out std_logic_vector(7 downto 0);
        type_o              : out std_logic_vector(7 downto 0);
        icc_o               : out std_logic_vector(2 downto 0);
        intr_o              : out std_logic
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
    signal inta_prev_s, inta_fall_s : std_logic;
    signal reti_prev_s, reti_rise_s : std_logic;
    signal icc_s        : std_logic_vector(2 downto 0);
begin
    ifg_s <= irq_s and eint_i;
    is_interrupt <= '0' when ifg_s = (others => '0') else '1';
    ifg_o <= ifg_s;
    intr_o <= gie_s and is_interrupt;

-- generate dff input to irq for synchronuos request
    for i in 0 to 7 generate
    begin
        sync : nbit_dff
        generic map (n => 1)
        port map (
            clk     => interrupt_src_i(i),
            rst     => clr_irq_s(i),
            en      => '1',
            d_in    => "1",
            q_out   => irq_s(i)
        );
    end generate;

    -- GIE
    process(rst_i, clk_i)
    begin
        if rst_i = '1' then
            gie_s <= '1';
        elsif rising_edge(clk_i) then 
            if inta_fall_s = '1' then
                gie_s <= '0';
            elsif reti_rise_s = '1' then
                gie_s <= '1';
            end if;
        end if;
    end process;

    -- TYPE MASKED
    process(rst_i, clk_i)
    begin
        if rst_i = '1' then
            type_s <= (others => '0');
        elsif rising_edge(clk_i) then
            if ifg_s(0) = '1' then          -- RX
                type_s <= x"08";            -- when is type = 04?????
                clr_irq_s(0) <= '1';        -- reset irq in next cycle
            elsif ifg_s(1) = '1' then       -- TX
                type_s <= x"0C";
                clr_irq_s(1) <= '1';        -- reset irq in next cycle
            elsif ifg_s(2) = '1' then       -- BT
                type_s <= x"10";
                clr_irq_s(2) <= '1';        -- reset irq in next cycle
            elsif ifg_s(3) = '1' then       -- KEY1
                type_s <= x"14";
                clr_irq_s(3) <= '1';        -- reset irq in next cycle
            elsif ifg_s(4) = '1' then       -- KEY2
                type_s <= x"18";
                clr_irq_s(4) <= '1';        -- reset irq in next cycle
            elsif ifg_s(5) = '1' then       -- KEY3
                type_s <= x"1C";
                clr_irq_s(5) <= '1';        -- reset irq in next cycle
            elsif ifg_s(6) = '1' then     
                if irq_s(6) = '1' then      -- FIFO EMPTY
                    type_s <= x"20";
                    clr_irq_s(6) <= '1';    -- reset irq in next cycle
                elsif irq_s(7) = '1' then   -- FIROUT
                    type_s <= x"24";
                    clr_irq_s(7) <= '1';    -- reset irq in next cycle
                end if;
            end if;
        end if;
    end process;

    type_o <= type_s;

-- reti prev update
    reti_prev: nbit_dff
    generic map (n => 1)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => reti_i,
        q_out  => reti_rise_s
    );

-- reti falling edge flag
reti_rise_s <= '1' when ((reti_prev_s = '0') and (reti_i = '1')) else '0';

-- INTA prev update
    inta_prev: nbit_dff
    generic map (n => 1)
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => inta_i,
        q_out  => inta_prev_s
    );

-- INTA falling edge flag
inta_fall_s <= '1' when ((inta_prev_s = '1') and (inta_i = '0')) else '0';
            
-- Interrupt Cycle Counter (ICC)
    process(clk_i, rst_i)
    begin
        if (rst_i = '1') then
            icc_s <= (others => '0');
        elsif rising_edge(clk_i) then
            if (inta_fall_s = '1') then
                icc_s <= to_unsigned(1, 3);
            elsif ((icc_s > 0) and (icc_s < 5)) then 
                icc_s <= icc_s + 1;
            else
                icc_s <= (others => '0');
            end if;
        end if;
    end process;

    icc_o <= icc_s;

end architecture rtl;

