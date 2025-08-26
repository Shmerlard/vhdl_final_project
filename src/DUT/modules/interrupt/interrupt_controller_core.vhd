library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.const_package.all;
use work.memory_map.all;

entity interrupt_controller_core is
    generic (
        INT_SRC_COUNT: NATURAL := 9;
        INT_IFG_COUNT: NATURAL := 7
            );
    port 
    (   
        clk_i               : in std_logic;
        rst_i               : in std_logic;
        inta_i_b            : in std_logic;
        int_src_from_periph_i : in std_logic_vector(8 downto 0);
        data_bus_i            : in std_logic_vector(6 downto 0);
        eint_i              : in std_logic_vector(6 downto 0);
        gie_i               : in std_logic;
        ifg_cs_write_ctl_i  : in std_logic;

        -- ifg_write_en        : in std_logic;
        -- ifg_d_in_i          : in std_logic_vector(INT_SRC_COUNT-1 downto 0);
        ifg_o               : out std_logic_vector(6 downto 0);
        type_reg_d_in_o     : out std_logic_vector(7 downto 0);
        int_req_o              : out std_logic
    );
end entity interrupt_controller_core;


architecture rtl of interrupt_controller_core is
    signal clr_irq_manual_s : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal set_irq_manual_s : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal data_bus_s       : std_logic_vector(INT_SRC_COUNT-1 downto 0);

    signal int_clr_irq_s    : std_logic_vector(INT_SRC_COUNT-1 downto 0);  -- the clear of each dff
    signal int_src_s        : std_logic_vector(INT_SRC_COUNT-1 downto 0);  -- the trigger for each dff
    signal int_dff_dout_s        : std_logic_vector(INT_SRC_COUNT-1 downto 0);  -- the outout of each dff

    -- signal irq_s        : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    -- signal ifg_s        : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal en_int_s     : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal en_irq_s     : std_logic_vector(INT_SRC_COUNT-1 downto 0);

    -- signal ifg_s        :  std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal clr_irq_auto    : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal rst_irq_s       : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal is_interrupt : std_logic;
    -- signal inta_i_b_not : std_logic;
    --
    signal enc_pri_int_s: std_logic_vector(3 downto 0);
    -- signal selected_sync_int: std_logic_vector(3 downto 0);
    -- signal irq_dff_clr: std_logic_vector(INT_SRC_COUNT-1 downto 0);
    --
    -- signal ireq_q_out : std_logic_vector(INT_SRC_COUNT-1 downto 0);
begin

    -- generate dff input to irq for synchronuos request
    irq_dff_gen : for i in 0 to INT_SRC_COUNT-1 generate
    begin
        sync : nbit_dff
        generic map (n => 1)
        port map (
            clk     => int_src_s(i),
            rst     => int_clr_irq_s(i),
            en      => '1',
            d_in    => "1",
            q_out(0)=> int_dff_dout_s(i)
        );

        clr_irq_manual_s(i) <= not data_bus_s(i) when ifg_cs_write_ctl_i = '1' else '0';

    end generate;

    rst_irq_s <= "000000000" when rst_i = '0' else "111111111";
    int_clr_irq_s <= clr_irq_manual_s or clr_irq_auto or rst_irq_s;
    int_src_s     <= int_src_from_periph_i or set_irq_manual_s;

    data_bus_s(0) <= data_bus_i(0);       --TODO: CREATE A FUNCTION FOR THIS
    data_bus_s(1) <= data_bus_i(0);
    data_bus_s(2) <= data_bus_i(1);
    data_bus_s(3) <= data_bus_i(2);
    data_bus_s(4) <= data_bus_i(3);
    data_bus_s(5) <= data_bus_i(4);
    data_bus_s(6) <= data_bus_i(5);
    data_bus_s(7) <= data_bus_i(6);
    data_bus_s(8) <= data_bus_i(6);


    -- set_irq_manual_s(0) <= '0';       --TODO: CREATE A FUNCTION FOR THIS
    -- set_irq_manual_s(1) <= data_bus_s(1) when ifg_cs_write_ctl_i = '1' and rising_edge(clk_i) else '0';
    -- set_irq_manual_s(2) <= data_bus_s(2) when ifg_cs_write_ctl_i = '1' and rising_edge(clk_i) else '0';
    -- set_irq_manual_s(3) <= data_bus_s(3) when ifg_cs_write_ctl_i = '1' and rising_edge(clk_i) else '0';
    -- set_irq_manual_s(4) <= data_bus_s(4) when ifg_cs_write_ctl_i = '1' and rising_edge(clk_i) else '0';
    -- set_irq_manual_s(5) <= data_bus_s(5) when ifg_cs_write_ctl_i = '1' and rising_edge(clk_i) else '0';
    -- set_irq_manual_s(6) <= data_bus_s(6) when ifg_cs_write_ctl_i = '1' and rising_edge(clk_i) else '0';
    -- set_irq_manual_s(7) <= '0';
    -- set_irq_manual_s(8) <= data_bus_s(8) when ifg_cs_write_ctl_i = '1' else '0';

    set_irq_manual_proc : process(clk_i)
    begin
        if rising_edge(clk_i) then
            set_irq_manual_s(0) <= '0';
            set_irq_manual_s(1) <= data_bus_s(1) when ifg_cs_write_ctl_i = '1' else '0';
            set_irq_manual_s(2) <= data_bus_s(2) when ifg_cs_write_ctl_i = '1' else '0';
            set_irq_manual_s(3) <= data_bus_s(3) when ifg_cs_write_ctl_i = '1' else '0';
            set_irq_manual_s(4) <= data_bus_s(4) when ifg_cs_write_ctl_i = '1' else '0';
            set_irq_manual_s(5) <= data_bus_s(5) when ifg_cs_write_ctl_i = '1' else '0';
            set_irq_manual_s(6) <= data_bus_s(6) when ifg_cs_write_ctl_i = '1' else '0';
            set_irq_manual_s(7) <= '0';
            set_irq_manual_s(8) <= data_bus_s(8) when ifg_cs_write_ctl_i = '1' else '0';
        end if;
    end process;


    en_int_s(0) <= eint_i(0);       --TODO: CREATE A FUNCTION FOR THIS
    en_int_s(1) <= eint_i(0);
    en_int_s(2) <= eint_i(1);
    en_int_s(3) <= eint_i(2);
    en_int_s(4) <= eint_i(3);
    en_int_s(5) <= eint_i(4);
    en_int_s(6) <= eint_i(5);
    en_int_s(7) <= eint_i(6);
    en_int_s(8) <= eint_i(6);

    en_irq_s <= en_int_s and int_dff_dout_s;

    ifg_o(0) <= en_irq_s(0) or en_irq_s(1); -- TODO: CREATE A FUNCTION FOR THIS
    ifg_o(1) <= en_irq_s(2);
    ifg_o(2) <= en_irq_s(3);
    ifg_o(3) <= en_irq_s(4);
    ifg_o(4) <= en_irq_s(5);
    ifg_o(5) <= en_irq_s(6);
    ifg_o(6) <= en_irq_s(7) or en_irq_s(8);

    enc_pri_int_s <= "0001" when en_irq_s(0) = '1' else
                     "0010" when en_irq_s(1) = '1' else
                     "0011" when en_irq_s(2) = '1' else
                     "0100" when en_irq_s(3) = '1' else
                     "0101" when en_irq_s(4) = '1' else
                     "0110" when en_irq_s(5) = '1' else
                     "0111" when en_irq_s(6) = '1' else
                     "1000" when en_irq_s(7) = '1' else
                     "1001" when en_irq_s(8) = '1' else
                     "0000";

    type_reg_d_in_o <= "00" & enc_pri_int_s & "00";
    with en_irq_s select
        is_interrupt <= '0' when (8 downto 0 => '0'),
                        '1' when others;
    int_req_o <= gie_i and is_interrupt;

    clr_irq_auto(0) <= '0';
    clr_irq_auto(1) <= '0'; 
    clr_irq_auto(2) <= '0';
    clr_irq_auto(3) <= not inta_i_b;
    clr_irq_auto(4) <= '0';
    clr_irq_auto(5) <= '0';
    clr_irq_auto(6) <= '0';
    clr_irq_auto(7) <= not inta_i_b;
    clr_irq_auto(8) <= not inta_i_b;
    -- clr_irq_manual_s <= data_bus_i

    -- irq_proc_gen : for i in 0 to INT_SRC_COUNT-1 generate
    -- begin
    --     irq_proc : process (rst_i, interrupt_src_i(i), clk_i)
    --     begin
    --         if rst_i = '1' then
    --             ireq_q_out(i) <= '0';
    --         elsif rising_edge(clk_i) then
    --                 if ifg_write_en = '1' then
    --                     ireq_q_out(i) <= ifg_d_in_i(i);
    --                 end if;
    --         elsif rising_edge(interrupt_src_i(i)) then
    --             ireq_q_out(i) <= '1';
    --         end if;
    --     end process;
    -- end generate;
    -- process(rst_i, clk_i)
    -- begin
    --     if rst_i = '1' then
    --         clr_irq_s <= (others => '0');
    --     elsif rising_edge(clk_i) then
    --         -- if to_integer(selected_sync_int) /= 0 then                  -- TODO: CHECK
    --         --     clr_irq_s(to_integer(selected_sync_int) - 1) <= not(inta_i_b);
    --         -- end if;
    --     end if;
    -- end process;

    -- clr_irq_s(0) <= not(inta_i_b) when (selected_sync_int = x"1") else '0';
    -- clr_irq_s(1) <= not(inta_i_b) when (selected_sync_int = x"2") else '0';
    -- clr_irq_s(2) <= not(inta_i_b) when (selected_sync_int = x"3") else '0';
    -- clr_irq_s(3) <= not(inta_i_b) when (selected_sync_int = x"4") else '0';
    -- clr_irq_s(4) <= not(inta_i_b) when (selected_sync_int = x"5") else '0';
    -- clr_irq_s(5) <= not(inta_i_b) when (selected_sync_int = x"6") else '0';
    -- clr_irq_s(6) <= not(inta_i_b) when (selected_sync_int = x"7") else '0';
    -- clr_irq_s(7) <= not(inta_i_b) when (selected_sync_int = x"8") else '0';
    -- clr_irq_s(8) <= not(inta_i_b) when (selected_sync_int = x"9") else '0';

    -- irq_dff_clr <= clr_irq_s or (8 downto 0 => rst_i);


    -- ifg_s <= irq_s and en_int_s;

    -- ifg_o(0) <= ifg_s(0) or ifg_s(1); -- TODO: CREATE A FUNCTION FOR THIS
    -- ifg_o(1) <= ifg_s(2);
    -- ifg_o(2) <= ifg_s(3);
    -- ifg_o(3) <= ifg_s(4);
    -- ifg_o(4) <= ifg_s(5);
    -- ifg_o(5) <= ifg_s(6);
    -- ifg_o(6) <= ifg_s(7) or ifg_s(8);


    -- is_interrupt <= '0' when ifg_s = (others => '0') else '1';
    -- with en_irq_s select
    --     is_interrupt <= '0' when (8 downto 0 => '0'),
    --                     '1' when others;
    -- int_req_o <= gie_i and is_interrupt;

    -- enc_pri_int_s <= "0001" when ifg_s(0) = '1' else
    --                  "0010" when ifg_s(1) = '1' else
    --                  "0011" when ifg_s(2) = '1' else
    --                  "0100" when ifg_s(3) = '1' else
    --                  "0101" when ifg_s(4) = '1' else
    --                  "0110" when ifg_s(5) = '1' else
    --                  "0111" when ifg_s(6) = '1' else
    --                  "1000" when ifg_s(7) = '1' else
    --                  "1001" when ifg_s(8) = '1' else
    --                  "0000";

    -- inta_i_b_not <= not inta_i_b;
    -- selected_int_reg: entity work.nbit_dff
    --  generic map( n => 4)
    -- port map(
    --     clk => inta_i_b_not,        --- TODO: CHECK IF not is needed
    --     rst => rst_i,
    --     en => '1',
    --     d_in => enc_pri_int_s,
    --     q_out => selected_sync_int
    -- );

    -- type_reg_d_in_o <= "0" & shift_left(selected_sync_int, 2) & "00";
    -- type_reg_d_in_o <= "00" & selected_sync_int & "00";


end architecture rtl;

