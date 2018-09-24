#
# Makefile to compile Verilog source files
# for iCE40 FPGAs
#
# Author: Matthias Bock <mail@matthiasbock.net>
# License: GNU GPLv3
#

SRCS := $(wildcard *.v)
SRCS := $(filter-out top_synthesized.v, $(SRCS))

all: top.blif

include pll.mk

# Synthesize device specific netlist (LUTs and FFs)
top.blif: $(SRCS)
	yosys -Q -p "synth_ice40 -blif top.blif; write_verilog top_synthesized.v;" $^

include hx8k-breakout.mk

include pdf.mk

.PHONY: clean
clean: clean-pdfs
	rm -f *~ *.blif *.edif *.asc *.bin *.bit pll_*mhz.v hx8k-breakout.pcf netlist-*
