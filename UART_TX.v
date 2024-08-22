module UART_TX #(parameter DATA_WIDTH=8)(
    input CLK,
    input RST,
    input DATA_VALID,
    input PAR_TYP,
    input PAR_EN,
    input [DATA_WIDTH-1:0] P_DATA,
    output busy,
    output S_DATA
);

wire ser_done_wire;
wire ser_en_wire;
wire ser_data_wire;
wire par_bit_wire;
wire [1:0] mux_sel_wire;

// Modules instantiation
FSM_TX DUT1 (
    .CLK(CLK),
    .RST(RST),
    .DATA_VALID(DATA_VALID),
    .ser_done(ser_done_wire),
    .PAR_EN(PAR_EN),
    .ser_en(ser_en_wire),
    .busy(busy),
    .mux_sel(mux_sel_wire)
);
TX_serializer #(.DATA_WIDTH(DATA_WIDTH)) DUT2 (
    .CLK(CLK),
    .RST(RST),
    .DATA_VALID(DATA_VALID),
    .P_DATA(P_DATA),
    .ser_en(ser_en_wire),
    .busy(busy),
    .ser_done(ser_done_wire),
    .ser_data(ser_data_wire)
);
TX_Parity_Calc #(.DATA_WIDTH(DATA_WIDTH)) DUT3 (
    .CLK(CLK),
    .RST(RST),
    .DATA_VALID(DATA_VALID),
    .P_DATA(P_DATA),
    .PAR_TYP(PAR_TYP),
    .PAR_EN(PAR_EN),
    .busy(busy),
    .par_bit(par_bit_wire)
);
TX_MUX DUT4 (
    .CLK(CLK),
    .RST(RST),
    .mux_sel(mux_sel_wire),
    .start_bit(1'b0),
    .stop_bit(1'b1),
    .ser_data(ser_data_wire),
    .par_bit(par_bit_wire),
    .TX_OUT(S_DATA)
);
endmodule