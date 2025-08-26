library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_unit is
    generic(
        w: integer := 24;
        m: integer := 8;
        q: integer := 8;
        k: integer := 32;
        k_log: integer := 3                -- TODO: check this number
    );
    port (
        clk_i   : in STD_LOGIC;
        rst_i   : in STD_LOGIC;
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
end entity fir_unit;

architecture rtl of fir_unit is
    signal FIRIN_qout_s     :   STD_LOGIC_VECTOR(w+q-1 downto 0);
    signal COEF_I_qout_s    :   t_vec_array(0 to M-1)(q-1 downto 0);
    signal FIROUT_qout_s    :   STD_LOGIC_VECTOR(w+q-1 downto 0);

    begin
    -- FIRIN Register
        FIRIN_register: entity work.nbit_dff
        generic map(n => w+q)
        port map(
            clk     => clk_i,
            rst     => rst_i,
            en      => '1',
            d_in    => FIRIN,
            q_out   => FIRIN_qout_s
        );

    -- FIROUT Register
        FIROUT_register: entity work.nbit_dff
        generic map(n => w+q)
        port map(
            clk     => clk_i,
            rst     => rst_i,
            en      => '1',
            d_in    => FIROUT,
            q_out   => FIROUT_qout_s
        );
    
    -- COEF_I Registers
        generate_coefs_registers: for i in 0 to M-1 generate
            COEF_I_register: entity work.nbit_dff
            generic map(n => q)
            port map(
                clk     => clk_i,
                rst     => rst_i,
                en      => '1',
                d_in    => COEF_I(i),
                q_out   => COEF_I_qout_s(i)
            );
        end generate;

    -- Core Instantiation
        FIR_core: entity work.fir_core
            generic map(
                w       => w,
                m       => m,
                q       => q,
                k       => k,
                k_log   => k_log                -- TODO: check this number
            )
            port map(
                FIFOCLK     => FIFOCLK,
                FIFORST     => FIFORST,
                FIFOWEN     => FIFOWEN,

                FIRCLK      => FIRCLK,
                FIRRST      => FIRRST,
                FIRENA      => FIRENA,

                FIRIN       => FIRIN,
                COEF_I      => COEF_I,

                FIFOFULL    => FIFOFULL,
                FIFOEMPTY   => FIFOEMPTY,
                FIRIFG      => FIRIFG,

                FIROUT      => FIROUT
            );
end architecture rtl;