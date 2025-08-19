library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity interrupt_handler is
    generic(data_bus_width := 32);
    port(
        clk_i               : in    std_logic;
        rst_i               : in    std_logic;
        intr_i              : in    std_logic;
        reti_ctl_i          : in    std_logic;
        instruction_id_i    : in    std_logic_vector(data_bus_width-1 downto 0);
        c1_cmp_o            : out   std_logic;
        c3_cmp_o            : out   std_logic;
        c1to3_cmp_o         : out   std_logic;
        c2to5_cmp_o         : out   std_logic;
    );
end interrupt_handler;

architecture struct of interrupt_handler is
-- signals declerations
    signal icc_s            : std_logic_vector(2 downto 0);

begin
-- interrupt cycle counter FSM (ICC)
    process(rst_i, clk_i)
    begin
        if (rst_i = '1') then
            icc_s <= "000";
        elsif rising_edge(clk_i) then
            case icc_s is
                when "000" => 
                    if (intr_i = '1') then
                        icc_s <= "001";
                    end if;
                when "001" => 
                    icc_s <= "010";
                when "010" => 
                    icc_s <= "011";
                when "011" => 
                    icc_s <= "100";
                when "100" => 
                    icc_s <= "101";
                when "101" => 
                    if (reti_ctl_i = '1') then
                        icc_s <= "110";
                    end if;
                when "110" => 
                    icc_s <= "000";
            end case;
        end if;
    end process;

-- outputs assignments
    c1_cmp_o    <= '1' when (icc_s = "001") else '0';
    c3_cmp_o    <= '1' when (icc_s = "011") else '0';
    c1to3_cmp_o <= '1' when ((icc_s > "000") and (icc_s < "100")) else '0';
    c2to5_cmp_o <= '1' when ((icc_s > "001") and (icc_s < "110")) else '0';
end struct;
