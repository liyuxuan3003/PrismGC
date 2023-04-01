#view all module signal in waveform#


add wave sim:/tb/DUT/u1_app_wrrd/*


add wave -noupdate -color #357f77 -height 100 -group 01 -divider

add wave sim:/tb/DUT/u2_ram/*


add wave -noupdate -color #357f77 -height 100 -group 02 -divider

#add wave sim:/tb/DUT/u2_ram/u1_init_ref/*


add wave -noupdate -color #357f77 -height 100 -group 03 -divider
#add wave sim:/tb/DUT/u2_ram/u2_wrrd/*



