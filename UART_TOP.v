module UART_TOP #(parameter DATA_WIDTH=8)(
    input RX_CLK,
    input RST,
    input [7:0] UART_CONFG,
    input RX_IN,
    input TX_CLK,
    input F_EMPTY,
    input [DATA_WIDTH-1:0] RD_DATA,
    output Busy,
    output TX_OUT,
    output [DATA_WIDTH-1:0] P_DATA,
    output DATA_VLD,
    output PAR_ERR,
    output STP_ERR
);

UART_RX DUT1(
    .clk(RX_CLK),
    .rst(RST),
    .prescale(UART_CONFG[7:2]),
    .PAR_EN(UART_CONFG[0]),
    .PAR_TYP(UART_CONFG[1]),
    .RX_IN(RX_IN),
    .P_DATA(P_DATA),
    .DATA_VLD(DATA_VLD),
    .PAR_ERR(PAR_ERR),
    .STP_ERR(STP_ERR)
);
UART_TX DUT2 (
    .CLK(TX_CLK),
    .RST(RST),
    .DATA_VALID(~F_EMPTY),
    .PAR_TYP(UART_CONFG[1]),
    .PAR_EN(UART_CONFG[0]),
    .P_DATA(RD_DATA),
    .busy(Busy),
    .S_DATA(TX_OUT)
);

endmodule