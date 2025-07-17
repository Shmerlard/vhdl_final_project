library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity fir_sync_fifo is
    generic(
        w: integer := 24;
        q: integer := 8;
        k: integer := 8
    );
    port (
        FIFOCLK : in STD_LOGIC;
        FIFORST : in STD_LOGIC;
        FIFOWEN : in STD_LOGIC;
        FIFOREN : in STD_LOGIC;

        FIFOIN : in STD_LOGIC_VECTOR(w+q-1 downto 0);

        FIFOFULL : out STD_LOGIC;
        FIFOEMPTY : out STD_LOGIC;

        DATAOUT     : out STD_LOGIC_VECTOR(w+q-1 downto 0)
    );
end entity fir_sync_fifo;

ARCHITECTURE rtl OF fir_sync_fifo IS
BEGIN
END ARCHITECTURE rtl;
