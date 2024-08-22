module data_sampling (
    input RX_IN,
    input clk,
    input rst,
    input [5:0] edge_cnt,
    input dat_samp_en,
    input [5:0] prescale,
    output reg sampled_bit
);

reg [2:0] sample;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        sample<=1'b0;
    end
    else begin
      if (dat_samp_en) begin
        if(edge_cnt== prescale>>1 || edge_cnt== ((prescale>>1)-1) || edge_cnt== ((prescale>>1)+1))begin
            sample<={sample[1:0],RX_IN};
        end
      end
      else 
        sample<=1'b0;
    end
end
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        sampled_bit<=1'b0;
    end
    else begin
        if (dat_samp_en) begin
            if (edge_cnt== prescale-2) begin
                case (sample)
                3'b000  : sampled_bit<=1'b0;
                3'b001  : sampled_bit<=1'b0;
                3'b010  : sampled_bit<=1'b0;
                3'b011  : sampled_bit<=1'b1;
                3'b100  : sampled_bit<=1'b0;
                3'b101  : sampled_bit<=1'b1;
                3'b110  : sampled_bit<=1'b1;
                3'b111  : sampled_bit<=1'b1;
                endcase
            end
        end
        else
            sampled_bit<=1'b0;
    end
end


endmodule