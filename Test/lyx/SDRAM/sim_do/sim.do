set work work
vlib work

cd F:/app/anlogic_app_demo/each_app/memory/sdram_as_ram/sim_do
set INCLUDE_PATH F:/app/anlogic_app_demo/each_app/memory/sdram_as_ram/source_code/include

##altera lib
#vmap altera_ver D:/lib/altera/verilog_libs/altera_ver
#vmap lpm_ver D:/lib/altera/verilog_libs/lpm_ver
#vmap sgate_ver D:/lib/altera/verilog_libs/sgate_ver
#vmap altera_mf_ver D:/lib/altera/verilog_libs/altera_mf_ver
#vmap altera_lnsim_ver D:/lib/altera/verilog_libs/altera_lnsim_ver
#vmap cycloneive_ver D:/lib/altera/verilog_libs/cycloneive_ver
#vmap cyclonev_ver D:/lib/altera/verilog_libs/cyclonev_ver
#vmap cyclonev_hssi_ver D:/lib/altera/verilog_libs/cyclonev_hssi_ver
#vmap cyclonev_pcie_hip_ver D:/lib/altera/verilog_libs/cyclonev_pcie_hip_ver
#vmap cycloneiv_hssi_ver D:/lib/altera/verilog_libs/cycloneiv_hssi_ver
#vmap cycloneiv_pcie_hip_ver D:/lib/altera/verilog_libs/cycloneiv_pcie_hip_ver
#vmap cycloneiv_ver D:/lib/altera/verilog_libs/cycloneiv_ver
#vmap altera D:/lib/altera/vhdl_libs/altera
#vmap lpm D:/lib/altera/vhdl_libs/lpm
#vmap sgate D:/lib/altera/vhdl_libs/sgate
#vmap altera_mf D:/lib/altera/vhdl_libs/altera_mf
#vmap altera_lnsim D:/lib/altera/vhdl_libs/altera_lnsim
#vmap cycloneive D:/lib/altera/vhdl_libs/cycloneive
#vmap cyclonev D:/lib/altera/vhdl_libs/cyclonev
#vmap cycloneiv_hssi D:/lib/altera/vhdl_libs/cycloneiv_hssi
#vmap cycloneiv_pcie_hip D:/lib/altera/vhdl_libs/cycloneiv_pcie_hip
#vmap cycloneiv D:/lib/altera/vhdl_libs/cycloneiv

##xilinx_ise_14_7
vmap secureip D:/lib/ise14_7_lib/secureip
vmap unisim D:/lib/ise14_7_lib/unisim
vmap unimacro D:/lib/ise14_7_lib/unimacro
vmap unisims_ver D:/lib/ise14_7_lib/unisims_ver
vmap unimacro_ver D:/lib/ise14_7_lib/unimacro_ver
vmap simprim D:/lib/ise14_7_lib/simprim
vmap simprims_ver D:/lib/ise14_7_lib/simprims_ver
vmap xilinxcorelib D:/lib/ise14_7_lib/xilinxcorelib
vmap xilinxcorelib_ver D:/lib/ise14_7_lib/xilinxcorelib_ver
vmap uni9000_ver D:/lib/ise14_7_lib/uni9000_ver
vmap cpld D:/lib/ise14_7_lib/cpld
vmap cpld_ver D:/lib/ise14_7_lib/cpld_ver
vmap edk D:/lib/ise14_7_lib/edk

##xilinx_vivado
#vmap secureip D:/lib/vivado_201702/secureip
#vmap unisim D:/lib/vivado_201702/unisim
#vmap unimacro D:/lib/vivado_201702/unimacro
#vmap unifast D:/lib/vivado_201702/unifast
#vmap unisims_ver D:/lib/vivado_201702/unisims_ver
#vmap unimacro_ver D:/lib/vivado_201702/unimacro_ver
#vmap unifast_ver D:/lib/vivado_201702/unifast_ver
#vmap simprims_ver D:/lib/vivado_201702/simprims_ver
#vmap xpm D:/lib/vivado_201702/xpm
#vmap blk_mem_gen_v8_2_6 D:/lib/vivado_201702/blk_mem_gen_v8_2_6
#vmap blk_mem_gen_v8_3_6 D:/lib/vivado_201702/blk_mem_gen_v8_3_6
#vmap fifo_generator_v12_0_5 D:/lib/vivado_201702/fifo_generator_v12_0_5
#vmap fifo_generator_v13_0_6 D:/lib/vivado_201702/fifo_generator_v13_0_6
#vmap fifo_generator_v13_1_4 D:/lib/vivado_201702/fifo_generator_v13_1_4
#vmap srio_gen2_v4_1_0 D:/lib/vivado_201702/srio_gen2_v4_1_0

##anlogic_lib
vmap al   D:/lib/anlogic/al
vmap ef2  D:/lib/anlogic/ef2
vmap ef3  D:/lib/anlogic/ef3
vmap eg   D:/lib/anlogic/eg
vmap elf  D:/lib/anlogic/elf
vmap ph1  D:/lib/anlogic/ph1


#将include文件单独放在一个文件夹，并指定incdir指向该文件夹，rtl文件夹中不能含有参数include文件，编译有包含include文件夹时，必须有参数incdir，如果.V文件中只有参数，则此.V文件只能作为include包含进来，不能直接编译
#vlog -incr +incdir+$INCLUDE_PATH ../include/*.v
##添加VHDL
#vcom ./flash_src/*.vhd

vlog -work work +incdir+$INCLUDE_PATH +define+SIMULATION ../source_code/rtl/*.v
vlog -incr +incdir+$INCLUDE_PATH ../source_code/rtl/enc_file/*.v
vlog -incr +incdir+$INCLUDE_PATH ../source_code/model/*.v
vlog -incr +incdir+$INCLUDE_PATH +define+SIMULATION ../source_code/tb/*.v
vlog -incr +incdir+$INCLUDE_PATH +define+SIMULATION ../prj/al_ip/*_sim.v

vsim -t ps -voptargs="+acc" +transport_int_delays+transport_path_delay+notimingchecks -L al -L eg work.tb work.glbl
view wave signals

log -r /*
do wave.do
radix unsigned

run 4000ms
stop
