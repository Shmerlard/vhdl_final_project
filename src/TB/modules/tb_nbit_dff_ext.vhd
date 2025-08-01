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
    constant IGN_BITS : t_bits_array := (7, 6);
    constant RST_BITS : t_bits_array := (0 => 4);
    signal clk_s     : std_logic;
    signal asc_rst_s : std_logic;
    signal syn_rst_s : std_logic;

BEGIN

    ign_d_in_s(7) <= ign_d_in(1);
    ign_d_in_s(6) <= ign_d_in(0);

    clk_s     <= not clk_i;
    asc_rst_s <= not asc_rst_i;
    syn_rst_s <= not syn_rst_i;
    dff_ins: entity work.nbit_dff_ext
     generic map(
        n => 8
        -- IGN_BITS_ARRAY => IGN_BITS
        -- RST_BITS_ARRAY => RST_BITS
    )
     port map(
        clk_i => clk_s,
        -- asc_rst_i => asc_rst_s,
        -- syn_rst_i => syn_rst_s,
        -- syn_rst_i => '0',
        wr_en_i => wr_en_i,
        d_in => d_in,
        ign_d_in => ign_d_in_s,
        q_out => q_out
    );
END ARCHITECTURE tb;
