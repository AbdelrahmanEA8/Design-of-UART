module stop_check(
    input clk,
    input rst,
    input stp_chk_en,
    input sampled_bit,
    output reg stp_err
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        stp_err<=0;
    end
    else begin
      stp_err<= (!sampled_bit) ? 1'b1:1'b0;
    end
end

endmodule