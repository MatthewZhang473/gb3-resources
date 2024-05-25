DESIGN = dspadder
GB3_ROOT = /gb3-resources
sail-nextpnr:
	mkdir -p $(GB3_ROOT)/build
	yosys $(GB3_ROOT)/dspadder/yscripts/$(DESIGN).ys
	nextpnr-ice40 --up5k --package uwg30 --json $(DESIGN).json --pcf $(DESIGN).pcf --asc $(DESIGN).asc
	icepack $(DESIGN).asc design.bin
	cp design.bin $(GB3_ROOT)/build/


clean:
	rm -f *.json *.blif *.asc *.bin