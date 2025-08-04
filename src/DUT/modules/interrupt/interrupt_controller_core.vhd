library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.const_package.all;
use work.memory_map.all;

entity interrupt_controller_core is
    generic (
        INT_UNIT_ADDRESS_ARRAY : t_addr_array := INT_UNIT_ADDRESS_ARRAY
            );
    port 
    (
        rst_i : in std_logic;
        gie_i : in std_logic;
        interrupt_src_i: in std_logic_vector(7 downto 0);
        eint_i : in std_logic_vector(7 downto 0);

        ifg_o : out std_logic_vector(7 downto 0);
        int_req_o : out std_logic
    );
end entity interrupt_controller_core;


architecture rtl of interrupt_controller_core is
    signal irq_s : std_logic_vector(7 downto 0);
    signal eint_s : std_logic_vector(7 downto 0);
    signal ifg_s: std_logic_vector(7 downto 0);
    signal is_interrupt : std_logic;
begin
    ifg_s <= irq_s and eint_s;
    is_interrupt <= '0' when ifg_s = (others => '0') else '1';
    ifg_o <= ifg_s;

    int_req_o <= gie_i and is_interrupt;

    


end architecture rtl;

