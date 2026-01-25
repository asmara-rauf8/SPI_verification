CURR_DIR = ${PWD}
VERIF_DIR = ${CURR_DIR}/../
SIM_DIR = ${VERIF_DIR}/sim/
SIMULATOR = vcs
WAVE_SCRIPT = wave.do
WAVE_DIR = ${SIM_DIR}
#DESIGN_DIR = ${VERIF_DIR}/../design/
#DESIGN_FILES = ${DESIGN_DIR}/fifo.sv

OPTS := -ntb_opts
OPTS := $(OPTS) uvm
OPTS := $(OPTS) -l vcs_compile.log
OPTS := $(OPTS) +vcs+lic+wait
OPTS := $(OPTS) -sverilog
OPTS := $(OPTS) -full64
OPTS := $(OPTS) +vpi
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/interface/"
OPTS := $(OPTS) ${VERIF_DIR}/interface/master_clk_intf.sv
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/interface/"
OPTS := $(OPTS) ${VERIF_DIR}/interface/spi_intf.sv
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/package/"
OPTS := $(OPTS) ${VERIF_DIR}/package/pkg.sv
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/tb_top/"
OPTS := $(OPTS) ${VERIF_DIR}/tb_top/master_protocol_module.sv
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/tb_top/"
OPTS := $(OPTS) ${VERIF_DIR}/tb_top/slave_protocol_module.sv
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/tb_top/"
OPTS := $(OPTS) ${VERIF_DIR}/tb_top/top.sv
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/test/"
OPTS := $(OPTS) "+incdir+${VERIF_DIR}/test/sanity_test.sv"
OPTS := $(OPTS) $(DESIGN_FILES)
OPTS := $(OPTS) +vpi
OPTS := $(OPTS) -debug_acc+pp+dmptf
OPTS := $(OPTS) +plusarg_save
OPTS := $(OPTS) +plusarg_ignore
OPTS := $(OPTS) -R
OPTS := $(OPTS) -permit_unmatched_virtual_intf
OPTS := $(OPTS) -timescale="1ps/1ps"
OPTS := $(OPTS) +UVM_TESTNAME=sanity_test
OPTS := $(OPTS) -cm line+cond+tgl+fsm+branch+assert

all:
	vcs ${OPTS}

echo:
	echo $(VERIF_DIR)

clean:
	@rm -rf ${SIM_DIR}/work/
	@rm -rf ${SIM_DIR}/vsim.wlf
	@rm -rf *.vcd
	@rm -rf *.fsdb
	@rm -rf *.log
	@rm -rf transcript
	@rm -rf *.txt
	@rm -rf simv.vdb/
	@rm -rf *.wlf
	@rm -rf simv.daidir/
	@rm -rf ucli.key
	@rm -rf vc_hdrs.h
	@rm -rf simv
	@rm -rf csrc/
