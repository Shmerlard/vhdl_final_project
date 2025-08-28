create_clock -period 20 [get_ports clk_i]

derive_pll_clocks
derive_clock_uncertainty
