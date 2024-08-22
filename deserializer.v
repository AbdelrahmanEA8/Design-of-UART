module deserializer #(parameter DATA_WIDTH=8)(
    input sampled_bit,
    input deser_en,
    input clk,
    input rst,
    input [5:0] edge_cnt,
    input [5:0] prescale,
    output reg [DATA_WIDTH-1:0] p_out
);


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        p_out<=0;
    end
    else begin
      if (deser_en) begin
        if (edge_cnt==(prescale-1)) begin
            p_out<={sampled_bit,p_out[7:1]};
        end
      end
    end
end

endmodule