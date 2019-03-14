
#
# Generate a bitstream for the iCEstick platform
#

icestick.pcf: icestick-default.pcf icestick-pinout.pcf
	cat $^ > $@

# place and route
top-icestick.asc: top.json icestick.pcf
	nextpnr-ice40 --hx1k --json top.json --pcf icestick.pcf --asc $@

# timing analysis and bitstream packing
top-icestick.bin: top-icestick.asc
	#icetime -tmd hx1k $<
	icepack $< $@

icestick: top-icestick.bin

# flash onto target
flash-icestick: top-icestick.bin
	iceprog $<
