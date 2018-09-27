
`ifndef UART_V
`define UART_V

module uart(
    input clock_115200hz,
    input reset,

    input rx,
    input rts,
    output cts,

    output reg receiving,
    output reg[7:0] rx_data,
    output reg rx_data_ready
    );

/** Grant all transmission requests */
assign cts = rts;

/*
 * Receive bits
 */
reg[3:0] bit_counter;
reg[2:0] pause_counter;
wire pause_is_over = pause_counter[0];

always @(posedge clock_115200hz or posedge reset)
begin
    if (reset)
    begin
        bit_counter <= 0;
        pause_counter <= 3'b1;
        rx_data <= 0;
        rx_data_ready <= 0;
        receiving <= 0;
    end
    else begin
        if (receiving)
        begin
            // Sample and store the value at the RX input pin
            rx_data[bit_counter] <= rx;
            // rx_data[bit_counter] <= 1;
            pause_counter <= 0;

            if (bit_counter == 7)
            begin
                // Reception of 8 bit is complete
                receiving <= 0;
                rx_data_ready <= 1;
            end
            else begin
                // Decrement bit counter
                bit_counter <= bit_counter + 1;
            end
        end
        else begin
            // Clear the previously set ready flag
            rx_data_ready <= 0;
            bit_counter <= 0;

            // After receiving wait at least 5 bits before re-enabling the receiver
            // if (~pause_is_over)
            // begin
            //     pause_counter <= pause_counter + 1;
            // end

            // if (pause_is_over && ~rx)
            if (~rx)
            begin
                // After a short pause a start bit was received
                receiving <= 1;
            end
        end
    end
end

endmodule

`endif
