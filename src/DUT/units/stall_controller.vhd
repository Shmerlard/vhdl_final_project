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

        interrupt_if_stall_req : in std_logic;
        interrupt_id_stall_req : in std_logic;

        if_stall_ctl_o : out std_logic;
        if_id_plr_flsh_ctl_o : out std_logic;
        id_ex_plr_flsh_ctl_o : out std_logic

    );
end stall_controller;

architecture structure of stall_controller is
begin 

    out_proc : process(hazard_if_stall_req, hazard_id_stall_req)
    begin
        if hazard_if_stall_req = '1' then
            if_stall_ctl_o <= '1';
            if_id_plr_flsh_ctl_o <= '1';
            id_ex_plr_flsh_ctl_o <= '0';
        elsif hazard_id_stall_req = '1' then
            if_stall_ctl_o <= '1';
            if_id_plr_flsh_ctl_o <= '1';
            id_ex_plr_flsh_ctl_o <= '1';
        else
            if_stall_ctl_o <= '0';
            if_id_plr_flsh_ctl_o <= '0';
            id_ex_plr_flsh_ctl_o <= '0';
        end if;
    end process;
end structure;
