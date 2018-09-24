
`ifndef RAM_V
`define RAM_V

module ram(
    input clock,
    input             sel,
    input             we,
    input [SIZE-1:0]  adr,
    input [63:0]      dat_i,
    output reg [63:0] dat_o
    );

parameter SIZE = 4;

reg [63:0] mem [0:(1 << SIZE)-1];
integer    i;

initial begin
for (i = 0; i < (1<<SIZE) - 1; i = i + 1)
mem[i] <= 0;
end

always @(posedge clock)
if (sel & ~we)
dat_o <= mem[adr];

always @(posedge clock)
if (sel & we)
mem[adr] <= dat_i;

endmodule

`endif
