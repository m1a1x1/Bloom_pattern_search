///////////////////////////////////////////////////
//          RX module to make queue              //
///////////////////////////////////////////////////
//                                               //
// Author: Tolkachev Maxim                       //
//                                               //
// Date: 08.07.2015                              //                                         
//                                               //
// Description:                                  //                      
//   Module collct data and send it out in wider //
// format.                                       //
//                                               //
//   Output width - MAX_S.                       //
//                                               //
//                                               //
//   For more information see README.            //
//                                               //
///////////////////////////////////////////////////

module bloom_rx
#(
  parameter MAX_S = 8
)
(

  input                   clk_i,
  input                   rst_i,

  input  [7:0]            data_i,
  input                   data_eop_i,
  input                   data_val_i,

  output [MAX_S-1:0][7:0] data_o,
  output                  data_eop_o,
  output [MAX_S-1:0]      data_val_o
  
);

logic [MAX_S-1:0][7:0] tmp_data;
logic [MAX_S-1:0]      tmp_eop;     
logic [MAX_S-1:0]      tmp_val;     

// shift reg для data  
always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        tmp_data <= '0;
        tmp_eop  <= '0;
        tmp_val  <= '0;
      end
    else
      begin
        tmp_data[ 0 ] <= data_i;
        tmp_eop[ 0 ]  <= data_eop_i;
        tmp_val[ 0 ]  <= data_val_i;

        for( int i = 1; i < MAX_S; i++ )
          begin
            tmp_data[ i ] <= tmp_data[ i - 1 ];
            tmp_eop[ i ]  <= tmp_eop[ i - 1 ];
            tmp_val[ i ]  <= tmp_val[ i - 1 ];
          end  
      end
  end

assign data_o      = tmp_data;
assign data_eop_o  = tmp_eop[ MAX_S-1 ];
assign data_val_o  = tmp_val;

endmodule
