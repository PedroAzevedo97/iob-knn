KNN_DIR:=.
include core.mk

sim:
	make -C $(SIM_DIR) run SIMULATOR=$(SIMULATOR)

sim-clean:
	make -C $(SIM_DIR) clean

sim-waves:
	gtkwave $(SIM_DIR)/knn.vcd &

#fpga:
#	make -C $(FPGA_DIR) run DATA_W=$(DATA_W)

#doc:
#	make -C document/$(DOC_TYPE) $(DOC_TYPE).pdf

#doc-clean:
#	make -C document/$(DOC_TYPE) clean

#fpga-clean:
#	make -C $(FPGA_DIR) clean

clean: sim-clean fpga-clean #doc-clean
