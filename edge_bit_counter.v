module edge_bit_counter(
    input enable,
    input clk,
    input rst,
    input [5:0] prescale,
    output reg [5:0] edge_cnt,
    output reg [3:0] bit_cnt
);

// edge_cnt and bit_count
always @(posedge clk or negedge rst) begin
    if(!rst)begin
      bit_cnt<=0;
      edge_cnt<=1;
    end
    else begin
      if (enable) begin
        // edge counter
        if (edge_cnt != prescale) begin
          edge_cnt<=edge_cnt+1;
        end
        else
          edge_cnt<=1;

        // bit counter
        if (bit_cnt==0) begin
          bit_cnt<=1;
        end  
        else if (edge_cnt == prescale)
          bit_cnt<=bit_cnt+1;
    end
    else begin
      edge_cnt<=0;
      bit_cnt<=0;
    end
    end
end

endmodule