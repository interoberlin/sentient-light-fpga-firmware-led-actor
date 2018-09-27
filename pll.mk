
pll: $(PLL).v

pll_144mhz.v:
	icepll -i 12 -o 144 -qmf $@
