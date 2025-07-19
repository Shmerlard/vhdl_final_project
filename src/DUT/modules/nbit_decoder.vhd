library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity nbit_decoder is
    generic( n: integer := 3);
    port (
        d_in : in std_logic_vector(n-1 downto 0);
        out_en: in STD_LOGIC;
        d_out: out STD_LOGIC_VECTOR((2**n)-1 downto 0)              -- TODO: check if legal
    );
end entity nbit_decoder ;

ARCHITECTURE rtl OF nbit_decoder  IS
    signal selected_out_s : STD_LOGIC_VECTOR((2**n)-1 downto 0);
BEGIN
    process(d_in, out_en)
        variable temp : std_logic_vector((2**n)-1 downto 0);
    begin
        temp := (others => '0');
        if out_en = '1' then
            temp(to_integer(unsigned(d_in))) := '1';
        end if;
        selected_out_s <= temp;
    end process;

    d_out <= selected_out_s;

END ARCHITECTURE rtl;
