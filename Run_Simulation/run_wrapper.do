vlib work
vlog -f list_wrapper.list +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave -position insertpoint sim:/top/w_if/*
coverage exclude -src ../wrapper/Design/SPI.sv -line 32 -code b
coverage exclude -src ../wrapper/Design/SPI.sv -line 79 -code b
coverage exclude -src ../wrapper/Design/SPI.sv -line 46 -code b
coverage exclude -src ../wrapper/Design/SPI.sv -line 40 -code c
coverage exclude -src ../wrapper/Design/SPI.sv -line 42 -code c
coverage exclude -src ../wrapper/Design/SPI.sv -line 44 -code c
coverage exclude -src ../wrapper/Design/SPI.sv -line 108 -code c
coverage exclude -src ../wrapper/Design/SPI.sv -line 47 -code s
coverage exclude -du SLAVE -togglenode count_rx
coverage exclude -du SLAVE -togglenode count_tx
coverage exclude -du SLAVE -togglenode cs
coverage exclude -du SLAVE -togglenode ns
coverage exclude -src ../wrapper/Design/RAM.sv -line 26 -code b
coverage exclude -src ../wrapper/Design/RAM.sv -line 25 -code c
coverage exclude -du slave_sva -togglenode count_rx
coverage exclude -du slave_sva -togglenode count_tx
coverage exclude -du slave_sva -togglenode cs
coverage save Wrapper_top.ucdb -onexit -du work.Maindesign
run -all

#quit -sim
#vcover report Wrapper_top.ucdb -details -all -output Wrapper_code_coverage.txt