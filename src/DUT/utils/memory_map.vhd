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
    constant GPIO_UNIT_ADDRESS_ARRAY: t_addr_array := (
        REG_ADDR(PORT_LEDR),
        REG_ADDR(PORT_HEX0),
        REG_ADDR(PORT_HEX1),
        REG_ADDR(PORT_HEX2),
        REG_ADDR(PORT_HEX3),
        REG_ADDR(PORT_HEX4),
        REG_ADDR(PORT_HEX5),
        REG_ADDR(PORT_SW)
        -- REG_ADDR(PORT_KEY)
    );
    constant TIMER_UNIT_ADDRESS_ARRAY : t_addr_array := (
        REG_ADDR(BTCTL), -- 0x81C
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
    constant INT_UNIT_ADDRESS_ARRAY: t_addr_array := (
        REG_ADDR(IE),
        REG_ADDR(IFG),
        REG_ADDR(TYPE_REG)
    );











    -----------------------------------------------
    -- BTCTL pinout
    type t_btctl_bits is (
        BTOUTMD, BTOUTEN, BTHOLD, BTSSEL_1, BTSSEL_0,
        BTCLR, BTIP_1, BTIP_0);
    type t_btctl_bits_array is array(t_btctl_bits) of natural;
    constant BTCTL_BITS : t_btctl_bits_array := (
    BTOUTMD   => 7,
    BTOUTEN   => 6,
    BTHOLD    => 5,
    BTSSEL_1  => 4,
    BTSSEL_0  => 3,
    BTCLR     => 2,
    BTIP_1    => 1,
    BTIP_0    => 0);

    -----------------------------------------------
    type t_firctl_bits is (
        FIFOWEN, FIFORST, FIFOFULL, FIFOEMPTY,
        FIRRST, FIRENA);
    type t_firctl_bits_array is array(t_firctl_bits) of natural;
    constant FIRCTL_BITS : t_firctl_bits_array := (
        FIFOWEN    => 5,
        FIFORST    => 4,
        FIFOFULL   => 3,
        FIFOEMPTY  => 2,
        FIRRST     => 1,
        FIRENA     => 0
    );
    -----------------------------------------------
    type t_ie_bits is (
        FIRIE, KEY3IE, KEY2IE, KEY1IE,
        BTIE, TXIE, RXIE);
    type t_ie_bits_array is array(t_ie_bits) of natural;
    constant IE_BITS : t_ie_bits_array := (
    FIRIE   => 6,
    KEY3IE  => 5,
    KEY2IE  => 4,
    KEY1IE  => 3,
    BTIE    => 2,
    TXIE    => 1,
    RXIE    => 0);
    -----------------------------------------------
    type t_ifg_bits is (
        FIRIFG, KEY3IFG, KEY2IFG, KEY1IFG,
        BTIFG, TXIFG, RXIFG);
    type t_ifg_bits_array is array(t_ifg_bits) of natural;
    constant IFG_BITS : t_ifg_bits_array := (
    FIRIFG   => 6,
    KEY3IFG  => 5,
    KEY2IFG  => 4,
    KEY1IFG  => 3,
    BTIFG    => 2,
    TXIFG    => 1,
    RXIFG    => 0);
end package memory_map;
