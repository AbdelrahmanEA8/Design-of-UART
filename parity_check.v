module Parity_check #(parameter DATA_WIDTH=8)(
    input clk,
    input rst,
    input PAR_TYP,
    input par_chk_en,
    input [5:0] prescale,
    input sampled_bit,
    input [DATA_WIDTH-1:0] p_out,
    output reg par_err
);

wire parity;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        par_err<=0;
    end
    else begin
        if (par_chk_en) begin
            par_err<= parity ^ sampled_bit;
            end
        end
    end

assign parity = (!PAR_TYP) ? ^p_out : ~^p_out;

endmodule