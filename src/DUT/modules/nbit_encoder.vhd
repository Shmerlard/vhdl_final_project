
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity nbit_encoder is
    generic( n: integer := 8);
    port (
        d_in : in std_logic
    );
end entity nbit_encoder ;

ARCHITECTURE rtl OF nbit_encoder  IS
BEGIN

    

END ARCHITECTURE rtl;
