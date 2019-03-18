# FPGA firmware for the Sentient Light LED controller

The firmware in this repository compiles to a firmware for the Lattice iCE40-HX1K FPGA.
It is intended to be used on an <a href="https://www.latticesemi.com/icestick">axelsys iCEstick</a>
and an <a href="https://github.com/interoberlin/sentient-light-fpga-rj45-adapter">FPGA-RJ45 adapter</a>
allowing to control sixteen strips of WS2812 or SK6812 LEDs in parallel.
Data transmission from the PC occurs via the ICEstick's USB serial port via the onboard FTDI FT2232H.

## Toolchain

### Beginning March 2019

* Yosys 0.8+127 (git sha1 a2c51d50, gcc 7.3.0-3 -fPIC -O3)
* nextpnr-ice40 (git sha1 97993e7)

### Before March 2019

* Yosys 0.7+449 (git sha1 0659d9ea, gcc 7.3.0-3 -fPIC -Os)
* arachne-pnr 0.1+261+1 (git sha1 c21df00, g++ 7.3.0-3 -O3 -DNDEBUG)
