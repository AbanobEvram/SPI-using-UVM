vlib work
vlog -f list_ram.list +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave -position insertpoint sim:/top/r_if/*
add wave -position insertpoint  \
sim:/top/DUT/mem
run -all