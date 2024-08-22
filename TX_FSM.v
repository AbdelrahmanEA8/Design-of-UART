module FSM_TX(
    input CLK,
    input RST,
    input DATA_VALID,
    input ser_done,
    input PAR_EN,
    output reg ser_en,
    output reg busy,
    output reg [1:0] mux_sel
);
// States encoding
parameter IDEL = 3'b000,
          START = 3'b001,
          DATA = 3'b011,
          PARITY = 3'b010,
          STOP = 3'b110;

reg [2:0] ns,cs;
reg busy_shift;
always @(posedge CLK or negedge RST) begin
    if(!RST)
        cs<=IDEL;
    else
        cs<=ns;
end
//States transition
always @(*) begin
    if (!RST) begin
        ns=IDEL;
    end
    else begin
        case (cs)
          IDEL  : begin
            if (DATA_VALID)
                ns=START;
              else
                ns=IDEL; 
          end
          START :begin
                ns=DATA;
            end 
          DATA :begin
              if (ser_done) begin
                if (PAR_EN)
                  ns=PARITY;
                else
                  ns=STOP;
              end
              else 
                ns=DATA;
            end 
          PARITY  :begin
              ns=STOP;
            end 
          STOP :begin
              ns=IDEL;
            end 
            default: ns=IDEL;
        endcase
    end
end

always @(*) begin
   if (!RST) begin
    busy_shift=0;
    ser_en=0;
    mux_sel=0;
   end
   else begin
     case (cs)
          IDEL  : begin
            busy_shift=0;
            ser_en=0;
            mux_sel=0;
          end 
          START :begin
            busy_shift=1;
            ser_en=0;
            mux_sel=0;
            end 
          DATA :begin
            busy_shift=1;
            ser_en=1;
            mux_sel=1;
            if (ser_done) begin
              ser_en=0;
            end
            else begin
              ser_en=1;
            end
            end 
          PARITY  :begin
            busy_shift=1;
            ser_en=0;
            mux_sel=2'd2;
            end 
          STOP :begin
            busy_shift=1;
            ser_en=0;
            mux_sel=2'd3;
            end 
            default: begin
              busy_shift=0;
            ser_en=0;
            mux_sel=2'd0;
            end
        endcase
   end
end
always @(posedge CLK or negedge RST) begin
  if (!RST) begin
    busy<=0;
  end
  else begin
    busy<=busy_shift;
  end
end


endmodule