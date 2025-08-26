-- tb_fir_sync_fifo.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fir_sync_fifo is
end entity;

architecture sim of tb_fir_sync_fifo is
    -- === Parameters (match DUT) ===
    constant W      : integer := 24;
    constant K      : integer := 8;
    constant K_LOG  : integer := 3;

    constant CLK_PERIOD : time := 10 ns;

    -- === DUT signals ===
    signal FIFOCLK    : std_logic := '0';
    signal FIFORST    : std_logic := '0';
    signal FIFOWEN    : std_logic := '0';
    signal FIFOREN    : std_logic := '0';
    signal FIFOIN     : std_logic_vector(W-1 downto 0) := (others => '0');
    signal FIFOFULL   : std_logic;
    signal FIFOEMPTY  : std_logic;
    signal DATAOUT    : std_logic_vector(W-1 downto 0);

begin
    --------------------------------------------------------------------
    -- Clock
    --------------------------------------------------------------------
    clk_gen : process
    begin
        while true loop
            FIFOCLK <= '0';
            wait for CLK_PERIOD/2;
            FIFOCLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    dut: entity work.fir_sync_fifo
        generic map(
            w      => W,
            k      => K,
            k_log  => K_LOG
        )
        port map(
            FIFOCLK    => FIFOCLK,
            FIFORST    => FIFORST,
            FIFOWEN    => FIFOWEN,
            FIFOREN    => FIFOREN,
            FIFOIN     => FIFOIN,
            FIFOFULL   => FIFOFULL,
            FIFOEMPTY  => FIFOEMPTY,
            DATAOUT    => DATAOUT
        );

    --------------------------------------------------------------------
    -- Stimulus + helpers (procedures declared INSIDE the process)
    --------------------------------------------------------------------
    stim : process
        -- Scoreboard (process-local variables are OK to assign inside procedures)
        type slv_array_t is array(natural range <>) of std_logic_vector(W-1 downto 0);
        variable expect_mem : slv_array_t(0 to 255);
        variable exp_rd_idx : integer := 0;
        variable exp_wr_idx : integer := 0;

        -- Write one word (waits if full)
        procedure write_word(d : in std_logic_vector) is
        begin
            -- Wait until not full
            while FIFOFULL = '1' loop
                wait until rising_edge(FIFOCLK);
            end loop;

            -- Drive before the rising edge that performs the write in your DUT
            FIFOIN  <= d;
            FIFOWEN <= '1';
            wait until rising_edge(FIFOCLK);
            FIFOWEN <= '0';

            -- Scoreboard push
            expect_mem(exp_wr_idx) := d;
            exp_wr_idx := exp_wr_idx + 1;
        end procedure;

        -- Read one word and check order (waits if empty)
        procedure read_and_check is
            variable got : std_logic_vector(W-1 downto 0);
            variable exp : std_logic_vector(W-1 downto 0);
        begin
            -- Wait until not empty
            while FIFOEMPTY = '1' loop
                wait until rising_edge(FIFOCLK);
            end loop;

            FIFOREN <= '1';
            wait until rising_edge(FIFOCLK); -- DATAOUT updates on this edge
            FIFOREN <= '0';
            wait for 1 ns;                   -- small settle time

            got := DATAOUT;
            exp := expect_mem(exp_rd_idx);

            assert got = exp
                report "DATA MISMATCH: got=" &
                       integer'image(to_integer(unsigned(got))) &
                       " exp=" &
                       integer'image(to_integer(unsigned(exp))) &
                       " @idx=" & integer'image(exp_rd_idx)
                severity error;

            exp_rd_idx := exp_rd_idx + 1;
        end procedure;

        procedure write_n(n : in integer; base : in integer := 0) is
        begin
            for i in 0 to n-1 loop
                write_word(std_logic_vector(to_unsigned(base + i, W)));
            end loop;
        end procedure;

        procedure read_n(n : in integer) is
        begin
            for i in 1 to n loop
                read_and_check;
            end loop;
        end procedure;

        -- local temps
        variable got, exp : std_logic_vector(W-1 downto 0);
    begin
        ----------------------------------------------------------------
        -- Reset
        ----------------------------------------------------------------
        FIFORST <= '1';
        wait for 3*CLK_PERIOD;
        FIFORST <= '0';
        wait until rising_edge(FIFOCLK);
        report "Reset released";

        wait until rising_edge(FIFOCLK);
        -- Flags may have one-cycle latency due to valid_s logic
        assert FIFOEMPTY = '1' report "NOTE: expected EMPTY after reset" severity note;
        assert FIFOFULL  = '0' report "NOTE: expected not FULL after reset" severity note;

        ----------------------------------------------------------------
        -- Phase 1: Fill exactly K items
        ----------------------------------------------------------------
        report "Phase 1: Filling " & integer'image(K) & " items";
        write_n(K, 0);

        wait until rising_edge(FIFOCLK);
        assert FIFOFULL = '1'
            report "WARN: Expected FULL after K writes (flag latency?)"
            severity warning;

        ----------------------------------------------------------------
        -- Phase 2: Drain K items (order 0..K-1)
        ----------------------------------------------------------------
        report "Phase 2: Draining K items";
        read_n(K);

        wait until rising_edge(FIFOCLK);
        assert FIFOEMPTY = '1'
            report "WARN: Expected EMPTY after draining (flag latency?)"
            severity warning;

        ----------------------------------------------------------------
        -- Phase 3: Wrap-around / interleaving
        ----------------------------------------------------------------
        report "Phase 3: Wrap-around";
        write_n(3, 100);  -- 100,101,102
        read_n(2);        -- 100,101
        write_n(6, 200);  -- 200..205 (now 7 items total)
        read_n(4);        -- 102,200,201,202
        write_n(3, 500);  -- 500,501,502
        -- Drain the rest
        while FIFOEMPTY = '0' loop
            read_and_check;
        end loop;

        ----------------------------------------------------------------
        -- Phase 4: Simultaneous R/W in the same cycle
        ----------------------------------------------------------------
        report "Phase 4: Simultaneous R/W";
        write_n(1, 900);  -- queue has 900

        -- Next cycle: assert both enables; write 901; read 900
        FIFOIN  <= std_logic_vector(to_unsigned(901, W));
        FIFOWEN <= '1';
        FIFOREN <= '1';
        -- Scoreboard also pushes 901 (the new tail)
        expect_mem(exp_wr_idx) := std_logic_vector(to_unsigned(901, W));
        exp_wr_idx := exp_wr_idx + 1;

        wait until rising_edge(FIFOCLK);
        FIFOWEN <= '0';
        FIFOREN <= '0';
        wait for 1 ns;
        -- Check we got 900 on that cycle
        got := DATAOUT;
        exp := expect_mem(exp_rd_idx);
        assert got = exp
            report "DATA MISMATCH on simultaneous R/W (expected previous head)"
            severity error;
        exp_rd_idx := exp_rd_idx + 1;

        -- Now read 901
        read_and_check;

        ----------------------------------------------------------------
        -- Done
        ----------------------------------------------------------------
        wait until rising_edge(FIFOCLK);
        assert FIFOEMPTY = '1' report "NOTE: FIFO EMPTY at end" severity note;

        report "All tests completed successfully." severity note;
        wait for 5*CLK_PERIOD;
        assert false report "TB finished" severity failure;  -- stop sim
    end process;

end architecture sim;
