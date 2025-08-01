library ieee;USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.aux_package.all;

entity tb_nbit_dff_ext is
    port(
        clk_i       : in  std_logic;
        asc_rst_i   : in  std_logic;  -- asynchronous reset
        syn_rst_i   : in  std_logic;
        wr_en_i     : in  std_logic;
        d_in        : in  std_logic_vector(7 downto 0);
        ign_d_in    : in  std_logic_vector(1 downto 0);
        q_out       : out std_logic_vector(7 downto 0)
    );
end entity tb_nbit_dff_ext;

ARCHITECTURE tb OF tb_nbit_dff_ext IS
    signal ign_d_in_s : std_logic_vector(7 downto 0) := (others => '0');
    constant IGN_BITS : std_Logic_vector(7 downto 0) := x"30";
    constant RST_BITS : std_Logic_vector(7 downto 0) := x"C0";
    signal clk_s     : std_logic;
    signal asc_rst_s : std_logic;
    signal syn_rst_s : std_logic;

BEGIN

    ign_d_in_s(5) <= ign_d_in(1);
    ign_d_in_s(4) <= ign_d_in(0);

    clk_s     <= not clk_i;
    asc_rst_s <= not asc_rst_i;
    syn_rst_s <= not syn_rst_i;

    dff_ins: entity work.nbit_dff_ext
    generic map(
       n => 8,
       ASYNC_RST => false
       -- IGN_BITS => IGN_BITS,
       -- RST_BITS => RST_BITS
    )
    port map(
        clk_i => clk_s,
        rst_i => asc_rst_s,
        wr_en_i => wr_en_i,
        d_in => d_in,
        ign_d_in => ign_d_in_s,
        q_out => q_out
    );
END ARCHITECTURE tb;
