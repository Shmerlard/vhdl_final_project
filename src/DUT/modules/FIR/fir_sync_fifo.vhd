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
        rst_i   : in std_logic;
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
    signal reg_data_i_arr_s: t_vec_array(0 to k-1)(w-1 downto 0);
    -- signal reg_wr_en_s: std_logic_vector(k-1 downto 0);
    signal wr_ptr_s: std_logic_vector(k_log-1 downto 0);
    signal rd_ptr_s: std_logic_vector(k_log-1 downto 0);

    signal valid_s: std_logic_vector(k-1 downto 0);
    signal ones_s, zeros_s: std_logic_vector(k-1 downto 0);
BEGIN
    -- registers instantiantion
    reg_arr_gen : for i in 0 to k-1 generate
    begin
        nbit_dff_inst: entity work.nbit_dff
        generic map ( n => w )
        port map
        (
            clk => FIFOCLK,
            rst => FIFORST or rst_i,
            en => '1',
            d_in => reg_data_i_arr_s(i),
            q_out => reg_data_o_arr_s(i)
        );
    end generate;

    -- read and write pointers as counters
    wr_ptr: entity work.nbit_counter
    generic map( n => k_log, CNT_ON_RIS_EDG => true)
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
    generic map( n => k_log, CNT_ON_RIS_EDG => true)
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


    -- used_space_ins: entity work.nbit_counter
    -- generic map( n => k_log )
    -- port map(
    --     clk_i => FIFOCLK,
    --     rst => FIFORST,
    --     en => used_space_cnt_s,
    --     cnt_dir => used_space_dir_s,
    --     equy => '0',
    --     -- d_in => d_in,
    --     -- w_en_i => w_en_i,
    --     q_out => used_space_s
    -- );

    -- used_space_cnt_s <= FIFOREN xor FIFOWEN;  -- we change the amount of used space when we only read or only write.
    -- used_space_dir_s <= FIFOWEN;                -- when we write we count up

    -- FIFOEMPTY <= '1' when (unsigned(used_space_s) = 0) else '0';
    -- FIFOFULL  <= '1' when (signed(used_space_s) = -1) else '0';
    -- muxing the output based on read pointer

    process(FIFOCLK, FIFORST)
        variable tmp_arr : t_vec_array(0 to k-1)(w-1 downto 0);
        begin
            if FIFORST = '1' then
                valid_s <= (others => '0');
            elsif rising_edge(FIFOCLK) then
                tmp_arr := reg_data_i_arr_s;  -- copy the whole array
                if FIFOREN = '1' then
                    DATAOUT <= reg_data_o_arr_s(to_integer(unsigned(rd_ptr_s)));
                    valid_s(to_integer(unsigned(rd_ptr_s))) <= '0';
                end if;
                if FIFOWEN = '1' then
                    tmp_arr(to_integer(unsigned(wr_ptr_s))) := FIFOIN;
                    valid_s(to_integer(unsigned(wr_ptr_s))) <= '1';
                end if;

            end if;
        reg_data_i_arr_s <= tmp_arr;
    end process;
    
    zeros_s <= (others => '0');
    ones_s <= (others => '1');
    FIFOFULL <= '1' when valid_s = ones_s else '0';
    FIFOEMPTY <= '1' when valid_s = zeros_s else '0';
    -- DATAOUT <= (others => '0') when FIFOREN else reg_data_o_arr_s(to_integer(unsigned(selected_rd_reg_s)));

END ARCHITECTURE rtl;
