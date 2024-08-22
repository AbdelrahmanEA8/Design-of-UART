module UART_TOP_TB #(parameter DATA_WIDTH=8)();
    reg RX_CLK;
    reg RST;
    reg [7:0] UART_CONFG;
    reg RX_IN;
    reg TX_CLK;
    reg F_EMPTY;
    reg [DATA_WIDTH-1:0] RD_DATA;
    wire Busy;
    wire TX_OUT;
    wire [DATA_WIDTH-1:0] P_DATA;
    wire DATA_VLD;
    wire PAR_ERR;
    wire STP_ERR;

    initial begin
        TX_CLK=0;
        forever begin
            #8; TX_CLK= ~TX_CLK;
        end
    end
    initial begin
        RX_CLK=0;
        forever begin
            #1; RX_CLK= ~RX_CLK;
        end
    end

    initial begin
        //RST All ports
        RST=0;
        UART_CONFG=0;
        RX_IN=0;
        F_EMPTY=1;
        RD_DATA=0;

        @(negedge TX_CLK);
        RST=1;
        UART_CONFG=8'b00100001;
        RD_DATA=8'hA5;
        RX_IN=1;

        @(negedge TX_CLK);
        RX_IN=0;
        F_EMPTY=0;

       repeat(8) begin
         @(negedge TX_CLK);
         RX_IN=$random;
       end
       @(negedge TX_CLK);
       @(negedge TX_CLK);
       RX_IN=1;
       F_EMPTY=1;
       repeat(5) @(negedge TX_CLK);
       $stop;

    end

    
    UART_TOP DUV (
        .RX_CLK(RX_CLK),
        .RST(RST),
        .UART_CONFG(UART_CONFG),
        .RX_IN(RX_IN),
        .TX_CLK(TX_CLK),
        .F_EMPTY(F_EMPTY),
        .RD_DATA(RD_DATA),
        .Busy(Busy),
        .TX_OUT(TX_OUT),
        .P_DATA(P_DATA),
        .DATA_VLD(DATA_VLD),
        .PAR_ERR(PAR_ERR),
        .STP_ERR(STP_ERR)
    );



endmodule