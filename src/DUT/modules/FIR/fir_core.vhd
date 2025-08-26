library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_core is
    generic(
        w: integer := 24;
        m: integer := 8;
        q: integer := 8;
        k: integer := 32;
        k_log: integer := 3                -- TODO: check this number
    );
    port (
        rst_i   : in std_logic;
        FIFOCLK : in STD_LOGIC;
        FIFORST : in STD_LOGIC;
        FIFOWEN : in STD_LOGIC;
        -- FIFOREN : in STD_LOGIC;

        FIRCLK : in STD_LOGIC;
        FIRRST : in STD_LOGIC;
        FIRENA : in STD_LOGIC;

        FIRIN : in STD_LOGIC_VECTOR(w+q-1 downto 0);
        COEF_I : in t_vec_array(0 to M-1)(q-1 downto 0);

        FIFOFULL : out STD_LOGIC;
        FIFOEMPTY : out STD_LOGIC;
        FIRIFG : out STD_LOGIC;

        FIROUT     : out STD_LOGIC_VECTOR(w+q-1 downto 0)
    );
end entity fir_core;

ARCHITECTURE rtl OF fir_core IS
    signal syn_fifo_d_s : STD_LOGIC_VECTOR(w+q-1 downto 0);
    signal FIFOREN : std_logic;

    signal q1_firena : std_logic;
    signal q2_firena : std_logic;
BEGIN
    fir_reg_arr_inst: entity work.fir_reg_arr
    generic map ( w => w, m => m, q => q)
    port map
    (
        clk_i => FIRCLK,
        rst_i => FIRRST,
        fir_en_i => FIRENA,
        x_i => syn_fifo_d_s,
        coeff_i => COEF_I,
        y_o => FIROUT
    );

    fir_sync_fifo_inst: entity work.fir_sync_fifo
    generic map
    ( w => w, k => k, k_log => k_log)
    port map
    (
        FIFOCLK => FIFOCLK,
        FIFORST => FIFORST,
        FIFOWEN => FIFOWEN,
        FIFOREN => FIFOREN,
        FIFOIN => FIRIN,
        FIFOFULL => FIFOFULL,
        FIFOEMPTY => FIFOEMPTY,
        DATAOUT => syn_fifo_d_s
    );

    fir_pulse_sync_inst: entity work.fir_pulse_sync
    port map(
        rst_i => rst_i,
        FIRENA => FIRENA,
        FIRCLK => FIRCLK,
        FIFOCLK => FIFOCLK,
        FIFOREN => FIFOREN
    );


    q1_dff_inst: entity work.nbit_dff
    generic map( n => 1 )
    port map(
        clk => FIRCLK,
        rst => rst_i,
        en => '1',
        d_in(0) => FIRENA,
        q_out(0) => q1_firena
    );
    q2_dff_inst: entity work.nbit_dff
    generic map( n => 1 )
    port map(
        clk => FIRCLK,
        rst => rst_i,
        en => '1',
        d_in(0) => q1_firena,
        q_out(0) => q2_firena
    );


    FIRIFG <= FIRCLK and FIRENA and not q2_firena;
END ARCHITECTURE rtl;
