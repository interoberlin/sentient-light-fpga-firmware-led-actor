
#
# Generate a bitstream for the iCEstick platform
#

# place and route
top-icestick.asc: top.blif
	arachne-pnr -d 1k -P tq144 -p icestick.pcf $< -o $@

# timing analysis and bitstream packing
top-icestick.bin: top-icestick.asc
	#icetime -tmd hx1k $<
	icepack $< $@

icestick: top-icestick.bin

# flash onto target
flash-icestick: top-icestick.bin
	iceprog $<
