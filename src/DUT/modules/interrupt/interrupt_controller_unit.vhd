library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;
use work.const_package.all;
use work.memory_map.all;

entity interrupt_controller_unit is
    generic (
        ADDRESS_BUS_WIDTH: INTEGER := 12;                                       -- the width of the address bus
        DATA_BUS_WIDTH: INTEGER := 32;                                          -- width of the data bus
        INT_UNIT_ADDRESS_ARRAY : t_addr_array := INT_UNIT_ADDRESS_ARRAY;
        INT_SRC_COUNT: NATURAL := 9;
        INT_IFG_COUNT: NATURAL := 7
    );
    port 
    (
        clk_i               : in std_logic;
        rst_i               : in std_logic;
        inta_i              : in std_logic;
        interrupt_src_i     : in std_logic_vector(8 downto 0);
        -- reti_i              : in std_logic;
        gie_i               : in std_logic;

        mem_write_c_i       : in std_logic;             -- '1' when we want to write to the registers
        mem_read_c_i        : in std_logic;             -- '1' when we want to read from the registers

        address_bus_i       : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
        data_bus_io         : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);

        int_req_o           : out std_logic
    );
end entity interrupt_controller_unit;


architecture rtl of interrupt_controller_unit is
    signal cs_mem_write_s   : std_logic_vector(INT_UNIT_ADDRESS_ARRAY'length - 1 downto 0);
    signal cs_mem_read_s    : std_logic_vector(INT_UNIT_ADDRESS_ARRAY'length - 1 downto 0);
    --
    signal ifg_in_s : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    signal ifg_o_s  : std_logic_vector(7 downto 0);
    --
    signal int_en_dff_d_out_s   : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    signal int_en_dff_d_in_s    : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    signal type_in_s            : std_logic_vector(6 downto 0);
    signal type_out_s           : std_logic_vector(7 downto 0);
    -- signal icc_s                : std_logic_vector(2 downto 0);
begin
    int_ctrl_address_decoder: entity work.address_decoder
    generic map(
        ADDRESS_BUS_WIDTH => ADDRESS_BUS_WIDTH,
        ADDRESS_ARRAY =>INT_UNIT_ADDRESS_ARRAY 
    )
    port map
    (
        mem_write_c_in => mem_write_c_i,
        mem_read_c_in => mem_read_c_i,
        address_bus_i => address_bus_i,
        cs_mem_write_o => cs_mem_write_s,
        cs_mem_read_o => cs_mem_read_s
    );

    int_ctrl_core_inst: entity work.interrupt_controller_core
    generic map(
        INT_SRC_COUNT => INT_SRC_COUNT,
        INT_IFG_COUNT => INT_IFG_COUNT
    )
    port map(
        clk_i           => clk_i,
        rst_i           => rst_i,
        inta_i_b        => inta_i,
        interrupt_src_i => interrupt_src_i,
        eint_i          => int_en_dff_d_out_s,
        gie_i           => gie_i,
        ifg_o           => ifg_in_s,
        type_reg_d_in_o => type_in_s,
        int_req_o       => int_req_o
    );

    ifg_dff: entity work.nbit_dff
    generic map( n => 8)
    port map(
        clk => clk_i,
        rst => rst_i,
        en => '1',
        d_in => ifg_in_s,
        q_out => ifg_o_s
    );
    ifg_dff_bidir: entity work.nbit_bidir
    generic map( width => 8 )
    port map(
        Dout => ifg_o_s,            -- TODO: implement write to ifg reg
        en => cs_mem_read_s(1),
        IOpin => data_bus_io
    );

    int_en_dff: entity work.nbit_dff
    generic map( n => 8 )
    port map(
        clk => clk_i,
        rst => rst_i,
        en => cs_mem_write_s(0),
        d_in => int_en_dff_d_in_s,
        q_out => int_en_dff_d_out_s
    );
    int_en_bidir: entity work.nbit_bidir
    generic map( width => 8)
    port map(
        Dout => int_en_dff_d_out_s,
        en => cs_mem_read_s(0),
        Din => int_en_dff_d_in_s,
        IOpin => data_bus_io
    );

    type_dff: entity work.nbit_dff
    generic map( n => 8 )
    port map(
        clk => clk_i,
        rst => rst_i,
        en => '1',
        d_in => type_in_s,
        q_out => type_out_s
    );
    type_bidir: entity work.nbit_bidir
    generic map( width => 8)
    port map(
        Dout => type_out_s,
        en => cs_mem_read_s(2),
        IOpin => data_bus_io
    );


end architecture rtl;

