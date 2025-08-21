library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
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
        interrupt_src_i     : in std_logic_vector(8 downto 0);
        eint_i              : in std_logic_vector(7 downto 0);
        gie_i               : in std_logic;

        ifg_o               : out std_logic_vector(6 downto 0);
        type_reg_d_in_o     : out std_logic_vector(7 downto 0);
        int_req_o              : out std_logic
    );
end entity interrupt_controller_core;


architecture rtl of interrupt_controller_core is
    signal irq_s        : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal ifg_s        : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal en_int_s     : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal clr_irq_s    : std_logic_vector(INT_SRC_COUNT-1 downto 0);
    signal is_interrupt : std_logic;
    signal inta_i_b_not : std_logic;

    signal enc_pri_int_s: std_logic_vector(3 downto 0);
    signal selected_sync_int: std_logic_vector(3 downto 0);
    signal irq_dff_clr: std_logic_vector(INT_SRC_COUNT-1 downto 0);
begin

    -- generate dff input to irq for synchronuos request
    irq_dff_gen : for i in 0 to INT_SRC_COUNT-1 generate
    begin
        sync : nbit_dff
        generic map (n => 1)
        port map (
            clk     => interrupt_src_i(i),
            rst     => irq_dff_clr(i),
            en      => '1',
            d_in    => "1",
            q_out(0)=> irq_s(i)
        );
    end generate;

    process(rst_i, clk_i)
    begin
        if rst_i = '1' then
            clr_irq_s <= (others => '0');
        elsif rising_edge(clk_i) then
            if to_integer(selected_sync_int) /= 0 then                  -- TODO: CHECK
                clr_irq_s(to_integer(selected_sync_int) - 1) <= not(inta_i_b);
            end if;
        end if;
    end process;
    irq_dff_clr <= clr_irq_s or (8 downto 0 => rst_i);

    en_int_s(0) <= eint_i(0);       --TODO: CREATE A FUNCTION FOR THIS
    en_int_s(1) <= eint_i(0);
    en_int_s(2) <= eint_i(1);
    en_int_s(3) <= eint_i(2);
    en_int_s(4) <= eint_i(3);
    en_int_s(5) <= eint_i(4);
    en_int_s(6) <= eint_i(5);
    en_int_s(7) <= eint_i(6);
    en_int_s(8) <= eint_i(6);

    ifg_s <= irq_s and en_int_s;

    ifg_o(0) <= ifg_s(0) or ifg_s(1); -- TODO: CREATE A FUNCTION FOR THIS
    ifg_o(1) <= ifg_s(2);
    ifg_o(2) <= ifg_s(3);
    ifg_o(3) <= ifg_s(4);
    ifg_o(4) <= ifg_s(5);
    ifg_o(5) <= ifg_s(6);
    ifg_o(6) <= ifg_s(7) or ifg_s(8);


    -- is_interrupt <= '0' when ifg_s = (others => '0') else '1';
    with ifg_s select
        is_interrupt <= '0' when (8 downto 0 => '0'),
                        '1' when others;
    int_req_o <= gie_i and is_interrupt;

    enc_pri_int_s <= "0001" when ifg_s(0) = '1' else
                     "0010" when ifg_s(1) = '1' else
                     "0011" when ifg_s(2) = '1' else
                     "0100" when ifg_s(3) = '1' else
                     "0101" when ifg_s(4) = '1' else
                     "0110" when ifg_s(5) = '1' else
                     "0111" when ifg_s(6) = '1' else
                     "1000" when ifg_s(7) = '1' else
                     "1001" when ifg_s(8) = '1' else
                     "0000";

    inta_i_b_not <= not inta_i_b;
    selected_int_reg: entity work.nbit_dff
     generic map( n => 4)
    port map(
        clk => inta_i_b_not,        --- TODO: CHECK IF not is needed
        rst => rst_i,
        en => '1',
        d_in => enc_pri_int_s,
        q_out => selected_sync_int
    );

    -- type_reg_d_in_o <= "0" & shift_left(selected_sync_int, 2) & "00";
    type_reg_d_in_o <= "00" & selected_sync_int & "00";


end architecture rtl;

