#
# Makefile to compile Verilog source files
# for iCE40 FPGAs
#
# Author: Matthias Bock <mail@matthiasbock.net>
# License: GNU GPLv3
#

SRCS := $(wildcard *.v)
PLL_V := $(wildcard pll_*.v)
SRCS := $(filter-out top_synthesized.v $(PLL_V), $(SRCS))

PLL = pll_72mhz

all: top.json

include pll.mk

# Synthesize device specific netlist (LUTs and FFs)
top.json: $(SRCS) $(PLL).v
	yosys -Q -p "synth_ice40 -json top.json; write_verilog top_synthesized.v;" $^

#include hx8k-breakout.mk
include icestick.mk

include pdf.mk

timing: hx8k-timing

terminal:
	screen /dev/ttyUSB1 115200

.PHONY: clean
clean: clean-pdfs
	rm -f *~ *.blif *.edif *.asc *.bin *.bit pll_*mhz.v hx8k-breakout.pcf netlist-*

flash: flash-icestick
