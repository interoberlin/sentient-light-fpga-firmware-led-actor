`timescale 1ns/1ns

`include "../../uart.v"

module test;

initial $dumpvars;


reg reset;
initial #1 reset <= 1;
initial #8 reset <= 0;

reg clock_144mhz;
initial clock_144mhz <= 0;
always #1 clock_144mhz <= ~clock_144mhz;

reg clock_12mhz;
initial clock_12mhz <= 0;
reg[2:0] clock_12mhz_counter = 0;
always @(posedge clock_144mhz)
begin
    if (clock_12mhz_counter == 5)
    begin
        clock_12mhz_counter <= 0;
        clock_12mhz <= ~clock_12mhz;
    end
    else begin
        clock_12mhz_counter <= clock_12mhz_counter + 1;
    end
end

reg clock_115200hz;
initial clock_115200hz <= 0;
reg[9:0] clock_115200hz_counter = 0;
always @(posedge clock_144mhz)
begin
    if (clock_115200hz_counter == 625)
    begin
        clock_115200hz_counter <= 0;
        clock_115200hz <= ~clock_115200hz;
    end
    else begin
        clock_115200hz_counter <= clock_115200hz_counter + 1;
    end
end

/*
 * Test signal generation
 */
reg uart_rx;
reg uart_rts;
wire uart_cts;
wire[7:0] data;
wire data_ready;

reg[7:0] test_data = 32'h62; //8'b01011001;
initial
begin
    uart_rx <= 1;
    // Start
    #6000 uart_rx <= 0;
    // 8 bits of data, in LSB-first order
    #2500 uart_rx <= test_data[0];
    #2500 uart_rx <= test_data[1];
    #2500 uart_rx <= test_data[2];
    #2500 uart_rx <= test_data[3];
    #2500 uart_rx <= test_data[4];
    #2500 uart_rx <= test_data[5];
    #2500 uart_rx <= test_data[6];
    #2500 uart_rx <= test_data[7];
    // Stop bit
    #2500 uart_rx <= 1;
end

// End of test signal generation
wire[7:0] data_readback;
initial #40000
begin
    if (data_readback[7:0] == test_data[7:0])
        $display("Success: Data readback matches test data.");
    else
        $display("Failed: Data readback doesn't match test data.");
    $finish;
end


/** Module under test */
uart uart0(
    .clock_115200hz(clock_115200hz),
    .reset(reset),
    .rx(uart_rx),
    .rts(uart_rts),
    .cts(uart_cts),
    .rx_data(data_readback),
    .rx_data_ready(data_ready)
    );

endmodule
