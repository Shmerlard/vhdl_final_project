LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY control IS
    generic(
        DATA_BUS_WIDTH : natural   := 32
    );
    PORT(
        -- Op              : IN    STD_LOGIC_VECTOR(5 DOWNTO 0);
        -- Funct           : IN    STD_LOGIC_VECTOR(5 DOWNTO 0);
        instruction_i   : in    std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        MemtoReg        : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
        MemWrite        : OUT   STD_LOGIC;
        jump            : OUT   STD_LOGIC;
        beq             : OUT   STD_LOGIC;
        bne             : OUT   STD_LOGIC;
        ALUFN           : OUT   STD_LOGIC_VECTOR(4 DOWNTO 0);
        ALUSrc          : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
        RegDst          : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
        RegWrite        : OUT   STD_LOGIC;
        WDSel           : OUT   STD_LOGIC;
        jr              : OUT   STD_LOGIC;
        lw_o            : OUT   STD_LOGIC;
        sw_o            : OUT   STD_LOGIC;
        Shamt_ctl       : OUT   STD_LOGIC;
        hazard_unit_type_o : out STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
end control;

Architecture dataflow of control is
    -----------------------------------------------------------------
    --                  Signals Declerations
    -----------------------------------------------------------------
    signal  R_type, jump_sig, jal, beq_sig, bne_sig, addi, slti, andi, ori,
            xori, lui, lw, sw, addiu   : STD_LOGIC := '0';
    signal  sll_f, srl_f, mult, add, addu, sub, and_f, or_f, 
            xor_f, slt, jr_sig  : STD_LOGIC := '0';

    signal nop_s: std_logic;
    signal Op, funct: std_logic_vector(5 downto 0);


begin
    -----------------------------------------------------------------
    --                  Signals Assignments
    -----------------------------------------------------------------
    Op      <= instruction_i(DATA_BUS_WIDTH-1 downto 26);
    funct   <= instruction_i(5 downto 0);

    -- nop_s   <= '1' when instruction_i = (others => '0') else '0';
    nop_s   <= '1' when instruction_i = x"00000000" else '0'; -- TODO: find better imple

    R_type  <= '1' when Op = "000000" else '0';
    jump_sig<= '1' when Op = "000010" else '0';
    jal     <= '1' when Op = "000011" else '0';
    beq_sig <= '1' when Op = "000100" else '0';
    bne_sig <= '1' when Op = "000101" else '0';
    addi    <= '1' when Op = "001000" else '0';
    slti    <= '1' when Op = "001010" else '0';
    andi    <= '1' when Op = "001100" else '0';
    ori     <= '1' when Op = "001101" else '0';
    xori    <= '1' when Op = "001110" else '0';
    lui     <= '1' when Op = "001111" else '0';
    lw      <= '1' when Op = "100011" else '0';
    sw      <= '1' when Op = "101011" else '0';
    addiu   <= '1' when Op = "001001" else '0';
    mult    <= '1' when Op = "011100" else '0';

    -- R-type Instructions
    sll_f   <= '1' when ((Funct = "000000") and (R_type = '1') and (nop_s = '0')) else '0';
    srl_f   <= '1' when ((Funct = "000010") and (R_type = '1')) else '0';
    jr_sig  <= '1' when ((Funct = "001000") and (R_type = '1')) else '0';
    add     <= '1' when ((Funct = "100000") and (R_type = '1')) else '0';
    addu    <= '1' when ((Funct = "100001") and (R_type = '1')) else '0';
    sub     <= '1' when ((Funct = "100010") and (R_type = '1')) else '0';
    and_f   <= '1' when ((Funct = "100100") and (R_type = '1')) else '0';
    or_f    <= '1' when ((Funct = "100101") and (R_type = '1')) else '0';
    xor_f   <= '1' when ((Funct = "100110") and (R_type = '1')) else '0';
    slt     <= '1' when ((Funct = "101010") and (R_type = '1')) else '0';

    -----------------------------------------------------------------
    --                  Controls Configuration
    -----------------------------------------------------------------
    -- MemtoReg Configuration
    process(addi, addiu, andi, ori, xori, sll_f, srl_f, mult, add, addu, sub, and_f, or_f, xor_f, lw, slti, slt, lui)
    begin
        if lw = '1' then
            MemtoReg <= "01";
        elsif (slti = '1' or slt = '1') then
            MemtoReg <= "10";
        elsif lui = '1' then
            MemtoReg <= "11";
        else
            MemtoReg <= "00";  -- Default value (RegWrite control makes it ok)
            -- if ((addiu, addi or andi or ori or xori or sll_f or srl_f or 
            -- mult or add or addu or sub or and_f or or_f or xor_f) = '1') then
            -- MemtoReg <= "00";
        end if;
    end process;

    -- MemWrite Configuration
    MemWrite    <=  sw;

    -- Jump Configuration
    jump        <=  jump_sig or jal;
    
    -- Beq Configuration
    Beq         <= beq_sig;

    -- Bne Configuration
    Bne         <= bne_sig;

    -- ALUFN Configuration
    process(mult, jal, beq_sig, bne_sig, addi, addiu, slti, slt, add, addu, sub, sll_f, srl_f, lui, andi, ori, xori, and_f, or_f, xor_f, sw, lw)
        variable ALU_Mod_v : STD_LOGIC_VECTOR(1 DOWNTO 0);
        variable ALU_CTL_v : STD_LOGIC_VECTOR(2 DOWNTO 0);
    begin
        -- Default assignments to avoid latches
        ALU_Mod_v := "00";
        ALU_CTL_v := "000";
    
        -- ALU_Mod Logic
        if mult = '1' then
            ALU_Mod_v := "00";  -- Multiplier
        elsif (jal or beq_sig or bne_sig or addi or addiu or sw or
              slt or slti or add or addu or sub or lw) = '1' then
            ALU_Mod_v := "01";  -- Adder/Subtractor
        elsif (sll_f or srl_f or lui) = '1' then
            ALU_Mod_v := "10";  -- Shifter
        elsif (andi or ori or xori or 
              and_f or or_f or xor_f) = '1' then
            ALU_Mod_v := "11";  -- Logic Operations
        end if;
    
        -- ALU_CTL Logic
        if (jal or addi or addiu or sw or add or addu or 
           lui or sll_f or lw) = '1' then
            ALU_CTL_v := "000";  -- Add / SHL
        elsif (beq_sig or bne_sig or slti or 
              sub or slt or 
              srl_f or ori or or_f) = '1' then
            ALU_CTL_v := "001";  -- Subtract / SHR / OR
        elsif (andi or and_f) = '1' then
            ALU_CTL_v := "010";  -- AND
        elsif (xori or xor_f) = '1' then
            ALU_CTL_v := "011";  -- XOR
        end if;
    
        -- Assign final ALUFN value
        ALUFN(4 downto 3) <= ALU_Mod_v;
        ALUFN(2 downto 0) <= ALU_CTL_v;
    end process;

    -- ALUSrc Configuration
    process(beq_sig, bne_sig, sll_f, srl_f, Mult, add, sub, and_f, or_f, xor_f, slt, 
        addi, addiu, slti, sw, andi, ori, xori, addu, lw)
    begin
        -- Default assignment to avoid latches
        ALUSrc <= "00";  -- Set a default value for ALUSrc

        -- ALUSrc Logic
        if (beq_sig or bne_sig or sll_f or srl_f or 
            Mult or add or addu or sub or and_f or or_f or 
            xor_f or slt) = '1' then
            ALUSrc <= "00";  -- For beq, bne, R-type and similar instructions
        elsif (addi or addiu or slti or lw or sw) = '1' then
            ALUSrc <= "01";  -- For addi, slti, sw instructions
        elsif (andi or ori or xori) = '1' then
            ALUSrc <= "10";  -- For andi, ori, xori instructions
        else
            ALUSrc <= "11";  
        end if;
    end process;
    
    -- RegDst Configuration
    process(addi, addiu, slti, andi, ori, xori, lui, lw, sll_f, srl_f, mult, add, addu, sub, 
        and_f, or_f, xor_f, slt, jal)
    begin
        -- Default assignment to avoid latches
        RegDst <= "00";  -- Default value

        -- RegDst Logic
        if (addi or addiu or slti or andi or ori or xori or 
            lui or lw) = '1' then
            RegDst <= "00";  -- For I-type instructions and lw
        elsif (sll_f or srl_f or mult or add or addu or 
            sub or and_f or or_f or xor_f or slt) = '1' then
            RegDst <= "01";  -- For R-type instructions
        elsif jal = '1' then
            RegDst <= "10";  -- For jal instruction
        end if;
    end process;

    -- hazard unit types
    process(R_type, addi, andi, ori, xori, addu, addiu, lw, lui, slt, slti, mult, beq, bne)
    begin
        if (((R_type and not(slt)) = '1') or (mult = '1')) then
            hazard_unit_type_o <= "000";
        elsif ((addi or andi or ori or xori or addu or addiu) = '1') then 
            hazard_unit_type_o <= "001";
        elsif (slt = '1') then
            hazard_unit_type_o <= "010";
        elsif (slti = '1') then
            hazard_unit_type_o <= "011";
        elsif (lui = '1') then
            hazard_unit_type_o <= "100";
        elsif (lw = '1') then 
            hazard_unit_type_o <= "101";
        elsif ((beq = '1') or (bne = '1')) then
            hazard_unit_type_o <= "110";
        else 
            hazard_unit_type_o <= "111"; 
        end if;
    end process;


    -- RegWrite Configurarion
    RegWrite    <=  (jal or addi or addiu or slti or andi or ori or xori or lui or lw or 
                    sll_f or srl_f or mult or add or addu or sub or and_f or
                    or_f or xor_f or slt);

    -- WDSel Configurarion
    WDSel       <=  jal;

    -- Shamt_ctl Configurarion
    Shamt_ctl       <=  (sll_f or srl_f);

    -- JR Configuration
    jr          <= jr_sig;

    lw_o <= lw;
    sw_o <= sw;
                    
end dataflow;
