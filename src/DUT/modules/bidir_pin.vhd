library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity nbit_bidir is
    generic( width: integer:=16 );
    port(   Dout:   in      std_logic_vector(width-1 downto 0);
            en:     in      std_logic;
            Din:    out     std_logic_vector(width-1 downto 0);
            IOpin:  inout   std_logic_vector(width-1 downto 0)
    );
end nbit_bidir;

architecture comb of nbit_bidir is
begin 

    Din  <= IOpin;
    IOpin <= Dout when(en='1') else (others => 'Z');

end comb;
