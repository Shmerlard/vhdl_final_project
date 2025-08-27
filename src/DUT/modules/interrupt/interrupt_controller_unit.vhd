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
        is_start_of_int_i   : in std_logic;
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
    signal int_req_s : std_logic;
    -- signal ifg_o_s  : std_logic_vector(6 downto 0);
    -- signal ifg_in_from_bus : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    -- signal ifg_in_from_core : std_logic_vector(INT_IFG_COUNT-1 downto 0);
    --
    signal int_en_dff_d_out_s   : std_logic_vector(6 downto 0);
    signal int_en_dff_d_in_s    : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal type_in_s            : std_logic_vector(7 downto 0);
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
        clk_i                 => clk_i,
        rst_i                 => rst_i,
        int_src_from_periph_i => interrupt_src_i,
        data_bus_i            => data_bus_io(6 downto 0),
        inta_i_b              => inta_i,
        eint_i                => int_en_dff_d_out_s,
        is_start_of_int       => is_start_of_int_i,

        gie_i                 => gie_i,
        ifg_cs_write_ctl_i    => cs_mem_write_s(1),
        ifg_o                 => ifg_in_s,
        type_reg_d_in_o       => type_in_s,
        int_req_o             => int_req_s
    );
    int_req_o <= int_req_s;

    -- ifg_dff: entity work.nbit_dff
    -- generic map( n => 7)
    -- port map(
    --     clk => clk_i,
    --     rst => rst_i,
    --     en => '1',
    --     d_in => ifg_in_s,
    --     q_out => ifg_o_s
    -- );
    ifg_dff_bidir: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH )
    port map(
        Dout => x"000000" & '0' & ifg_in_s,            -- TODO: implement write to ifg reg
        en => cs_mem_read_s(1),
        IOpin => data_bus_io
    );

    int_en_dff: entity work.nbit_dff
    generic map( n => 7 )
    port map(
        clk => clk_i,
        rst => rst_i,
        en => cs_mem_write_s(0),
        d_in => int_en_dff_d_in_s(6 downto 0),
        q_out => int_en_dff_d_out_s
    );
    int_en_bidir: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => x"000000" & '0' & int_en_dff_d_out_s,
        en => cs_mem_read_s(0),
        Din => int_en_dff_d_in_s,
        IOpin => data_bus_io
    );

    type_dff: entity work.nbit_dff
    generic map( n => 8 )
    port map(
        clk => clk_i,
        rst => rst_i,
        -- en => '1',
        en => int_req_s,
        d_in => type_in_s,
        q_out => type_out_s
    );
    type_bidir: entity work.nbit_bidir
    generic map( width => DATA_BUS_WIDTH)
    port map(
        Dout => x"000000" & type_out_s,
        en => cs_mem_read_s(2),
        IOpin => data_bus_io
    );


end architecture rtl;

