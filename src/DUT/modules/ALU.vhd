library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    generic(n : integer := 32);
    port(
        y, x        : in    std_logic_vector(n-1 downto 0);
        alufn       : in    std_logic_vector(4 downto 0);
        aluout      : out   std_logic_vector(n-1 downto 0);
        zflag       : out   std_logic
    );
end ALU;

architecture behaioral of ALU is
    signal zeros : std_logic_vector(n-1 downto 0) := (others => '0'); 
    signal aluout_w : std_logic_vector(n-1 downto 0);
    begin
        process(y, x, alufn)
        variable shamt : integer;
        begin 
            -- shamt := conv_integer(y);

            shamt := to_integer(unsigned(y));
            case alufn is
                when "01000" => aluout_w <= STD_LOGIC_VECTOR(signed(y) + signed(x));
                when "01001" => aluout_w <= STD_LOGIC_VECTOR(signed(y) - signed(x));
                when "11001" => aluout_w <= y or x;
                when "11010" => aluout_w <= y and x;
                when "11011" => aluout_w <= y xor x;
                when "10000" => aluout_w <= std_logic_vector(unsigned(x) sll shamt);
                when "10001" => aluout_w <= std_logic_vector(unsigned(x) srl shamt);
                when "00000" | "00001" | "00010" | "00011" | "00100" | "00101" | "00110" | "00111" => aluout_w <= std_logic_vector(signed(y(15 downto 0)) * signed(x(15 downto 0)));
                when others => aluout_w <= (others => '0');
            end case;
        end process;

    -- mul_res <= y(15 downto 0) * x(15 downto 0);
    aluout  <= aluout_w;
    zflag   <= '1' when (aluout_w = zeros) else '0';
    end behaioral;
