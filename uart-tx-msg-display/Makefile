
SRC_TX = transmitter.v 		\
		 transmitter_tb.v 	\
		 fsm_2.v 			\
		 ../btn-debouncer-sync/btn_debouncer_sync.v \
		 ../uart-tx-rx-modules/uart_tx.v 

OUT_TX = transmitter.bin
WAV_TX = transmitter.vcd

LOG_FILE = transmitter.log

transmitter : $(WAV_TX)

$(OUT_TX) : $(SRC_TX)
	iverilog -Wall -o $@ $(SRC_TX)

$(WAV_TX) : $(OUT_TX)
	vvp -l $(LOG_FILE) $<

clean:
	rm -rvf *.log *.bin *.vcd


