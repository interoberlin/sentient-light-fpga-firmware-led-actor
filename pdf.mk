
# Visualize generated networks
pdf: top.pdf

show: top.pdf
	evince $< &

top.pdf: $(SRCS:.v=.pdf)
	pdftk $^ cat output $@

%.pdf: %.v
	rm -f ~/.yosys_show.dot ~/.yosys_show2.dot
	yosys -Q -p "read_verilog $(SRCS); hierarchy; select $*; show -format dot -viewer echo;"
	dot -Tpdf ~/.yosys_show.dot > $@

.PHONY: clean-pdfs
clean-pdfs:
	rm -f $(SRCS:.v=.pdf)
