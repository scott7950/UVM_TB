
ifeq ($(GUI), 1)
    GUI_ARG = -gui
endif

PROJECT_DIR = /mnt/uvm
RTL_DIR = $(PROJECT_DIR)/rtl
RTL = $(RTL_DIR)/dut.v

TB_DIR = $(PROJECT_DIR)/env
INCDIR = +incdir+$(TB_DIR)

CPU_INTF_TB_DIR = $(TB_DIR)/cpu_interface_env
INCDIR += +incdir+$(CPU_INTF_TB_DIR)

PKT_TB_DIR = $(TB_DIR)/packet_env
INCDIR += +incdir+$(PKT_TB_DIR)

SEQUENCE_DIR = $(PROJECT_DIR)/sequence
INCDIR += +incdir+$(SEQUENCE_DIR)

CPU_SEQUENCE_DIR = $(SEQUENCE_DIR)/cpu_interface_sequence
INCDIR += +incdir+$(CPU_SEQUENCE_DIR)

PACKET_SEQUENCE_DIR = $(SEQUENCE_DIR)/packet_sequence
INCDIR += +incdir+$(PACKET_SEQUENCE_DIR)

UVM_TB_TOP = $(TB_DIR)/top.sv

TEST_DIR = $(PROJECT_DIR)/test
TEST_FILE = $(TEST_DIR)/test.sv
INCDIR += +incdir+$(TEST_DIR)

COMPILE_LOG_ARG = -l vcs.log

WAVE_ARG = +define+WAVE_ON=1

UVM_COMPILE_ARG = +incdir+/mnt/uvm/uvm-1.2/src /mnt/uvm/uvm-1.2/src/uvm.sv

COMPILE_ARG = -sv -novopt
COMPILE_ARG += $(UVM_COMPILE_ARG) $(INCDIR) $(COMPILE_LOG_ARG) $(WAVE_ARG)

RUN_LOG_ARG = -l simv.log

SCRIPT_DIR = $(PROJECT_DIR)/script
RUN_TCL = $(SCRIPT_DIR)/do.tcl

RUN_ARG  = $(RUN_LOG_ARG) $(GUI_ARG) 
RUN_ARG += +UVM_TESTNAME=test +UVM_VERBOSITY=UVM_FULL -c -novopt -sv_lib lib/uvm_dpi work.top -do $(RUN_TCL) -wlf wave.wlf

SEED = 1

MIT_HOME = /home/tools/questasim/questasim/include
UVM_DPI_DIR = /mnt/uvm/uvm-1.2/src/dpi
UVM_DPI_FILE = /mnt/uvm/uvm-1.2/src/dpi/uvm_dpi.cc

UVM_DPI_COMPILE_ARG = -m32 -fPIC -DQUESTA -g -W -shared
UVM_DPI_COMPILE_ARG += -I$(MIT_HOME) -I$(UVM_DPI_DIR) $(UVM_DPI_FILE)

default: test 

test: lib/uvm_dpi.so compile run

run:
	vsim $(RUN_ARG)

compile:
	if [ ! -d work ]; then vlib work; fi;
	vlog $(COMPILE_ARG) $(UVM_TB_TOP) $(RTL)

lib/uvm_dpi.so:
	if [ ! -d lib ]; then mkdir lib; fi
	g++ $(UVM_DPI_COMPILE_ARG) -o $@

clean:
	rm -rf simv simv.* *log

