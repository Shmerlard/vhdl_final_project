library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_sync_fifo is
    generic(
        w: integer := 24;
        -- q: integer := 8;
        k: integer := 8;
        k_log: integer := 3
    );
    port (
        FIFOCLK : in STD_LOGIC;
        FIFORST : in STD_LOGIC;
        FIFOWEN : in STD_LOGIC;
        FIFOREN : in STD_LOGIC;

        FIFOIN : in STD_LOGIC_VECTOR(w-1 downto 0);

        FIFOFULL : out STD_LOGIC;
        FIFOEMPTY : out STD_LOGIC;

        DATAOUT     : out STD_LOGIC_VECTOR(w-1 downto 0)
    );
end entity fir_sync_fifo;

ARCHITECTURE rtl OF fir_sync_fifo IS
    signal reg_data_o_arr_s: t_vec_array(0 to k-1)(w-1 downto 0);
    signal reg_wr_en_s: STD_LOGIC_VECTOR(k-1 downto 0);
    signal wr_ptr_s: STD_LOGIC_VECTOR(k_log-1 downto 0);
    signal rd_ptr_s: STD_LOGIC_VECTOR(k_log-1 downto 0);
    -- signal rd_ptr_latched_s: STD_LOGIC_VECTOR(k_log-1 downto 0);
    signal selected_rd_reg_s: std_logic_vector(k_log-1 downto 0);

    signal used_space_cnt_s: std_logic;
    signal used_space_dir_s: std_logic;
    signal used_space_s:     std_logic_vector(k_log-1 downto 0);
BEGIN
    -- registers instantiantion
    reg_arr_gen : for i in 0 to k-1 generate
    begin
        nbit_dff_inst: entity work.nbit_dff
        generic map ( n => w )
        port map
        (
            clk => FIFOCLK,
            rst => FIFORST,
            en => reg_wr_en_s(i),
            d_in => FIFOIN,
            q_out => reg_data_o_arr_s(i)
        );
    end generate;

    -- read and write pointers as counters
    wr_ptr: entity work.nbit_counter                -- NOTE: maybe the entity work... is redundant
    generic map( n => k_log, CNT_ON_RIS_EDG => false)
    port map
    (
        clk_i => FIFOCLK,
        rst => FIFORST,
        en => FIFOWEN,
        equy => '0',                                -- NOTE: we might need to replace it with rst
        q_out => wr_ptr_s,
        w_en_i => '0',
        d_in => (others => '0')
    );
    rd_ptr: entity work.nbit_counter
    generic map( n => k_log, CNT_ON_RIS_EDG => false)
    port map
    (
        clk_i => FIFOCLK,
        rst => FIFORST,
        en => FIFOREN,
        equy => '0',                                -- NOTE: we might need to replace it with rst
        q_out => rd_ptr_s,
        w_en_i => '0',
        d_in => (others => '0')
    );

    latched_rd_ptr: entity work.nbit_dff
     generic map(
        n => k_log
    )
     port map(
        clk => FIFOCLK,
        rst => FIFORST,
        en => FIFOREN,
        d_in => rd_ptr_s,
        q_out => selected_rd_reg_s
    );

    -- decoder for selectign the register to write into
    wr_decoder: entity work.nbit_decoder
    generic map ( n => k_log )
    port map
    (
        d_in => wr_ptr_s,
        out_en => FIFOWEN,
        d_out => reg_wr_en_s
    );

    used_space_ins: entity work.nbit_counter
    generic map( n => k_log )
    port map(
        clk_i => FIFOCLK,
        rst => FIFORST,
        en => used_space_cnt_s,
        cnt_dir => used_space_dir_s,
        equy => '0',
        -- d_in => d_in,
        -- w_en_i => w_en_i,
        q_out => used_space_s
    );

    used_space_cnt_s <= FIFOREN xor FIFOWEN;  -- we change the amount of used space when we only read or only write.
    used_space_dir_s <= FIFOWEN;                -- when we write we count up

    FIFOEMPTY <= '1' when (unsigned(used_space_s) = 0) else '0';
    FIFOFULL  <= '1' when (signed(used_space_s) = -1) else '0';
    -- muxing the output based on read pointer
    DATAOUT <= (others => '0') when FIFOREN else reg_data_o_arr_s(to_integer(unsigned(selected_rd_reg_s)));

END ARCHITECTURE rtl;
