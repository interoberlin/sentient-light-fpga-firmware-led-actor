
`ifndef UART_HANDLER_V
`define UART_HANDLER_V

module uart_handler(
    input clock_12mhz,

    input[7:0] rx_data,
    input rx_data_ready,
    // Note: The RTS pin is inverted, i.e. true => low, false => high
    input slave_select,

    output reg perform_write,
    output reg[8:0] write_address,
    output reg[23:0] write_data
    );

reg[3:0] state;
parameter STATE_COMMAND = 0;
parameter STATE_ARGUMENT = 1;

reg[7:0] command;
parameter COMMAND_SET_LED = 1;

reg[39:0] argument;
reg[3:0] argument_counter;

/**
 * Store the received UART bytes
 */
always @(posedge rx_data_ready or posedge slave_select)
begin
    // RTS or DTR can be used as an asynchronous reset here
    if (slave_select)
    begin
        state <= STATE_COMMAND;
        command <= 0;
        argument <= 0;
        argument_counter <= 0;
    end
    else begin
        case (state)
            STATE_COMMAND:
            begin
                command <= rx_data;
                state <= STATE_ARGUMENT;
            end

            STATE_ARGUMENT:
            begin
                case (argument_counter)
                    0:
                        argument[39:32] <= rx_data[7:0];
                    1:
                        argument[31:24] <= rx_data[7:0];
                    2:
                        argument[23:16] <= rx_data[7:0];
                    3:
                        argument[15:8] <= rx_data[7:0];
                    4:
                        argument[7:0] <= rx_data[7:0];
                endcase

                argument_counter <= argument_counter + 1;
            end
        endcase
    end
end

/**
 * Evaluate the received command sequence
 */
reg _perform_write;

always @(posedge slave_select)
begin
    // The slave select signal is used as/like a clock here
    case (command)
        COMMAND_SET_LED:
        begin
            write_address[8:0] <= {1'b0, argument[31:24]};
            write_data[23:0] <= argument[23:0];
            _perform_write <= ~_perform_write;
        end
    endcase
end

/**
 * Generate write command pulse
 */
reg previous_perform_write;
always @(posedge clock_12mhz)
begin
    previous_perform_write <= _perform_write;
    perform_write <= (previous_perform_write != _perform_write);
end

endmodule

`endif
