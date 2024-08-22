module TX_serializer #(parameter DATA_WIDTH = 8)(
    input CLK,
    input RST,
    input DATA_VALID,
    input [DATA_WIDTH-1:0] P_DATA,
    input ser_en,
    input busy,
    output ser_done,
    output ser_data
);
reg [DATA_WIDTH-1:0] data;
reg [2:0] count;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        data<=0;
        count<=0;
    end
    else begin
      if (DATA_VALID && !busy) begin
        data<=P_DATA;
        count<=0;
      end
      else begin
        if (ser_en) begin
        data<=data>>1;
        count<=count+1;
        end
      end
    end
end

assign ser_data = data[0];
assign ser_done = (count==7) ? 1:0;
endmodule