module FSM_RX(
    input RX_IN,
    input clk,
    input rst,
    input [5:0] edge_cnt,
    input [3:0] bit_cnt,
    input [5:0] prescale,
    input stp_err,
    input strt_glitch,
    input par_err,
    input PAR_EN,
    output reg dat_samp_en,
    output reg deser_en,
    output reg data_valid,
    output reg stp_chk_en,
    output reg strt_chk_en,
    output reg par_chk_en,
    output reg count_enable

);

wire edge_done,edge_chk_done;
reg [2:0] ns,cs;


parameter IDEL = 0,
          START = 1,
          READ = 2,
          PARITY = 3,
          STOP = 4,
          CHK_ERR = 5;


always @(posedge clk or negedge rst) begin
    if(!rst)
        cs<=IDEL;
    else
        cs<=ns;
end

always @(*) begin
    case (cs)
      IDEL  :
        if(!RX_IN)
            ns=START;
        else
            ns=IDEL;
      START  : begin
        if(bit_cnt==4'b1 && edge_done )begin
            if(!strt_glitch)
                ns=READ;
            else
                ns=IDEL;
        end
        else
            ns=START;
        end
      READ : begin
            if (bit_cnt==(prescale+1) && edge_done) begin
                if (PAR_EN)
                    ns=PARITY;
                else 
                    ns=STOP;
            end
            else
                ns=READ;
        end
      PARITY : begin
        if (bit_cnt==4'd10 && edge_done)
            ns=STOP;
        else 
            ns=PARITY;
        end 
      STOP : begin
        if (PAR_EN) begin
            if (bit_cnt==4'd11 && edge_chk_done)
                ns=CHK_ERR; 
            else
                ns=STOP;
        end
        else begin
            if (bit_cnt==4'd10 && edge_chk_done)
                ns=CHK_ERR;
            else
                ns=STOP;
        end
      end
      CHK_ERR : begin
        if (RX_IN)
            ns=IDEL;
        else
            ns=START;
      end
      default : ns=IDEL;
    endcase
end

always @(*) begin
    case (cs)
      IDEL  : begin
        if (RX_IN) begin
        dat_samp_en=0;
        deser_en=0;
        data_valid=0;
        stp_chk_en=0;
        strt_chk_en=0;
        par_chk_en=0;
        count_enable=0; 
        end
        else begin
        dat_samp_en=1;
        deser_en=0;
        data_valid=0;
        stp_chk_en=0;
        strt_chk_en=1;
        par_chk_en=0;
        count_enable=1;
        end
        end 
      START  : begin
        dat_samp_en=1;
        deser_en=0;
        data_valid=0;
        stp_chk_en=0;
        strt_chk_en=1;
        par_chk_en=0;
        count_enable=1;
        end
      READ : begin
        dat_samp_en=1;
        deser_en=1;
        data_valid=0;
        stp_chk_en=0;
        strt_chk_en=0;
        par_chk_en=0;
        count_enable=1;
      end
      PARITY : begin
        dat_samp_en=1;
        deser_en=0;
        data_valid=0;
        stp_chk_en=0;
        strt_chk_en=0;
        par_chk_en=1;
        count_enable=1;
        end 
      STOP : begin
        dat_samp_en=1;
        deser_en=0;
        stp_chk_en=1;
        strt_chk_en=1;
        par_chk_en=0;
        count_enable=1;
      end
      CHK_ERR : begin
        dat_samp_en=1;
        deser_en=0;
        stp_chk_en=0;
        strt_chk_en=0;
        par_chk_en=0;
        count_enable=0;
        if ((par_err == 0 && stp_err == 0))
            data_valid=1;
        else
            data_valid=0;
      end
      default : begin
        dat_samp_en=0;
        deser_en=0;
        data_valid=0;
        stp_chk_en=0;
        strt_chk_en=0;
        par_chk_en=0;
        count_enable=0;
      end
    endcase
end

assign edge_done = (edge_cnt==(prescale)) ? 1:0;
assign edge_chk_done = (edge_cnt==(prescale-1)) ? 1:0;

endmodule