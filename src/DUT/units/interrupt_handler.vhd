library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interrupt_handler is
    generic(data_bus_width : natural := 32);
    port(
        clk_i               : in    std_logic;
        rst_i               : in    std_logic;
        intr_i              : in    std_logic;
        reti_ctl_i          : in    std_logic;
        instruction_id_i    : in    std_logic_vector(data_bus_width-1 downto 0);
        int_ack_o           : out   std_logic;
        gie_mask_o          : out   std_logic;
        c1_cmp_o            : out   std_logic;
        c3_cmp_o            : out   std_logic;
        load_from_type_o    : out   std_logic;
        c1to3_cmp_o         : out   std_logic;
        c2to5_cmp_o         : out   std_logic;
        reg_type_addr_o     : out   std_logic_vector(11 downto 0);
        reg_type_addr_sel   : out   std_logic;
        latch_epc_load_o    : out   std_logic;
        is_start_of_int_o   : out   std_logic;

        int_if_id_flush_req_o : out std_logic;
        int_id_ex_flush_req_o : out std_logic
    );
end interrupt_handler;

architecture struct of interrupt_handler is
-- signals declerations
    signal icc_s            : std_logic_vector(2 downto 0);
    -- signal inta_proc1_s, inta_proc2_s, inta_proc3_s: std_logic;

    signal gie_mask_s: std_logic;
    signal c1_cmp_s, c2_cmp_s, c3_cmp_s, c4_cmp_s, c5_cmp_s: std_logic;


begin
-- interrupt cycle counter FSM (ICC)
    process(rst_i, clk_i)
    begin
        if (rst_i = '1') then
            icc_s <= "000";
            int_ack_o <= '1';
            gie_mask_s <= '1';
            reg_type_addr_sel <= '0';
        elsif rising_edge(clk_i) then
            if reti_ctl_i = '1' then
                gie_mask_s <= '1';
            end if;
            case icc_s is
                when "000" => 
                    if (intr_i = '1') then
                        icc_s <= "001";
                        int_ack_o <= '0';
                    end if;
                when "001" => 
                    gie_mask_s <= '0';
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
                    if (gie_mask_s = '1') then
                        if (intr_i = '1') then
                            icc_s <= "001";
                            int_ack_o <= '0';
                        else
                            icc_s <= "000";
                        end if;
                    end if;
                when others =>
                    icc_s <= "000";
            end case;
        end if;
    end process;


-- outputs assignments
    gie_mask_o  <= gie_mask_s;
    c1_cmp_s    <= '1' when (icc_s = "001") else '0';
    c2_cmp_s    <= '1' when (icc_s = "010") else '0';
    c3_cmp_s    <= '1' when (icc_s = "011") else '0';
    c4_cmp_s    <= '1' when (icc_s = "100") else '0';
    c5_cmp_s    <= '1' when (icc_s = "101") else '0';

    int_if_id_flush_req_o <= c1_cmp_s or c2_cmp_s or c3_cmp_s;
    int_id_ex_flush_req_o <= c1_cmp_s;
    latch_epc_load_o <= intr_i;
    load_from_type_o <= c1_cmp_s;
    c1to3_cmp_o <= c1_cmp_s or c2_cmp_s or c3_cmp_s;
    c2to5_cmp_o <= c2_cmp_s or c3_cmp_s or c4_cmp_s or c5_cmp_s;
    c1_cmp_o <= c1_cmp_s;
    c3_cmp_o <= c3_cmp_s;

    reg_type_addr_o <= x"842";
    is_start_of_int_o <= c1_cmp_s;
end struct;
