set_property IOSTANDARD LVCMOS33 [get_ports {pulse[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulse[0]}]
set_property PACKAGE_PIN A13 [get_ports {pulse[7]}]
set_property PACKAGE_PIN A16 [get_ports {pulse[6]}]
set_property PACKAGE_PIN A15 [get_ports {pulse[5]}]
set_property PACKAGE_PIN A19 [get_ports {pulse[4]}]
set_property PACKAGE_PIN A18 [get_ports {pulse[3]}]
set_property PACKAGE_PIN F14 [get_ports {pulse[2]}]
set_property PACKAGE_PIN F13 [get_ports {pulse[1]}]
set_property PACKAGE_PIN E14 [get_ports {pulse[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clka]
set_property PACKAGE_PIN Y18 [get_ports clk]
set_property PACKAGE_PIN A14 [get_ports clka]

set_property IOSTANDARD LVCMOS33 [get_ports {key[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key[0]}]
set_property PACKAGE_PIN A21 [get_ports {key[0]}]
set_property PACKAGE_PIN B20 [get_ports {key[1]}]
set_property PACKAGE_PIN A20 [get_ports {key[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {mode_sel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mode_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mode_sel[0]}]
set_property PACKAGE_PIN E22 [get_ports {mode_sel[2]}]
set_property PACKAGE_PIN D22 [get_ports {mode_sel[1]}]
set_property PACKAGE_PIN G22 [get_ports {mode_sel[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports read_add_subtract]
set_property IOSTANDARD LVCMOS33 [get_ports write_add_subtract]
set_property PACKAGE_PIN B22 [get_ports read_add_subtract]
set_property PACKAGE_PIN C22 [get_ports write_add_subtract]

set_property IOSTANDARD LVCMOS33 [get_ports reset_n]
set_property PACKAGE_PIN B21 [get_ports reset_n]

set_property SLEW SLOW [get_ports clka]
