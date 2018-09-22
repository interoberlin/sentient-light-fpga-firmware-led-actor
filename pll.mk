
pll: pll_36mhz.v

pll_36mhz.v:
	icepll -i 12 -o 36 -qmf $@
