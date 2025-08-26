library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_core_tb is
end;

architecture tb of fir_core_tb is

    type t_hex_array is array (natural range <>) of std_logic_vector(6 downto 0);

    constant w      : integer := 24;
    constant m      : integer := 8;
    constant q      : integer := 8;
    constant k      : integer := 8;
    constant k_log  : integer := 3;

    constant FIRCLK_p : time := 128 ns;
    constant FIFOCLK_p: time := 10 ns;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal wen      : std_logic := '0';
    signal ren      : std_logic := '0';
    signal datain   : std_logic_vector(w-1 downto 0) := (others => '0');

    signal FIFOCLK, FIFORST, FIFOWEN, FIRCLK, FIRRST, FIRENA : std_logic;
    signal FIRIN    : STD_LOGIC_VECTOR(w+q-1 downto 0);
    signal COEF_I   : t_vec_array(0 to M-1)(q-1 downto 0);
    signal FIFOFULL : STD_LOGIC;
    signal FIFOEMPTY: STD_LOGIC;
    signal FIRIFG   : STD_LOGIC;
    signal FIROUT   : STD_LOGIC_VECTOR(w+q-1 downto 0);

   component fir_core is
        generic(
            w: integer := 24;
            m: integer := 8;
            q: integer := 8;
            k: integer := 32;
            k_log: integer := 3                -- TODO: check this number
        );
        port (
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
    end component fir_core;

begin

    UUT: fir_core
            generic map(
                w       => w,
                m       => m,
                q       => q,
                k       => k,
                k_log   => k_log
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

    -- Clock process
    fifoclk_process : process
    begin
        while true loop
            clk <= '0'; wait for FIFOCLK_p/2;
            clk <= '1'; wait for FIFOCLK_p/2;
        end loop;
    end process;

    firclk_process : process
    begin
        while true loop
            clk <= '0'; wait for FIRCLK_p/2;
            clk <= '1'; wait for FIRCLK_p/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        wait for 20 ns;
        rst <= '0';

        -- Write 3 values
        for i in 0 to 2 loop
            datain <= std_logic_vector(to_unsigned(i * 100, w));
            wen <= '1';
            wait for 10 ns;
            wen <= '0';
            wait for 10 ns;
        end loop;

        -- Wait before reading
        wait for 20 ns;

        -- Read 3 values
        for i in 0 to 2 loop
            ren <= '1';
            wait for 10 ns;
            ren <= '0';
            wait for 10 ns;
        end loop;

        wait;
    end process;

end architecture;
