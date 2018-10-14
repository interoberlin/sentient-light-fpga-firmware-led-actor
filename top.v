
`include "clock_generator.v"
`include "uart.v"
`include "uart_handler.v"
`include "led_selector.v"
`include "memory.v"
`include "encoder_xx6812.v"


module top(
    input clock_12mhz,

    input uart_rx,
    input uart_rts,

    output strip,

    output[7:0] led
    );

/** Verify UART input */
assign debug_rx = uart_rx;
assign debug_rts = uart_rts;

/** Verify that the primary clock is working */
assign clock_out = clock_12mhz;

/** Generate all the clocks for this system */
wire clock_115200hz, bit_segment_clock, bit_clock, led_clock, framerate;

/*
 * Scale the clock up to 144 MHz
 */
pll hf_clock(
    .clock_in(clock_12mhz),
    .clock_out(clock_144mhz)
    );

clock_generator clocks(
    .clock_12mhz(clock_12mhz),
    .clock_144mhz(clock_144mhz),
    .clock_115200hz(clock_115200hz),
    .uart_rx(rx),
    .bit_segment_clock(bit_segment_clock),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate)
    );

/** This block decodes the signal on the RX pin as UART */
wire[7:0] uart_rx_data;
assign led[7:0] = uart_rx_data[7:0];
wire uart_rx_data_ready;

uart uart0(
    .clock_115200hz(clock_115200hz),
    .reset(1'b0),
    .rx(uart_rx),
    .rx_data(uart_rx_data),
    .rx_data_ready(uart_rx_data_ready)
    );

/** This block evaluates the bytes received via UART */
wire perform_write;
wire[8:0] write_address;
wire[23:0] write_data;

uart_handler uart_state_machine(
    .clock_12mhz(clock_12mhz),
    .rx_data(uart_rx_data),
    .rx_data_ready(uart_rx_data_ready),
    .rts(uart_rts),
    .perform_write(perform_write),
    .write_address(write_address),
    .write_data(write_data)
    );

/** This block selects the next LED to be transmitted and times the corresponding memory reads */
wire encoder_finished;
// wire perform_read;
wire[7:0] led_counter;

led_selector selector(
    .clock_12mhz(clock_12mhz),
    .bit_clock(bit_clock),
    .led_clock(led_clock),
    .framerate(framerate),
    .encoder_finished(encoder_finished),
    .led_counter_clock(led_counter_clock),
    .led_counter_reset(led_counter_reset),
    .led_counter(led_counter),
    .led_selected(perform_read)
    );

/** Memory to store the LED values */
wire[23:0] strip0_data;
wire encoder_start;

memory ram0(
    .clock(clock_12mhz),
    .perform_read(perform_read),
    .read_address({1'b0, led_counter}),
    .read_data(strip0_data),
    .read_data_ready(encoder_start),
    .perform_write(perform_write),
    .write_address(write_address),
    .write_data(write_data)
    );

/** This block serializes the brightness data of the current LED to the strip output pin */
encoder_xx6812 strip0(
    .clock_3mhz(bit_segment_clock),
    .counter_reset(encoder_start),
    .parallel_data_in(strip0_data),
    .serial_data_out(strip),
    .done(encoder_finished)
    );

endmodule
