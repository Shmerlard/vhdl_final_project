library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity stall_controller is
    port( 
        clk_i       : in std_logic;
        rst_i       : in std_logic;

        hazard_if_stall_req : in std_logic;
        hazard_id_stall_req : in std_logic;

        interrupt_if_id_flush_req : in std_logic;
        interrupt_id_ex_flush_req : in std_logic;

        control_if_flush_req: in std_logic;

        if_stall_ctl_o : out std_logic;
        if_id_plr_flsh_ctl_o : out std_logic;
        id_ex_plr_flsh_ctl_o : out std_logic

    );
end stall_controller;

architecture structure of stall_controller is
    signal unified_s: std_logic_vector(2 downto 0);
begin 

    out_proc : process(hazard_if_stall_req, hazard_id_stall_req,
                        control_if_flush_req,
                        interrupt_if_id_flush_req, interrupt_id_ex_flush_req)
    begin
        if interrupt_id_ex_flush_req = '1' and interrupt_if_id_flush_req = '1' then
            unified_s <= "011";
        elsif interrupt_if_id_flush_req = '1' then
            unified_s <= "010";
        elsif hazard_if_stall_req = '1' then
            unified_s <= "110";
        elsif hazard_id_stall_req = '1' then
                unified_s <= "101";
        elsif control_if_flush_req = '1' then
            unified_s <= "010";
        else
            unified_s <= "000";
        end if;
    end process;

    if_stall_ctl_o <= unified_s(2);
    if_id_plr_flsh_ctl_o <= unified_s(1); 
    id_ex_plr_flsh_ctl_o <= unified_s(0); 
end structure;
