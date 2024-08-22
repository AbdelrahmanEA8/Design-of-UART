module UART_RX #(parameter DATA_WIDTH=8)(
    input clk,
    input rst,
    input [5:0] prescale,
    input PAR_EN,
    input PAR_TYP,
    input RX_IN,
    output [DATA_WIDTH-1:0] P_DATA,
    output DATA_VLD,
    output PAR_ERR,
    output STP_ERR
);
//UART_RX Wires
wire [5:0] edge_cnt_wire;
wire [3:0] bit_cnt_wire;
wire strt_glitch_wire;
wire dat_samp_en_wire;
wire deser_en_wire;
wire stp_chk_en_wire;
wire strt_chk_en_wire;
wire par_chk_en_wire;
wire count_enable_wire;
wire sampled_bit_wire;

// Modules Instantiation
FSM_RX module1 (
    .RX_IN(RX_IN),
    .clk(clk),
    .rst(rst),
    .edge_cnt(edge_cnt_wire),
    .bit_cnt(bit_cnt_wire),
    .prescale(prescale),
    .stp_err(STP_ERR),
    .strt_glitch(strt_glitch_wire),
    .par_err(PAR_ERR),
    .PAR_EN(PAR_EN),
    .dat_samp_en(dat_samp_en_wire),
    .deser_en(deser_en_wire),
    .data_valid(DATA_VLD),
    .stp_chk_en(stp_chk_en_wire),
    .strt_chk_en(strt_chk_en_wire),
    .par_chk_en(par_chk_en_wire),
    .count_enable(count_enable_wire)
);
edge_bit_counter module2 (
    .clk(clk),
    .rst(rst),
    .enable(count_enable_wire),
    .prescale(prescale),
    .edge_cnt(edge_cnt_wire),
    .bit_cnt(bit_cnt_wire)
);
data_sampling module3 (
    .RX_IN(RX_IN),
    .clk(clk),
    .rst(rst),
    .edge_cnt(edge_cnt_wire),
    .dat_samp_en(dat_samp_en_wire),
    .prescale(prescale),
    .sampled_bit(sampled_bit_wire)
);
deserializer module4 (
    .sampled_bit(sampled_bit_wire),
    .deser_en(deser_en_wire),
    .clk(clk),
    .rst(rst),
    .edge_cnt(edge_cnt_wire),
    .prescale(prescale),
    .p_out(P_DATA)
);
Parity_check module5 (
    .clk(clk),
    .rst(rst),
    .PAR_TYP(PAR_TYP),
    .par_chk_en(par_chk_en_wire),
    .prescale(prescale),
    .sampled_bit(sampled_bit_wire),
    .p_out(P_DATA),
    .par_err(PAR_ERR)
);
strt_check module6 (
    .clk(clk),
    .rst(rst),
    .strt_chk_en(strt_chk_en_wire),
    .sampled_bit(sampled_bit_wire),
    .strt_glitch(strt_glitch_wire)
);
stop_check module7 (
    .clk(clk),
    .rst(rst),
    .stp_chk_en(stp_chk_en_wire),
    .sampled_bit(sampled_bit_wire),
    .stp_err(STP_ERR)
);

endmodule