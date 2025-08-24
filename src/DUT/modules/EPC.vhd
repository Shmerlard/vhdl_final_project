library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity epc is
    generic( next_pc_width : natural := 8 );
    port (
        clk_i           : in    std_logic;
        rst_i           : in    std_logic;
        ex_jump_ctl_i   : in    std_logic;
        -- ex_j_ctl_i      : in    std_logic;
        -- ex_jr_ctl_i     : in    std_logic;
        ex_branch_ctl_i : in    std_logic;
        epc_capture_i   : in    std_logic;
        id_pc_i         : in    std_logic_vector(next_pc_width-1 downto 0);
        ret_pc_o        : out   std_logic_vector(next_pc_width-1 downto 0)
    );
end entity epc;


architecture rtl of epc is
-- signals declaration
    signal  id_pc_s         : std_logic_vector(next_pc_width-1 downto 0);
    signal  ex_pc_s         : std_logic_vector(next_pc_width-1 downto 0);
    signal  ret_pc_din_s    : std_logic_vector(next_pc_width-1 downto 0);
    signal  alt_pc_sel_s    : std_logic;

begin
    id_pc_s     <= id_pc_i;

    -- import previous pc for interrupt after jump/branch
        ex_pc_import: nbit_dff
        generic map(n => next_pc_width)
        port map(
            clk     => clk_i,
            rst     => rst_i,
            en      => '1',
            d_in    => id_pc_s,
            q_out   => ex_pc_s
        );

    -- alternative pc selection logic
        alt_pc_sel_s <= ex_jump_ctl_i or ex_branch_ctl_i;

    -- output mux
        ret_pc_din_s <= ex_pc_s when (alt_pc_sel_s = '1') else id_pc_s;

    -- save return pc
        saved_ret_pc: nbit_dff
        generic map(n => next_pc_width)
        port map(
            clk     => epc_capture_i,
            rst     => rst_i,
            en      => '1',
            d_in    => ret_pc_din_s,
            q_out   => ret_pc_o
        );

    
end architecture rtl;
