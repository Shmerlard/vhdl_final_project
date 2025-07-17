library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_mod is
    generic(
        w: integer := 24;
        m: integer := 8;
        q: integer := 8;
        k: integer := 32                -- TODO: check this number
    );
    port (
        FIFOCLK : in STD_LOGIC;
        FIFORST : in STD_LOGIC;
        FIFOWEN : in STD_LOGIC;
        FIFOREN : in STD_LOGIC;

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
end entity fir_mod;

ARCHITECTURE rtl OF fir_mod IS
    signal syn_fifo_d_s : STD_LOGIC_VECTOR(w+q-1 downto 0);
BEGIN
    fir_reg_arr_inst: fir_reg_arr
    generic map
    (
        w => w,
        m => m,
        q => q
    )
    port map
    (
        clk_i => FIRCLK,
        rst_i => FIRRST,
        x_i => syn_fifo_d_s,
        coeff_i => COEF_I,
        y_o => FIROUT
    );

    fir_sync_fifo_inst: fir_sync_fifo
    generic map
    ( w => w, q => q, k => k)
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
END ARCHITECTURE rtl;
