
`ifndef ENCODER_XX6812_V
`define ENCODER_XX6812_V

module encoder_xx6812(
    input clock,
    input reset,
    input[23:0] parallel_data_in,
    output reg serial_data_out
    );

reg[4:0] bit_counter;
reg output_enabled;

/** Discriminate the four stages of transmitting one data bit */
reg[1:0] state;

always @(posedge clock or posedge reset)
begin
    if (reset)
    begin
        bit_counter <= 23;
        state <= 0;
        output_enabled <= 1;
    end
    else begin
        if (output_enabled)
        begin
            case (state)
                0:
                    serial_data_out <= 1;
                1:
                    serial_data_out <= parallel_data_in[bit_counter];
                2:
                    serial_data_out <= 0;
                3:  begin
                    serial_data_out <= 0;

                    if (bit_counter > 0)
                        bit_counter <= bit_counter - 1;
                    else
                        output_enabled <= 0;
                    end
            endcase
        end
        else begin
            serial_data_out <= 0;
        end
        state <= state + 1;
    end
end

endmodule

`endif
