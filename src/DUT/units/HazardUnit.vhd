library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity hazardunit is
    port( 
        clk_i, rst_i    : in std_logic;
        jr_ctl_i        : in std_logic;
        beq_taken_ctl_i : in std_logic;
        bne_taken_ctl_i : in std_logic;

        id_ex_flush_ctl_i: in std_logic;

        inst_type_i     : in std_logic_vector(2 downto 0);
        rs_rt_rd_i      : in std_logic_vector(14 downto 0);
        rd1_sel_o       : out std_logic_vector(3 downto 0);
        rd2_sel_o       : out std_logic_vector(3 downto 0);
        lw_hazard_rd1_o : out std_logic;
        lw_hazard_rd2_o : out std_logic;
        -- hazard_stall_ctl_o : out std_logic;

        hazard_if_stall_req : out std_logic;
        hazard_id_stall_req: out std_logic;

        jrta_sel_o   : out std_logic
    );
end hazardunit;

architecture structure of hazardunit is
-- signals declarations
    signal rs_id_w, rt_id_w, rd_id_w, rx_id_w   : std_logic_vector(4 downto 0);
    signal ex_rx_w, mem_rx_w, wb_rx_w   : std_logic_vector(4 downto 0);
    signal ex_it_w, mem_it_w, wb_it_w   : std_logic_vector(2 downto 0);
    signal rs_rx_ex_equal_w, rs_rx_mem_equal_w, rs_rx_wb_equal_w    : std_logic;
    signal rt_rx_ex_equal_w, rt_rx_mem_equal_w, rt_rx_wb_equal_w    : std_logic;
    signal lw_hazard_phase_w: integer;
    signal rx_equal_zero_w, lw_hazard1_w, lw_hazard2_w   : std_logic;

    signal lw_hazard_ex: std_logic;        -- we have lw in mem and its hazard
    signal lw_hazard1_mem: std_logic;        -- we have lw in mem and its hazard
    signal lw_hazard2_mem: std_logic;        -- we have lw in mem and its hazard
    signal lw_hazard_mem: std_logic;        -- we have lw in mem and its hazard
    signal read_in_decode: std_logic;

begin 
-- signals assignments
    rs_id_w <= rs_rt_rd_i(14 downto 10);
    rt_id_w <= rs_rt_rd_i(9 downto 5);
    rd_id_w <= rs_rt_rd_i(4 downto 0);

-- choose the correct rx of ID
    with inst_type_i select 
        rx_id_w <= 
            rd_id_w when "000" | "010",
            "00000" when "110" | "111",
            rt_id_w when others;


-- rx dff instantiations
    RX_EX: entity work.nbit_dff_flush
    generic map (
        n => 5
    )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => id_ex_flush_ctl_i,
        en     => '1',
        d_in   => rx_id_w,
        q_out  => ex_rx_w
    );

    RX_MEM: entity work.nbit_dff
    generic map (
        n => 5
    )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => ex_rx_w,
        q_out  => mem_rx_w
    );

    RX_WB: entity work.nbit_dff
    generic map (
        n => 5
    )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => mem_rx_w,
        q_out  => wb_rx_w
    );

-- instruction type dff instantiations

    IT_EX: entity work.nbit_dff_flush
    generic map (
        n => 3
    )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        flush => id_ex_flush_ctl_i,
        en     => '1',
        d_in   => inst_type_i,
        q_out  => ex_it_w
    );

    IT_MEM: entity work.nbit_dff
    generic map (
        n => 3
    )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => ex_it_w,
        q_out  => mem_it_w
    );

    IT_WB: entity work.nbit_dff
    generic map (
        n => 3
    )
    port map (
        clk    => clk_i,
        rst    => rst_i,
        en     => '1',
        d_in   => mem_it_w,
        q_out  => wb_it_w
    );

-- comparators
    rs_rx_ex_equal_w    <= '1' when ((rs_id_w = ex_rx_w)  and not(ex_rx_w = "00000"  )) else '0';
    rs_rx_mem_equal_w   <= '1' when ((rs_id_w = mem_rx_w) and not(mem_rx_w = "00000" )) else '0';
    rs_rx_wb_equal_w    <= '1' when ((rs_id_w = wb_rx_w)  and not(wb_rx_w = "00000"  )) else '0';

    rt_rx_ex_equal_w    <= '1' when ((rt_id_w = ex_rx_w)  and not(ex_rx_w = "00000"  )) else '0';
    rt_rx_mem_equal_w   <= '1' when ((rt_id_w = mem_rx_w) and not(mem_rx_w = "00000" )) else '0';
    rt_rx_wb_equal_w    <= '1' when ((rt_id_w = wb_rx_w)  and not(wb_rx_w = "00000"  )) else '0';

    rx_equal_zero_w     <= '1' when (rx_id_w = "00000") else '0';

-- RD1 selector
    process(rs_rx_ex_equal_w, rs_rx_mem_equal_w, rs_rx_wb_equal_w, inst_type_i, rst_i,
            lw_hazard1_w, ex_it_w, mem_it_w, wb_it_w)
    -- process(clk_i, rst_i)
    begin
        if rst_i = '1' then 
            rd1_sel_o <= "0000";
        else
            if ((rs_rx_ex_equal_w = '1')) then
                if (ex_it_w = "000") then
                    rd1_sel_o <= "0001";        -- V
                elsif (ex_it_w = "001") then
                    rd1_sel_o <= "0001";        -- V
                elsif (ex_it_w = "010") then
                    rd1_sel_o <= "0010";        -- V
                elsif (ex_it_w = "011") then
                    rd1_sel_o <= "0010";        -- V
                elsif (ex_it_w = "100") then
                    rd1_sel_o <= "0011";        -- V
                elsif (ex_it_w = "101") then
                    rd1_sel_o <= "0100"; -- ex_it_w = "101", lw!
                -- elsif (ex_it_w = "110") then
                --     -- rd1_sel_o <= "0100";
                else
                    rd1_sel_o <= "0000";
                end if;
            -- elsif ((rs_rx_ex_equal_w = '1') and (rx_equal_zero_w = '0') and (lw_hazard_w = '1')) then
            --  rd1_sel_o <= "0100";
            elsif ((rs_rx_mem_equal_w = '1')) then
                if (mem_it_w = "000") then
                    rd1_sel_o <= "0101";
                elsif (mem_it_w = "001") then
                    rd1_sel_o <= "0101";
                elsif (mem_it_w = "010") then
                    rd1_sel_o <= "0110";
                elsif (mem_it_w = "011") then
                    rd1_sel_o <= "0110";
                elsif (mem_it_w = "100") then
                    rd1_sel_o <= "0111";
                elsif (mem_it_w = "101") then
                    rd1_sel_o <= "1000"; -- mem_it_w = "101"
                else
                    rd1_sel_o <= "0000";
                end if;
            elsif ((rs_rx_wb_equal_w = '1')) then
                if (wb_it_w = "000") then
                    rd1_sel_o <= "1001";
                elsif (wb_it_w = "001") then
                    rd1_sel_o <= "1001";
                elsif (wb_it_w = "010") then
                    rd1_sel_o <= "1010";
                elsif (wb_it_w = "011") then
                    rd1_sel_o <= "1010";
                elsif (wb_it_w = "100") then
                    rd1_sel_o <= "1011";
                elsif (wb_it_w = "101") then
                    rd1_sel_o <= "1100"; -- wb_it_w = "101"
                else
                    rd1_sel_o <= "0000";
                end if;
            else
                rd1_sel_o <= "0000";
            end if;
        -- end if;
        end if;
    end process;

-- RD2 selector
    process(rt_rx_ex_equal_w, rt_rx_mem_equal_w, rt_rx_wb_equal_w, inst_type_i, rst_i, ex_it_w, mem_it_w, wb_it_w)
    -- process(clk_i, rst_i)
    begin
        if (rst_i = '1') then
            rd2_sel_o <= "0000";
        else
            if ((rt_rx_ex_equal_w = '1')) then
                if (ex_it_w = "000") then
                    rd2_sel_o <= "0001";
                elsif (ex_it_w = "001") then
                    rd2_sel_o <= "0001";
                elsif (ex_it_w = "010") then
                    rd2_sel_o <= "0010";
                elsif (ex_it_w = "011") then
                    rd2_sel_o <= "0010";
                elsif (ex_it_w = "100") then
                    rd2_sel_o <= "0011";
                elsif (ex_it_w = "101") then
                    rd2_sel_o <= "0100"; -- ex_it_w = "101", lw!
                else
                    rd2_sel_o <= "0000";
                end if;
            -- check memory
            elsif ((rt_rx_mem_equal_w = '1')) then
                if (mem_it_w = "000") then
                    rd2_sel_o <= "0101";
                elsif (mem_it_w = "001") then
                    rd2_sel_o <= "0101";
                elsif (mem_it_w = "010") then
                    rd2_sel_o <= "0110";
                elsif (mem_it_w = "011") then
                    rd2_sel_o <= "0110";
                elsif (mem_it_w = "100") then
                    rd2_sel_o <= "0111";
                elsif (mem_it_w = "101") then
                    rd2_sel_o <= "1000"; -- mem_it_w = "101"
                else 
                    rd2_sel_o <= "0000"; -- mem_it_w = "101"
                end if;
            elsif ((rt_rx_wb_equal_w = '1')) then
                if (wb_it_w = "000") then
                    rd2_sel_o <= "1001";
                elsif (wb_it_w = "001") then
                    rd2_sel_o <= "1001";
                elsif (wb_it_w = "010") then
                    rd2_sel_o <= "1010";
                elsif (wb_it_w = "011") then
                    rd2_sel_o <= "1010";
                elsif (wb_it_w = "100") then
                    rd2_sel_o <= "1011";
                elsif (wb_it_w = "101") then
                    rd2_sel_o <= "1100"; -- wb_it_w = "101"
                else 
                    rd2_sel_o <= "0000"; -- wb_it_w = "101"
                end if;
            else
                rd2_sel_o <= "0000";
            end if;
        end if;
    end process;

-- lw hazard handling
    lw_hazard1_w <= '1' when ((ex_it_w = "101") and (rs_rx_ex_equal_w = '1')) else '0';
    lw_hazard2_w <= '1' when ((ex_it_w = "101") and (rt_rx_ex_equal_w = '1')) else '0';
    lw_hazard_ex <= lw_hazard1_w or lw_hazard2_w;

    read_in_decode <= '1' when (jr_ctl_i or beq_taken_ctl_i or bne_taken_ctl_i) else '0';

    -- hazard_stall_ctl_o <= lw_hazard1_w or lw_hazard2_w;

    lw_hazard1_mem <= '1' when (mem_it_w = "101" and rs_rx_mem_equal_w = '1' ) else '0';
    lw_hazard2_mem <= '1' when (mem_it_w = "101" and rt_rx_mem_equal_w = '1' ) else '0';
    lw_hazard_mem <= lw_hazard1_mem or lw_hazard2_mem;


    hazard_id_stall_req <= lw_hazard_ex;
    -- hazard_if_stall_req <= '1' when lw_hazard_mem or (lw_hazard_ex and not read_in_decode) else '0';
    -- hazard_if_stall_req <= '1' when (lw_hazard_mem and read_in_decode) else '0';
    hazard_if_stall_req <= '0';

    jrta_sel_o <= lw_hazard1_mem and jr_ctl_i;



    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            lw_hazard_rd1_o <= '0';
            lw_hazard_rd2_o <= '0';
        elsif rising_edge(clk_i) then
            lw_hazard_rd1_o <= lw_hazard1_w;
            lw_hazard_rd2_o <= lw_hazard2_w;
        end if;
    end process;

end structure;
