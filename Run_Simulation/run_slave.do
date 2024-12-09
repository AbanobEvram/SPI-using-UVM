vlib work
vlog -f list_slave.list +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave -position insertpoint sim:/top/s_if/*
coverage exclude -src ../slave/Design/SPI.sv -line 99 -code b
coverage exclude -src ../slave/Design/SPI.sv -line 27 -code b
coverage exclude -src ../slave/Design/SPI.sv -line 73 -code b
coverage exclude -src ../slave/Design/SPI.sv -line 98 -code b
coverage exclude -src ../slave/Design/SPI.sv -line 37 -code c
coverage exclude -src ../slave/Design/SPI.sv -line 39 -code c
coverage exclude -src ../slave/Design/SPI.sv -line 98 -code c
coverage exclude -src ../slave/Design/SPI.sv -line 102 -code c
run -all