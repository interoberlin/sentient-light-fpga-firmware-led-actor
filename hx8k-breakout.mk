
#
# Generate a bitstream for the iCE40-HX8K Breakout Board
#

hx8k-breakout.pcf: hx8k-breakout-default.pcf hx8k-pinout.pcf
	cat $^ > $@

# Place and route
top-hx8k-breakout.asc: top.blif hx8k-breakout.pcf
	arachne-pnr -d 8k -P ct256 -p hx8k-breakout.pcf $< -o $@

hx8k: hx8k-breakout

hx8k-breakout: top-hx8k-breakout.bin

# Timing analysis and bitstream packing
top-hx8k-breakout.bin: top-hx8k-breakout.asc
	#icetime -tmd hx8k $<
	icepack $< $@

flash-hx8k: flash-hx8k-breakout

# Flash bitstream onto target
flash-hx8k-breakout: top-hx8k-breakout.bin
	iceprog $<
