module TX_Parity_Calc #(parameter DATA_WIDTH = 8)(
    input CLK,
    input RST,
    input DATA_VALID,
    input [DATA_WIDTH-1:0] P_DATA,
    input PAR_TYP,
    input PAR_EN,
    input busy,
    output reg par_bit
);
reg [DATA_WIDTH-1:0] data;
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        data<=0;
    end
    else begin
      if (DATA_VALID && !busy) begin
        data<=P_DATA;
      end
    end
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        par_bit<=0;
    end
    else begin
        if (PAR_EN) begin
            if (!PAR_TYP) begin
                 par_bit<= ^data;
              end
              else begin
                par_bit<= ~^data;
              end
        end
        else begin
            par_bit=0;
        end
end
end

endmodule