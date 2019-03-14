
pll: $(PLL).v

pll_72mhz.v:
	icepll -i 12 -o 72 -qmf $@
