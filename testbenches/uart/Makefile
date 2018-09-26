
SRCS = $(wildcard testbench-*.v)
TESTBENCHES = $(SRCS:.v=.vvp)
WAVEFILES = $(TESTBENCHES:.vvp=.lx2)
WAVEPROJECTS = $(WAVEFILES:.lx2=.gtkw)


all: simulate

simulate: $(WAVEFILES)

%.vvp: %.v
	iverilog -I../ -I../../ -o $@ $<

%.lx2: %.vvp
	vvp $^ -lxt2
	mv dump.lx2 $(^:.vvp=.lx2)

show: simulate $(WAVEPROJECTS)

%.gtkw: %.lx2
	gtkwave $@ &

clean:
	rm -f $(WAVEFILES) $(TESTBENCHES)
