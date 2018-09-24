
`ifndef ENCODER_XX6812_V
`define ENCODER_XX6812_V

module encoder_xx6812(
    /** The bit segment clock, i.e. 3 MHz */
    input clock_3mhz,

    /** Reset the bit counter and initiate transmission sequence */
    input counter_reset,

    /** 3 channels of 8 bit LED intensity */
    input[23:0] parallel_data_in,

    /** xx6812 serial signal output */
    output reg serial_data_out,

    /** High, when the transmission of 24 bits completed, else low */
    output reg done,

    /** Make the internal bit counter available, e.g. for debugging */
    output reg[4:0] bit_counter
    );

/** Discriminate the four stages of transmitting one data bit */
reg[1:0] state;

always @(posedge clock_3mhz or posedge counter_reset)
begin
    if (counter_reset)
    begin
        bit_counter <= 23;
        state <= 0;
        done <= 0;
        serial_data_out <= 0;
    end
    else begin
        if (~done)
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
                        done <= 1;
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
