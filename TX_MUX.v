module TX_MUX(
    input CLK,
    input RST,
    input [1:0] mux_sel,
    input start_bit,
    input stop_bit,
    input ser_data,
    input par_bit,
    output reg TX_OUT
);

reg OUT;

always @(*) begin
    case (mux_sel)
      2'b00  : OUT=start_bit;
      2'b01  : OUT=ser_data;
      2'b10  : OUT=par_bit;
      2'b11  : OUT=stop_bit;
    endcase
end
 
// Output on register (synchronized)
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        TX_OUT<=0;
    end
    else begin
      TX_OUT<=OUT;
    end
end
endmodule