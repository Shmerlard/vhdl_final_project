library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_sync_fifo_tb is
end;

architecture tb of fir_sync_fifo_tb is

    constant w      : integer := 24;
    constant k      : integer := 8;
    constant k_log  : integer := 3;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal wen      : std_logic := '0';
    signal ren      : std_logic := '0';
    signal datain   : std_logic_vector(w-1 downto 0) := (others => '0');
    signal dataout  : std_logic_vector(w-1 downto 0);
    signal full     : std_logic;
    signal empty    : std_logic;

    component fir_sync_fifo
        generic(w: integer; q: integer; k: integer; k_log: integer);
        port (
            FIFOCLK   : in  std_logic;
            FIFORST   : in  std_logic;
            FIFOWEN   : in  std_logic;
            FIFOREN   : in  std_logic;
            FIFOIN    : in  std_logic_vector(w-1 downto 0);
            FIFOFULL  : out std_logic;
            FIFOEMPTY : out std_logic;
            DATAOUT   : out std_logic_vector(w-1 downto 0)
        );
    end component;

begin

    UUT: fir_sync_fifo
        generic map(w => w, q => 8, k => k, k_log => k_log)
        port map (
            FIFOCLK   => clk,
            FIFORST   => rst,
            FIFOWEN   => wen,
            FIFOREN   => ren,
            FIFOIN    => datain,
            FIFOFULL  => full,
            FIFOEMPTY => empty,
            DATAOUT   => dataout
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
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
