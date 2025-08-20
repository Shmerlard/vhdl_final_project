library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity interrupt_handler is
    generic(data_bus_width : natural := 32);
    port(
        clk_i               : in    std_logic;
        rst_i               : in    std_logic;
        intr_i              : in    std_logic;
        reti_ctl_i          : in    std_logic;
        instruction_id_i    : in    std_logic_vector(data_bus_width-1 downto 0);
        int_ack_o           : out   std_logic;
        c1_cmp_o            : out   std_logic;
        c3_cmp_o            : out   std_logic;
        load_from_type_o    : out   std_logic;
        c1to3_cmp_o         : out   std_logic;
        c2to5_cmp_o         : out   std_logic;
        reg_type_addr_o     : out   std_logic_vector(11 downto 0);
        reg_type_addr_sel   : out   std_logic
    );
end interrupt_handler;

architecture struct of interrupt_handler is
-- signals declerations
    signal icc_s            : std_logic_vector(2 downto 0);
    signal inta_proc1_s, inta_proc2_s, inta_proc3_s: std_logic;

    signal c1_cmp_s, c2_cmp_s, c3_cmp_s, c4_cmp_s, c5_cmp_s: std_logic;


begin
-- interrupt cycle counter FSM (ICC)
    process(rst_i, clk_i)
    begin
        if (rst_i = '1') then
            icc_s <= "000";
            int_ack_o <= '1';
            reg_type_addr_sel <= '0';
        elsif rising_edge(clk_i) then
            case icc_s is
                when "000" => 
                    if (intr_i = '1') then
                        icc_s <= "001";
                        int_ack_o <= '0';
                    end if;
                when "001" => 
                    icc_s <= "010";
                when "010" => 
                    reg_type_addr_sel <= '1';
                    int_ack_o <= '1';
                    icc_s <= "011";
                when "011" => 
                    icc_s <= "100";
                when "100" => 
                    reg_type_addr_sel <= '0';
                    icc_s <= "101";
                when "101" => 
                    if (reti_ctl_i = '1') then
                        icc_s <= "110";
                    end if;
                when "110" => 
                    icc_s <= "000";
                when others =>
                    icc_s <= "000";
            end case;
        end if;
    end process;

    -- INTA logic
        -- process(rst_i, clk_i)
        -- begin
        --     if not(rst_i) = '1' then
        --         inta_proc1_s <= '1';
        --     elsif rising_edge(clk_i) then
        --         inta_proc1_s <= intr_i;
        --     end if;
        -- end process;
        --
        -- process(rst_i, clk_i)
        -- begin
        --     if not(rst_i) = '1' then
        --         inta_proc2_s <= '1';
        --     elsif rising_edge(clk_i) then
        --         inta_proc2_s <= inta_proc1_s;
        --     end if;
        -- end process;
        --
        -- process(rst_i, clk_i)
        -- begin
        --     if not(rst_i) = '1' then
        --         inta_proc3_s <= '1';
        --     elsif rising_edge(clk_i) then
        --         inta_proc3_s <= inta_proc2_s;
        --     end if;
        -- end process;

-- outputs assignments
    -- int_ack_o   <= not(not(rst_i) and not(inta_proc3_s) and inta_proc1_s);
    c1_cmp_s    <= '1' when (icc_s = "001") else '0';
    c2_cmp_s    <= '1' when (icc_s = "010") else '0';
    c3_cmp_s    <= '1' when (icc_s = "011") else '0';
    c4_cmp_s    <= '1' when (icc_s = "100") else '0';
    c5_cmp_s    <= '1' when (icc_s = "101") else '0';

    load_from_type_o <= c1_cmp_s;
    -- c1to3_cmp_o <= '1' when ((icc_s > 0) and (icc_s < 4)) else '0';
    c1to3_cmp_o <= c1_cmp_s or c2_cmp_s or c3_cmp_s;
    c2to5_cmp_o <= c2_cmp_s or c3_cmp_s or c4_cmp_s or c5_cmp_s;
    -- c2to5_cmp_o <= '1' when ((icc_s > 1) and (icc_s < 6)) else '0';
    c1_cmp_o <= c1_cmp_s;
    c3_cmp_o <= c3_cmp_s;

    reg_type_addr_o <= x"842";
end struct;
