vlib work
vlog DSP48A1.v DSP48A1_tb.v block.v
vsim -voptargs=+acc work.DSP48A1_TB
add wave *
run -all
#quit -sim