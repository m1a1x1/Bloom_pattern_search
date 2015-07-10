//////////////////////////////////////////////////
//    Main module of Bloom pattern search       //
//////////////////////////////////////////////////
//                                              //
// Author: Tolkachev Maxim                      //
//                                              //
// Date: 08.07.2015                             //                                         
//                                              //
// Description:                                 //                      
//   Module search in data_i interface patterns //
// written there by bsi interface.              //
//                                              //
//   Parameters MIN_S and MAX_S can be changed  //
// here. HASH_CNT and HASH_WIDTH can't be.      //
//                                              //
//                                              //
//   For more information see README.           //
//                                              //
//////////////////////////////////////////////////

module top_bloom
#(
  parameter MIN_S      = 4,
  parameter MAX_S      = 16,
  parameter HASH_CNT   = 10,
  parameter HASH_WIDTH = 12
)
(
  input                 clk_i,      //    _
  input                 rst_i,      // __| |____ active 1
  
                                    // data     - __<   data     >___
  input [7:0]           data_i,     //                          _
  input                 data_eop_i, // data_eop - _____________| |__
  input                 data_val_i, //               ____________
                                    // data_val - __|            |__
  bloom_setting_if.app  bsi,        // bsi - interface for setting bloom

  output logic          match_o,
  output logic          match_val_o
);

logic [MAX_S:MIN_S][HASH_CNT-1:0][HASH_WIDTH-1:0] hash_gen;
logic [MAX_S:MIN_S]                               hash_val_gen;

logic [MAX_S-1:0][7:0]                            rx_data_w;     //transition between rout data_o and hash symbs_data_i 
logic                                             rx_eop_w;
logic [MAX_S-1:0]                                 rx_data_val_w; //transition between rout val_o and hash symbs_d_val_i


logic [MAX_S:MIN_S]                               match_tmp;
logic                                             match_all;
logic                                             match_flag;
logic                                             clr_all;
logic [MAX_S:MIN_S]                               full_clr_tmp;

logic                                             rx_eop_d1;
logic                                             rx_eop_d2;

logic                                             rx_data_val_d1;
logic                                             rx_data_val_d2;

//connecting rx module
bloom_rx b_rx(

  .clk_i                  ( clk_i             ),
  .rst_i                  ( rst_i             ),

  .data_i                 ( data_i            ),
  .data_eop_i             ( data_eop_i        ),
  .data_val_i             ( data_val_i        ),

  .data_o                 ( rx_data_w         ),
  .data_eop_o             ( rx_eop_w          ),
  .data_val_o             ( rx_data_val_w     )

);
defparam b_rx.MAX_S = MAX_S;

//connecting generated hash modules
genvar k;
generate
  for( k = MIN_S;  k < ( MAX_S + 1 ); k++ )
    begin : hashd
      crc32_hash hs(

        .clk_i            ( clk_i             ),
        .rst_i            ( rst_i             ),

        .symbs_data_i     ( rx_data_w       ),
        .symbs_data_val_i ( rx_data_val_w   ),
     
        .hash_o           ( hash_gen[ k ]     ),
        .hash_val_o       ( hash_val_gen[ k ] )

      );

      defparam hashd[ k ].hs.BF_N       = k;
      defparam hashd[ k ].hs.MAX_S      = MAX_S;
      defparam hashd[ k ].hs.HASH_CNT   = HASH_CNT;
      defparam hashd[ k ].hs.HASH_WIDTH = HASH_WIDTH;
    end
endgenerate


logic [MAX_S:MIN_S] bloommem_ready;
logic [MAX_S:MIN_S] bloommem_clr_done;

assign bsi.ready         = &bloommem_ready;
assign bsi.full_clr_done = &bloommem_clr_done;

//connecting generated bloommem modules
generate
  for( k = MIN_S;  k < ( MAX_S + 1 ); k++ )
    begin : bloommem
      bloom_setting_if b_if( clk_i );
      
      always_comb
        begin
         b_if.str_len       = bsi.str_len;
         b_if.hash          = bsi.hash;
         b_if.hash_mask_val = bsi.hash_mask_val;
         b_if.wr_stb        = bsi.wr_stb && ( bsi.str_len == k );
         b_if.wr_data       = bsi.wr_data;
         b_if.full_clr_stb  = bsi.full_clr_stb;
        end
     
      assign bloommem_clr_done[ k ] = b_if.full_clr_done;
      assign bloommem_ready[ k ]    = b_if.ready;

      bloommem bl(
        
        .clk_i            ( clk_i             ),
        .rst_i            ( rst_i             ),

        .hash_i           ( hash_gen[ k ]     ),
        .hash_val_i       ( hash_val_gen[ k ] ),
        
        .bsi              ( b_if              ),

        .match_o          ( match_tmp[ k ]    ),
        .long_clr_o       ( full_clr_tmp[k]       )
      );

      defparam bloommem[ k ].bl.BF_N       = k;
      defparam bloommem[ k ].bl.MAX_S      = MAX_S;
      defparam bloommem[ k ].bl.HASH_CNT   = HASH_CNT;
      defparam bloommem[ k ].bl.HASH_WIDTH = HASH_WIDTH;
    end
endgenerate

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        rx_eop_d1 <= 0;
        rx_eop_d2 <= 0;

        rx_data_val_d1 <= 0;
        rx_data_val_d2 <= 0;
      end
    else
      begin
        rx_eop_d1 <= rx_eop_w;
        rx_eop_d2 <= rx_eop_d1;

        rx_data_val_d1 <= rx_data_val_w[ MAX_S-1 ];
        rx_data_val_d2 <= rx_data_val_d1;
      end
  end

assign match_all = |( match_tmp    );
assign clr_all   = |( full_clr_tmp );

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        match_o     <= 0;
        match_val_o <= 0;
        match_flag  <= 0;
      end
    else
      begin
        if( rx_eop_d2 && rx_data_val_d2 ) // End of valid data
          begin
            match_val_o <= 1;                          
            match_flag  <= 0;
            match_o     <= match_flag;
          end
        else
          begin
            match_val_o  <= 0;
            if( clr_all )
              begin
                match_flag <= 0;
              end
            else
              begin
                if( match_all )
                  begin
                    match_flag <= 1;
                  end
                else
                  begin
                    match_flag <= match_flag;
                  end
              end
          end
      end
  end

endmodule
