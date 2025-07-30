library IEEE;
use ieee.std_logic_1164.all;
use work.aux_package.all;

package memory_map is
    type Reg_Name is (
        PORT_LEDR, PORT_HEX0, PORT_HEX1,
        PORT_HEX2, PORT_HEX3, PORT_HEX4,
        PORT_HEX5, PORT_SW,   PORT_KEY,

        UTCTL, RXBF, TXBF,
        BTCTL, BTCNT, BTCCR0, BTCCR1,
        FIRCTL, FIRIN, FIROUT, COEF3_0, COEF7_4,
        IE, IFG, TYPE_REG
    );
    type Reg_Addr_Array is array(Reg_Name) of NATURAL;

    constant REG_ADDR : Reg_Addr_Array := (
        PORT_LEDR => 16#800#,
        PORT_HEX0 => 16#804#,
        PORT_HEX1 => 16#805#,
        PORT_HEX2 => 16#808#,
        PORT_HEX3 => 16#809#,
        PORT_HEX4 => 16#80C#,
        PORT_HEX5 => 16#80D#,
        PORT_SW   => 16#810#,
        PORT_KEY  => 16#814#,

        UTCTL     => 16#818#,
        RXBF      => 16#819#,
        TXBF      => 16#81A#,

        BTCTL     => 16#81C#,
        BTCNT     => 16#820#,
        BTCCR0    => 16#824#,
        BTCCR1    => 16#824#,

        FIRCTL    => 16#82C#,
        FIRIN     => 16#830#,
        FIROUT    => 16#834#,
        COEF3_0   => 16#838#,
        COEF7_4   => 16#83C#,

        IE        => 16#840#,
        IFG       => 16#841#,
        TYPE_REG  => 16#842#
    );
    constant TIMER_UNIT_ADDRESS_ARRAY : t_addr_array := (
        REG_ADDR(BTCTL),
        REG_ADDR(BTCNT),
        REG_ADDR(BTCCR0),
        REG_ADDR(BTCCR1)
    );
    constant FIR_UNIT_ADDRESS_ARRAY : t_addr_array := (
        REG_ADDR(FIRCTL),
        REG_ADDR(FIRIN),
        REG_ADDR(FIROUT),
        REG_ADDR(COEF3_0),
        REG_ADDR(COEF7_4)
    );
end memory_map;
