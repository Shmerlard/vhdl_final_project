----------------------------------------------------------------------------------------------- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_comilation_package.all;


package aux_package is
    type t_hex_array is array (natural range <>) of std_logic_vector(6 downto 0);
    -- type t_fir_reg_arr is array (natural range <>) of std_logic_vector;
    type t_vec_array is array (natural range <>) of std_logic_vector;
    type t_addr_array is array (natural range <>) of natural;
    type t_bits_array is array (natural range <>) of natural;
    -- constant EMP_BITS_ARR : t_bits_array(0 to -1) := (others => 0);
    -- constant EMP_BITS_ARR : t_bits_array(0 to 0) := (0 => -1);
    -- type t_reset_types is (ASYNCHRONOUS, SYNCHRONOUS);

---------------------------------------------------------  
    component mips_core is
    generic( 
            WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
            -- MODELSIM : integer          := G_MODELSIM;
            DATA_BUS_WIDTH  : integer   := 32;
            ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            PC_WIDTH        : integer   := 10;
            NEXT_PC_WIDTH   : integer   := 8;
            -- FUNCT_WIDTH  : integer   := 6;
            DATA_WORDS_NUM  : integer   := G_DATA_WORDS_NUM;
            CLK_CNT_WIDTH   : integer   := 16;
            INST_CNT_WIDTH  : integer   := 16;
            DTCM_PATH       : string    := G_DTCM_PATH;
            ITCM_PATH       : string    := G_ITCM_PATH
    );
    PORT(   rst_i               :IN     STD_LOGIC;
            clk_i               :IN     STD_LOGIC; 
            bpaddr_i            :IN     STD_LOGIC_VECTOR(7 downto 0);
            int_req_i           :in     std_logic;
            -- interrupt_src_i     :in     std_logic_vector(8 downto 0);

            data_bus_o          :inout  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            addr_bus_o          :out  STD_LOGIC_VECTOR((PC_WIDTH + 2)-1 DOWNTO 0);
            ctrl_bus_o          :out  STD_LOGIC_VECTOR(1 DOWNTO 0);
            -- Output important signals to pins for easy display in SignalTap
            pc_o                :OUT    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
            alu_result_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data1_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            write_data_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            int_ack_o           :OUT    std_logic;
            gie_o               : out   std_logic;
            instruction_top_o   :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            Branch_ctrl_o       :OUT    STD_LOGIC;
            Zero_o              :OUT    STD_LOGIC;
            MemWrite_ctrl_o     :OUT    STD_LOGIC;
            RegWrite_ctrl_o     :OUT    STD_LOGIC;
            mclk_cnt_o          :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
            inst_cnt_o          :OUT    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
            -- hex_o               :OUT    t_hex_array(0 to 7);
            flush_cnt           :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            hf_cnt              :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
            strigger_o          :OUT    std_logic
    );
    end component;
---------------------------------------------------------  
    component mips_top is
    generic( 
            WORD_GRANULARITY : boolean  := G_WORD_GRANULARITY;
            USE_ALT_CLK: boolean        := false;
            -- MODELSIM : integer          := G_MODELSIM;
            MODELSIM : integer          := 0;
            DATA_BUS_WIDTH : integer    := 32;
            ITCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            DTCM_ADDR_WIDTH : integer   := G_ADDRWIDTH;
            PC_WIDTH : integer          := 10;
            NEXT_PC_WIDTH : integer     := 8;
            -- FUNCT_WIDTH : integer       := 6;
            DATA_WORDS_NUM : integer    := G_DATA_WORDS_NUM;
            CLK_CNT_WIDTH : integer     := 16;
            INST_CNT_WIDTH : integer    := 16;
            DTCM_PATH : string := "/home/elad/Desktop/vhdl_final_project/src/SW/timer/DTCM.hex";
            ITCM_PATH : string := "/home/elad/Desktop/vhdl_final_project/src/SW/timer/ITCM.hex"
    );
    PORT(
        rst_i               : in std_logic;
        clk_i               : in std_logic; 
        bpaddr_i            : in std_logic_vector(7 downto 0);
        keys_i              : in std_logic_vector(2 downto 0);
        switches_i          : in std_logic_vector(7 downto 0);

        hex_arr_o           : out t_hex_array(0 to 5);
        leds_o              : out std_logic_vector(7 downto 0);

        -- Output important signals to pins for easy display in SignalTap
        pc_o                :OUT    STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
        alu_result_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        read_data1_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        read_data2_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        write_data_o        :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        instruction_top_o   :OUT    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
        Branch_ctrl_o       :OUT    STD_LOGIC;
        Zero_o              :OUT    STD_LOGIC;
        int_ack_o           : out   std_logic;
        int_req_o           : out   std_logic;
        MemWrite_ctrl_o     :OUT    STD_LOGIC;
        RegWrite_ctrl_o     :OUT    STD_LOGIC;
        mclk_cnt_o          :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
        inst_cnt_o          :OUT    STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
        -- hex_o               :OUT    t_hex_array(0 to 7)
        flush_cnt           :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
        hf_cnt              :OUT    STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 downto 0);
        strigger_o          :OUT    std_logic;
        data_bus_o          : out   std_logic_vector(DATA_BUS_WIDTH-1 DOWNTO 0)
    );
    end component;
---------------------------------------------------------  

    -- UNITS
    component control is
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
    end component;
---------------------------------------------------------   
    component Execute is
    generic(
        DATA_BUS_WIDTH : integer := 32
        -- FUNCT_WIDTH : integer := 6;
        -- PC_WIDTH : integer := 10
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
    component hazardunit is
    port( 
        clk_i, rst_i    : in std_logic;
        jr_ctl_i        : in std_logic;
        beq_taken_ctl_i : in std_logic;
        bne_taken_ctl_i : in std_logic;
        id_ex_flush_ctl_i: in std_logic;
        inst_type_i     : in std_logic_vector(2 downto 0);
        rs_rt_rd_i      : in std_logic_vector(14 downto 0);
        rd1_sel_o       : out std_logic_vector(3 downto 0);
        rd2_sel_o       : out std_logic_vector(3 downto 0);
        lw_hazard_rd1_o : out std_logic;
        lw_hazard_rd2_o : out std_logic;
        hazard_stall_ctl_o : out std_logic;
        hazard_if_stall_req : out std_logic;
        hazard_id_stall_req: out std_logic;

        jrta_sel_o   : out std_logic
    );
    end component;
---------------------------------------------------------       
    component Idecode IS
    generic(
        DATA_BUS_WIDTH : integer := 32;
        NEXT_PC_WIDTH  : integer := 8
    );
    PORT(   clk_i,rst_i     : IN    STD_LOGIC;
            instruction_i   : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            RegWrite_ctrl_i : IN    STD_LOGIC;
            write_reg_addr_i: in    STD_LOGIC_VECTOR(4 DOWNTO 0);
            write_reg_data_i: in    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            pc_plus4_i      : in    STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
            pc_latch_i      : in    STD_LOGIC_VECTOR(NEXT_PC_WIDTH-1 DOWNTO 0);
            c1_cmp_i        : in    std_logic;
            c3_cmp_i        : in    std_logic;
            gie_mask_i      : in    std_logic;
            INTR_i          : in    std_logic;
            gie_o           : out    std_logic;
            read_data1_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            read_data2_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            sign_extend_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            zero_extend_o   : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            jta_o           : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
            bta_o           : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0)
    );
    END component;
---------------------------------------------------------       
    component Ifetch IS
    generic(
        WORD_GRANULARITY : boolean  := True;
        DATA_BUS_WIDTH : integer    := 32;
        PC_WIDTH : integer          := 10;
        NEXT_PC_WIDTH : integer     := 8; -- NEXT_PC_WIDTH = PC_WIDTH-2
        ITCM_ADDR_WIDTH : integer   := 8;
        WORDS_NUM : integer         := 256;
        INST_CNT_WIDTH : integer    := 16;
        ITCM_PATH : string
    );
    PORT(
        clk_i, rst_i    : in    std_logic;
        bta_i, jta_i    : in    std_logic_vector(7 downto 0);
        branch_ctl_i    : in    std_logic;
        stall_ctl_i     : in    std_logic;
        j_ctl_i         : in    std_logic;
        jr_ctl_i        : in    std_logic;
        jrta_i          : in    std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
        c3_cmp_i        : in    std_logic;
        isr_i           : in    std_logic_vector(next_pc_width-1 downto 0);
        pc_o            : out   std_logic_vector(NEXT_PC_WIDTH-1 downto 0);
        instruction_o   : out   std_logic_vector(data_bus_width-1 downto 0);
        inst_cnt_o      : out   std_logic_vector(inst_cnt_width-1 downto 0);
        pc_plus4_o      : out   std_logic_vector(next_pc_width-1 downto 0)
    );
    END component;
---------------------------------------------------------       
    component WRITE_BACK IS
    PORT( 
        MemtoReg_ctl_i              : in  std_logic_vector(1 DOWNTO 0);
        RegDst_ctl_i                : in  std_logic_vector(1 DOWNTO 0);
        -- RegWrite_ctl_i              : in  std_logic;
        WDSel_ctl_i                 : in  std_logic;
        ALU_Result_i, dtcm_data_i   : in  std_logic_vector(31 DOWNTO 0);
        imm_i                       : in  std_logic_vector(15 DOWNTO 0);
        PC_plus_4_i                 : in  std_logic_vector(7 DOWNTO 0);
        rt_rd_i                     : in  std_logic_vector(9 DOWNTO 0);
        write_data_o                : out std_logic_vector(31 DOWNTO 0);
        write_reg_addr_o            : out std_logic_vector(4 DOWNTO 0)
        );
    END component;
---------------------------------------------------------       
    component interrupt_handler is
    generic(data_bus_width : natural := 32);
    port(
        clk_i               : in    std_logic;
        rst_i               : in    std_logic;
        intr_i              : in    std_logic;
        reti_ctl_i          : in    std_logic;
        instruction_id_i    : in    std_logic_vector(data_bus_width-1 downto 0);
        int_ack_o           : out   std_logic;
        gie_mask_o          : out   std_logic;
        c1_cmp_o            : out   std_logic;
        c3_cmp_o            : out   std_logic;
        load_from_type_o    : out   std_logic;
        c1to3_cmp_o         : out   std_logic;
        c2to5_cmp_o         : out   std_logic;
        reg_type_addr_o     : out   std_logic_vector(11 downto 0);
        reg_type_addr_sel   : out   std_logic;
        latch_epc_load_o    : out   std_logic;

        int_if_id_flush_req_o : out std_logic;
        int_id_ex_flush_req_o : out std_logic
    );
    end component;
---------------------------------------------------------   
    component dmemory is
    generic(
               DATA_BUS_WIDTH : integer := 32;
               DTCM_ADDR_WIDTH : integer := 12;
               WORDS_NUM : integer := 256;
               DTCM_PATH : string
    );
    PORT(   clk_i               : IN    STD_LOGIC;
            dtcm_addr_i         : IN    STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
            dtcm_data_wr_i      : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
            MemRead_ctrl_i      : IN    STD_LOGIC;
            MemWrite_ctrl_i     : IN    STD_LOGIC;
            dtcm_data_rd_o      : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
    );
    end component;
---------------------------------------------------------   
    component stall_controller is
        port( 
            clk_i       : in std_logic;
            rst_i       : in std_logic;

            hazard_if_stall_req : in std_logic;
            hazard_id_stall_req : in std_logic;

            interrupt_if_id_flush_req : in std_logic;
            interrupt_id_ex_flush_req : in std_logic;

            control_if_flush_req: in std_logic;

            if_stall_ctl_o : out std_logic;
            if_id_plr_flsh_ctl_o : out std_logic;
            id_ex_plr_flsh_ctl_o : out std_logic

        );
    end component stall_controller;

---------------------------------------------------------   
    -- mem registers
    component ex_mem_pipeline_reg is
        generic(
            controls_count_JJJJ : natural := 8;
            DATA_BUS_WIDTH : integer    := 32;
            NEXT_PC_WIDTH : integer     := 8

        );
        port (
            clk_i : in std_logic;
            rst_i : in std_logic;

            controls_i : in std_logic_vector;
            controls_o : out std_logic_vector;

            pc_plus4_i : in std_logic_vector;
            pc_plus4_o : out std_logic_vector;

            instruction_i : in std_logic_vector;
            instruction_o : out std_logic_vector;


            rd1_i : in std_logic_vector;
            rd1_o : out std_logic_vector;

            rd2_i : in std_logic_vector;
            rd2_o : out std_logic_vector;

            alu_res_i : in std_logic_vector;
            alu_res_o : out std_logic_vector;

            slt_res_i : in std_logic_vector;
            slt_res_o : out std_logic_vector;

            lui_res_i : in std_logic_vector;
            lui_res_o : out std_logic_vector
        );
    end component ex_mem_pipeline_reg;
---------------------------------------------------------  
    component id_ex_pipeline_reg is
        generic(
            controls_count_JJJJ : natural := 18;
                DATA_BUS_WIDTH : integer    := 32;
                NEXT_PC_WIDTH : integer     := 8
                -- shamt_count : integer := 5

        );
        port (
            clk_i : in std_logic;
            rst_i : in std_logic;
            flush_i : in std_logic;

            controls_i : in std_logic_vector;
            controls_o : out std_logic_vector;

            pc_i : in std_logic_vector;
            pc_o : out std_logic_vector;

            pc_plus4_i : in std_logic_vector;
            pc_plus4_o : out std_logic_vector;

            -- shamt_i : in std_logic_vector;
            -- shamt_o : out std_logic_vector;

            instruction_i : in std_logic_vector;
            instruction_o : out std_logic_vector;

            rd1_i : in std_logic_vector;
            rd1_o : out std_logic_vector;

            rd2_i : in std_logic_vector;
            rd2_o : out std_logic_vector;

            zero_ext_i : in std_logic_vector;
            zero_ext_o : out std_logic_vector;

            sign_ext_i : in std_logic_vector;
            sign_ext_o : out std_logic_vector;

            jump_controls_i : in std_logic;
            jump_controls_o : out std_logic
        );
    end component id_ex_pipeline_reg;
---------------------------------------------------------  
    component if_id_pipeline_reg is
        generic(
                DATA_BUS_WIDTH : integer    := 32;
                NEXT_PC_WIDTH : integer     := 8

        );
        port (
            clk_i : in std_logic;
            rst_i : in std_logic;
            flush_i : in std_logic;
            stall_i : in std_logic;

            instruction_i : in std_logic_vector;
            instruction_o : out std_logic_vector;

            pc_plus4_i : in std_logic_vector;
            pc_plus4_o : out std_logic_vector;

            -- TODO: find better names
            pc_i : in std_logic_vector;
            pc_o : out std_logic_vector
        );
    end component if_id_pipeline_reg;
---------------------------------------------------------  
    component mem_wb_pipeline_reg is
        generic(
            controls_count_JJJJ : natural := 6;
            DATA_BUS_WIDTH : integer    := 32;
            NEXT_PC_WIDTH : integer     := 8
        );
        port (
            clk_i : in std_logic;
            rst_i : in std_logic;

            controls_i : in std_logic_vector;
            controls_o : out std_logic_vector;

            pc_plus4_i : in std_logic_vector;
            pc_plus4_o : out std_logic_vector;

            instruction_i : in std_logic_vector;
            instruction_o : out std_logic_vector;

            rd1_i : in std_logic_vector;
            rd1_o : out std_logic_vector;

            dtcm_data_i : in std_logic_vector;
            dtcm_data_o : out std_logic_vector;

            alu_res_i : in std_logic_vector;
            alu_res_o : out std_logic_vector;


            slt_res_i : in std_logic_vector;
            slt_res_o : out std_logic_vector;

            lui_res_i : in std_logic_vector;
            lui_res_o : out std_logic_vector
        );
    end component mem_wb_pipeline_reg;
---------------------------------------------------------  

    -- GPIO
    component gpio_unit is
        generic(
            ADDRESS_BUS_WIDTH: integer := 12;
            DATA_BUS_WIDTH: integer := 32;
            ADDRESS_ARRAY : t_addr_array;

            LED_ARR_CNT: natural := 1;
            HEX_ARR_CNT: natural := 3;
            SW_ARR_CNT: natural := 1
        );
        port (
            clk_i : in std_logic;
            rst_i : in std_logic;
            mem_wr_c_in : in std_logic;
            mem_rd_c_in : in std_logic;
            address_bus_i : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
            switches_in : in std_logic_vector;

            data_bus_io : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
            hex_out: out t_hex_array;
            leds_out: out std_logic_vector
        );
    end component gpio_unit;
---------------------------------------------------------   
    component port_hex_interface is
        port (
            rst_i       : in std_logic;
            clk_i       : in std_logic;
            data_i      : in STD_LOGIC_VECTOR(3 downto 0);
            cs_i        : in STD_LOGIC_Vector(1 downto 0);
            hex_o       : out t_hex_array(0 to 1)
        );
    end component port_hex_interface;
---------------------------------------------------------   
    component port_led_interface is
    port (
        rst_i       : in STD_LOGIC;
        clk_i       : in STD_LOGIC;
        data_i      : in STD_LOGIC_VECTOR(7 downto 0);
        cs_i        : in STD_LOGIC;
        led_o       : out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component port_led_interface;
---------------------------------------------------------   
    component port_sw_interface is
        generic( n: integer := 8 );
        port (
            sw_i        : in STD_LOGIC_VECTOR(n-1 downto 0);
            cs_i        : in STD_LOGIC;
            data_o      : out STD_LOGIC_VECTOR(n-1 downto 0)
        );
    end component port_sw_interface;
---------------------------------------------------------   
    component hex_driver is
    port(
        num_in: IN std_logic_vector(3 downto 0);
        en:     IN std_logic;
        num_out:OUT std_logic_vector(6 downto 0)
        );
    end component;
---------------------------------------------------------   

    -- TIMER
    component timer_core is
    generic ( n: integer := 32);
    port (
        mclk_i : in std_logic;
        mclk_i2 : in std_logic;
        mclk_i4 : in std_logic;
        mclk_i8 : in std_logic;
        rst_i   : in std_logic;
        BTCLR: in std_logic;
        BTHOLD: in std_logic;
        BTSSEL: in std_logic_vector(1 downto 0);
        BTOUTMD: in std_logic;
        BTOUTEN: in std_logic;
        BTCCR0: in std_logic_vector(n-1 downto 0);
        BTCCR1: in std_logic_vector(n-1 downto 0);
        BTIP: in std_logic_vector(1 downto 0);
        BTIFG: out std_logic;
        PWMOUT: out std_logic;

        d_bus_i: in std_logic_vector(n-1 downto 0);
        btcnt_wr_en: in std_logic;
        d_bus_o: out std_logic_vector(n-1 downto 0)

    );
    end component timer_core;
---------------------------------------------------------   
    component  timer_output_unit is
    generic( n : integer := 8);
    port (
        -- inputs
        btccr0_i, btccr1_i      : in std_logic_vector(n-1 downto 0);
        btcnt_i                 : in std_logic_vector(n-1 downto 0);

        clk_i                   : in STD_LOGIC;
        en_i                    : in STD_LOGIC;
        mode_i                  : in STD_LOGIC;

        -- outpus
        pwm_out_o               : out std_logic;
        heu0_o                  : out STD_LOGIC
    );
    end component  timer_output_unit;
---------------------------------------------------------   
    component timer_unit is
        generic
        (
            REG_SIZE: integer := 32;
            TIMER_UNIT_ADDRESS_ARRAY: t_addr_array;
            ADDRESS_BUS_WIDTH: INTEGER := 12;
            DATA_BUS_WIDTH: INTEGER := 32
        );
        port (
            mclk_i          : in std_logic;
            mclk_i2_i       : in std_logic;
            mclk_i4_i       : in std_logic;
            mclk_i8_i       : in std_logic;
            rst_i           : in std_logic;
            mem_write_c_i   : in std_logic;
            mem_read_c_i    : in std_logic;

            address_bus_i   : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
            data_bus_io     : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);

            BTIFG           : out std_logic;
            PWMOUT          : out std_logic
        );
    end component timer_unit;
---------------------------------------------------------   
---------------------------------------------------------       

    -- Modules

    component nbit_dff_flush is
        generic (
            n : integer := 8  -- default size = 8 bits
        );
        port(
            clk    : in  std_logic;
            rst    : in  std_logic;  -- asynchronous reset
            en     : in  std_logic;
            flush  : in  std_logic;
            d_in   : in  std_logic_vector(n-1 downto 0);
            q_out  : out std_logic_vector(n-1 downto 0)
        );
    end component nbit_dff_flush;
---------------------------------------------------------       
---------------------------------------------------------       
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
---------------------------------------------------------
    component PLL IS
        PORT
        (
            areset      : IN STD_LOGIC  := '0';
            inclk0      : IN STD_LOGIC  := '0';
            c0      : OUT STD_LOGIC ;
            c1      : OUT STD_LOGIC ;
            c2      : OUT STD_LOGIC ;
            c3      : OUT STD_LOGIC ;
            locked      : OUT STD_LOGIC 
        );
    END component PLL;

    component pll_50 IS
        PORT
        (
            areset		: IN STD_LOGIC  := '0';
            inclk0		: IN STD_LOGIC  := '0';
            c0		: OUT STD_LOGIC ;
            c1		: OUT STD_LOGIC ;
            c2		: OUT STD_LOGIC ;
            c3		: OUT STD_LOGIC ;
            c4		: OUT STD_LOGIC ;
            locked		: OUT STD_LOGIC 
        );
    END component pll_50;
---------------------------------------------------------   
    component nbit_dff is
    generic ( n : integer := 8);
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;  -- asynchronous reset
        en     : in  std_logic;
        d_in   : in  std_logic_vector(n-1 downto 0);
        q_out  : out std_logic_vector(n-1 downto 0)
    );
    end component;
---------------------------------------------------------
    component nbit_dff_ext is
        generic(
            n              : integer := 8;
            ASYNC_RST      : boolean := true;
            IGN_BITS       : std_logic_vector;
            RST_BITS       : std_logic_vector
        );
        port(
            clk_i       : in  std_logic;
            rst_i       : in  std_logic := '0';
            wr_en_i     : in  std_logic;
            d_in        : in  std_logic_vector(n-1 downto 0);
            ign_d_in    : in  std_logic_vector(n-1 downto 0) := (others => '0');
            q_out       : out std_logic_vector(n-1 downto 0)
        );
    end component nbit_dff_ext;
---------------------------------------------------------
    component epc is
    generic( next_pc_width : natural := 8 );
    port (
        clk_i           : in    std_logic;
        rst_i           : in    std_logic;
        ex_jump_ctl_i   : in    std_logic;
        ex_branch_ctl_i : in    std_logic;
        epc_capture_i   : in    std_logic;
        id_pc_i   : in    std_logic_vector(next_pc_width-1 downto 0);
        ret_pc_o        : out   std_logic_vector(next_pc_width-1 downto 0)
    );
    end component epc;
---------------------------------------------------------
---------------------------------------------------------
    -- component fir_base_unit is
    -- generic(
    --     w: integer := 24;
    --     q: integer := 8
    -- );
    -- port (
    --     clk_i   : in STD_LOGIC;
    --     rst_i   : in STD_LOGIC;
    --     x_i     : in STD_LOGIC_VECTOR(w-1 downto 0);
    --     sum_i   : in STD_LOGIC_VECTOR(w+q-1 downto 0);
    --     coef_i  : in STD_LOGIC_VECTOR(q-1 downto 0);
    --
    --     x_o     : out STD_LOGIC_VECTOR(w-1 downto 0);
    --     sum_o   : out STD_LOGIC_VECTOR(w+q-1 downto 0)
    -- );
    -- end component;
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
    component interrupt_controller_core is
    generic (
        INT_SRC_COUNT: NATURAL := 9;
        INT_IFG_COUNT: NATURAL := 7
            );
    port 
    (   
        clk_i               : in std_logic;
        rst_i               : in std_logic;
        inta_i_b            : in std_logic;
        int_src_from_periph_i : in std_logic_vector(8 downto 0);
        data_bus_i            : in std_logic_vector(6 downto 0);
        eint_i              : in std_logic_vector(6 downto 0);
        gie_i               : in std_logic;
        ifg_cs_write_ctl_i  : in std_logic;

        -- ifg_write_en        : in std_logic;
        -- ifg_d_in_i          : in std_logic_vector(INT_SRC_COUNT-1 downto 0);
        ifg_o               : out std_logic_vector(6 downto 0);
        type_reg_d_in_o     : out std_logic_vector(7 downto 0);
        int_req_o              : out std_logic
    );
    end component interrupt_controller_core;
---------------------------------------------------------
    component interrupt_controller_unit is
    generic (
        ADDRESS_BUS_WIDTH: INTEGER := 12;                                       -- the width of the address bus
        DATA_BUS_WIDTH: INTEGER := 32;                                          -- width of the data bus
        INT_UNIT_ADDRESS_ARRAY : t_addr_array;
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
end component interrupt_controller_unit;
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
    component nbit_timer is
        generic ( n : integer := 8 );
        port
        (
            clk    : in  std_logic;
            rst    : in  std_logic;  -- asynchronous reset
            en     : in  std_logic;
            equy   : in  std_logic;  -- synchronous reset
            q_out  : out std_logic_vector(n-1 downto 0)
        );
    end component nbit_timer;
---------------------------------------------------------
---------------------------------------------------------
    -- component timer_unit is
    --     generic
    --     (
    --         REG_SIZE: integer := 32;
    --         TIMER_UNIT_ADDRESS_ARRAY: t_addr_array;
    --         ADDRESS_BUS_WIDTH: INTEGER := 12;
    --         DATA_BUS_WIDTH: INTEGER := 32
    --     );
    --     port (
    --         mclk_i          : in std_logic;
    --         mclk_i2_i       : in std_logic;
    --         mclk_i4_i       : in std_logic;
    --         mclk_i8_i       : in std_logic;
    --         rst_i           : in std_logic;
    --         mem_write_c_i   : in std_logic;
    --         mem_read_c_i    : in std_logic;
    --
    --         address_bus_i   : in std_logic_vector(ADDRESS_BUS_WIDTH-1 downto 0);
    --         data_bus_io     : inout std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    --
    --         BTIFG           : out std_logic;
    --         PWMOUT          : out std_logic
    --     );
    -- end component timer_unit;
---------------------------------------------------------
    component nbit_latch is
        generic ( n : integer := 8 ); -- bus width
        port (
                 en   :      in  std_logic;
                 d_in :      in  std_logic_vector(n-1 downto 0);       -- Data input
                 q_out:      out std_logic_vector(n-1 downto 0)
             );
    end component nbit_latch;
---------------------------------------------------------
    component nbit_counter is
    generic (
        n : integer := 8;
        CNT_ON_RIS_EDG : boolean := true
    );
    port(
    clk_i    : in  std_logic;
        rst    : in  std_logic;     -- asynchronous reset
        en     : in  std_logic;     -- enable count
        cnt_dir: in  std_logic := '1';
        equy   : in  std_logic;     -- synchronous reset

        d_in    : in std_logic_vector(n-1 downto 0) := (others => '0');
        w_en_i  : in std_logic := '0';
        q_out   : out std_logic_vector(n-1 downto 0)
    );
    end component nbit_counter;
---------------------------------------------------------
---------------------------------------------------------

end aux_package;

