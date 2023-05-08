##CLK
set_property PACKAGE_PIN D4 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

##SW
set_property PACKAGE_PIN T9 [get_ports RSTn]
set_property IOSTANDARD LVCMOS33 [get_ports RSTn]

##DEBUGGER
set_property PACKAGE_PIN H14 [get_ports SWDIO]
set_property IOSTANDARD LVCMOS33 [get_ports SWDIO]
set_property PACKAGE_PIN H12 [get_ports SWCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SWCLK]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SWCLK]

##keyboard
set_property IOSTANDARD LVCMOS33 [get_ports {col[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[0]}]

set_property PACKAGE_PIN T10 [get_ports {col[3]}]
set_property PACKAGE_PIN R11 [get_ports {col[2]}]
set_property PACKAGE_PIN T12 [get_ports {col[1]}]
set_property PACKAGE_PIN R12 [get_ports {col[0]}]
set_property PACKAGE_PIN R10 [get_ports {row[3]}]
set_property PACKAGE_PIN P10 [get_ports {row[2]}]
set_property PACKAGE_PIN M6 [get_ports {row[1]}]
set_property PACKAGE_PIN K3 [get_ports {row[0]}]


##lcd
set_property PACKAGE_PIN A3 [get_ports LCD_CS]
set_property PACKAGE_PIN D3 [get_ports LCD_RS]
set_property PACKAGE_PIN B4 [get_ports LCD_WR]
set_property PACKAGE_PIN A4 [get_ports LCD_RD]
set_property PACKAGE_PIN B5 [get_ports LCD_RST]
set_property PACKAGE_PIN C8 [get_ports LCD_BL_CTR]

set_property PACKAGE_PIN A5 [get_ports LCD_DATA[0]]
set_property PACKAGE_PIN B6 [get_ports LCD_DATA[1]]
set_property PACKAGE_PIN B7 [get_ports LCD_DATA[2]]
set_property PACKAGE_PIN A7 [get_ports LCD_DATA[3]]
set_property PACKAGE_PIN C4 [get_ports LCD_DATA[4]]
set_property PACKAGE_PIN E5 [get_ports LCD_DATA[5]]
set_property PACKAGE_PIN D5 [get_ports LCD_DATA[6]]
set_property PACKAGE_PIN D6 [get_ports LCD_DATA[7]]
set_property PACKAGE_PIN C6 [get_ports LCD_DATA[8]]
set_property PACKAGE_PIN E6 [get_ports LCD_DATA[9]]
set_property PACKAGE_PIN C7 [get_ports LCD_DATA[10]]
set_property PACKAGE_PIN D8 [get_ports LCD_DATA[11]]
set_property PACKAGE_PIN D9 [get_ports LCD_DATA[12]]
set_property PACKAGE_PIN C9 [get_ports LCD_DATA[13]]
set_property PACKAGE_PIN D10 [get_ports LCD_DATA[14]]
set_property PACKAGE_PIN A8 [get_ports LCD_DATA[15]]

set_property IOSTANDARD LVCMOS33 [get_ports LCD_CS]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RS]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_WR]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RD]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RST]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_BL_CTR]

set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[0]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[1]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[2]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[3]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[4]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[5]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[6]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[7]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[8]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[9]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[10]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[11]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[12]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[13]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[14]]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_DATA[15]]


set_property IOSTANDARD LVCMOS33 [get_ports {beep}]
set_property PACKAGE_PIN L2 [get_ports {beep}]
