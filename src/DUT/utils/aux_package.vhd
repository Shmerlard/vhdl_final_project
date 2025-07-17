---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_comilation_package.all;


package aux_package is
    type t_hex_array is array (natural range <>) of std_logic_vector(6 downto 0);
    type t_fir_reg_arr is array (natural range <>) of std_logic_vector;
    type t_vec_array is array (natural range <>) of std_logic_vector;

    component MIPS is
        generic( 
            WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
            MODELSIM : integer          := G_MODELSIM;
            DATA_BUS_WIDTH : integer    := 32;
            ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            PC_WIDTH : integer          := 10;
            NEXT_PC_WIDTH : integer     := 8;
            FUNCT_WIDTH : integer       := 6;
            DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
            CLK_CNT_WIDTH : integer     := 16;
            INST_CNT_WIDTH : integer    := 16
        );
        PORT(   
            rst_i               :IN STD_LOGIC;
            clk_i               :IN STD_LOGIC; 
            bpaddr_i            :IN STD_LOGIC_VECTOR(7 downto 0);
            -- Output important signals to pins for easy display in Simulator
            pc_o                :OUT    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
            alu_result_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data1_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            write_data_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            instruction_top_o   :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            Branch_ctrl_o       :OUT    STD_LOGIC;
            Zero_o              :OUT    STD_LOGIC; 
            MemWrite_ctrl_o     :OUT    STD_LOGIC;
            RegWrite_ctrl_o     :OUT    STD_LOGIC;
            mclk_cnt_o          :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
            inst_cnt_o          :OUT    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
            hex_o               :OUT    t_hex_array(0 to 7);
            flush_cnt           :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            hf_cnt              :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            strigger_o          :OUT    std_logic
        );      
    end component;
---------------------------------------------------------  
    component control is
        PORT(   
            Op              : IN    STD_LOGIC_VECTOR(5 DOWNTO 0);
            Funct           : IN    STD_LOGIC_VECTOR(5 DOWNTO 0);
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
    end component;
---------------------------------------------------------   
    component dmemory is
        generic(
        DATA_BUS_WIDTH : integer := 32;
        DTCM_ADDR_WIDTH : integer := 8;
        WORDS_NUM : integer := 256
    );
    PORT(   clk_i,rst_i         : IN    STD_LOGIC;
            dtcm_addr_i         : IN    STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
            dtcm_data_wr_i      : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            MemRead_ctrl_i      : IN    STD_LOGIC;
            MemWrite_ctrl_i     : IN    STD_LOGIC;
            dtcm_data_rd_o      : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
    );
    end component;
---------------------------------------------------------   
    component hex_driver is
    port(
        num_in: IN std_logic_vector(3 downto 0);
        en:     IN std_logic;
        num_out:OUT std_logic_vector(6 downto 0)
        );
    end component;
---------------------------------------------------------       
    component Execute is
        generic(
            DATA_BUS_WIDTH : integer := 32;
            FUNCT_WIDTH : integer := 6;
            PC_WIDTH : integer := 10
        );
        PORT(   
            read_data1_i    : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_i    : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            sign_extend_i   : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            zero_extend_i   : in    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            shamt_i         : in    std_logic_vector(4 downto 0);
            shamt_ctl_i     : in    STD_LOGIC;
            ALUSrc_ctrl_i   : IN    STD_LOGIC_VECTOR(1 downto 0);
            bne_ctl_i       : in    std_logic;
            beq_ctl_i       : in    std_logic;
            alufn_i         : in    STD_LOGIC_VECTOR(4 downto 0);
            alu_res_o       : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            slt_res_o       : out   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            lui_res_o       : out   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            zero_o          : out   std_logic;
            branch_ctl_o    : out   std_logic
        );
    end component;
---------------------------------------------------------       
    component Idecode is
        generic(
            DATA_BUS_WIDTH : integer := 32;
            NEXT_PC_WIDTH  : integer := 8
        );
        PORT(   
            clk_i,rst_i     : IN    STD_LOGIC;
            instruction_i   : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            RegWrite_ctrl_i : IN    STD_LOGIC;
            write_reg_addr_i: in    STD_LOGIC_VECTOR(4 DOWNTO 0);
            write_reg_data_i: in    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            pc_plus4_i      : in    STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
            read_data1_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            sign_extend_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            zero_extend_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            jta_o           : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
            bta_o           : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0)
        );
    end component;
---------------------------------------------------------       
    component Ifetch is
        generic(
            WORD_GRANULARITY : boolean  := True;
            DATA_BUS_WIDTH : integer    := 32;
            PC_WIDTH : integer          := 10;
            NEXT_PC_WIDTH : integer     := 8; -- NEXT_PC_WIDTH = PC_WIDTH-2
            ITCM_ADDR_WIDTH : integer   := 8;
            WORDS_NUM : integer         := 256;
            INST_CNT_WIDTH : integer    := 16
        );
        PORT(   
        clk_i, rst_i    : IN    STD_LOGIC;
        bta_i, jta_i    : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
        branch_ctl_i    : IN    STD_LOGIC;
        j_ctl_i         : in    std_logic;
        jr_ctl_i        : in    std_logic;
        read_data1_i    : in    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        pc_halt_i       : in    std_logic;
        pc_o            : OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        pc_plus4_o      : OUT   STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
        instruction_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        inst_cnt_o      : OUT   STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0) 
        );
    end component;
---------------------------------------------------------
    component ALU is
        generic(n : integer := 32);
        port(
            y, x        : in    std_logic_vector(n-1 downto 0);
            alufn       : in    std_logic_vector(4 downto 0);
            aluout      : out   std_logic_vector(n-1 downto 0);
            zflag       : out   std_logic
        );
    end component;
---------------------------------------------------------
    component WRITE_BACK IS
    PORT( 
        MemtoReg_ctl_i, RegDst_ctl_i: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        RegWrite_ctl_i, WDSel_ctl_i : IN  STD_LOGIC;
        ALU_Result_i, dtcm_data_i   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm_i                       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_plus_4_i                 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        rt_rd_i                     : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        write_data_o                : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_reg_addr_o            : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END component;
---------------------------------------------------------
    component PLL port(
        areset      : IN STD_LOGIC  := '0';
        inclk0      : IN STD_LOGIC  := '0';
        c0          : OUT STD_LOGIC ;
        locked      : OUT STD_LOGIC );
    end component;
---------------------------------------------------------   
    component nbit_dff is
    generic (
        n : integer := 8  -- default size = 8 bits
    );
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;  -- asynchronous reset
        en     : in  std_logic;
        d_in   : in  std_logic_vector(n-1 downto 0);
        q_out  : out std_logic_vector(n-1 downto 0)
    );
    end component;
---------------------------------------------------------
    component hazardunit is
    port( 
        clk_i, rst_i    : in std_logic;
        inst_type_i     : in std_logic_vector(2 downto 0);
        rs_rt_rd_i      : in std_logic_vector(14 downto 0);
        rd1_sel_o       : out std_logic_vector(3 downto 0);
        rd2_sel_o       : out std_logic_vector(3 downto 0);
        lw_hazard_rd1_o : out std_logic;
        lw_hazard_rd2_o : out std_logic
    );
    end component;
---------------------------------------------------------
    component timer_unit is
        port(
            mclk_i     : in std_logic
        );
    end component;
---------------------------------------------------------
    component fir_base_unit is
    generic(
        w: integer := 24;
        q: integer := 8
    );
    port (
        clk_i   : in STD_LOGIC;
        rst_i   : in STD_LOGIC;
        x_i     : in STD_LOGIC_VECTOR(w-1 downto 0);
        sum_i   : in STD_LOGIC_VECTOR(w+q-1 downto 0);
        coef_i  : in STD_LOGIC_VECTOR(q-1 downto 0);

        x_o     : out STD_LOGIC_VECTOR(w-1 downto 0);
        sum_o   : out STD_LOGIC_VECTOR(w+q-1 downto 0)
    );
    end component;
---------------------------------------------------------
    component fir_reg_arr is
        generic(
            w: integer := 24;
            m: integer := 8;
            q: integer := 8
        );
        port (
            clk_i   : in STD_LOGIC;
            rst_i   : in STD_LOGIC;
            x_i     : in STD_LOGIC_VECTOR(w-1 downto 0);
            coeff_i : in t_vec_array(0 to M-2)(q-1 downto 0);
            y_o     : out STD_LOGIC_VECTOR(w+q-1 downto 0)
        );
    end component fir_reg_arr;
---------------------------------------------------------
    component nbit_sr is
        generic
        (
            n: integer := 1;            -- size of data
            k: integer := 8             -- number of dff
        );
        port
        (
            clk_i : in std_logic;
            rst_i : in std_logic;

            d_in : in std_logic_vector(n-1 downto 0);
            q_out: out std_logic_vector(n-1 downto 0)
        );
    end component;
---------------------------------------------------------
    component fir_sync_fifo is
        generic
        (
            w: integer := 24;
            q: integer := 8;
            k: integer := 8
        );
        port
        (
            FIFOCLK : in STD_LOGIC;
            FIFORST : in STD_LOGIC;
            FIFOWEN : in STD_LOGIC;
            FIFOREN : in STD_LOGIC;

            FIFOIN : in STD_LOGIC_VECTOR(w+q-1 downto 0);

            FIFOFULL : out STD_LOGIC;
            FIFOEMPTY : out STD_LOGIC;

            DATAOUT     : out STD_LOGIC_VECTOR(w+q-1 downto 0)
        );
    end component;
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
end aux_package;

