module tap_bloom(

  input                 clk_i,      //    _
  input                 rst_i,      // __| |____ active 1
  
                                    // data     - __<   data     >___
  input [7:0]           data_i,     //                          _
  input                 data_eop_i, // data_eop - _____________| |__
  input                 data_val_i, //               ____________
                                    // data_val - __|            |__
  input [4:0]           str_len_i,
  input [9:0][11:0]     hash_i,
  input [9:0]           hash_mask_val_i,
  input                 wr_stb_i,
  input                 wr_data_i,
  input                 full_clr_stb_i,  // полный сброс памяти

  output                ready_o,
  output                full_clr_done_o,
  
  output logic          match_o,
  output logic          match_val_o

);

logic [7:0]  data;     //                          _
logic        data_eop; // data_eop - _____________| |__
logic        data_val;

logic        match;
logic        match_val;

always_ff @( posedge clk_i )
  begin
    data <= data_i;
    data_eop <= data_eop_i;
    data_val <= data_val_i;
    match_o <= match;
    match_val_o <= match_val;
  end

bloom_setting_if bsi( clk_i );

always_ff @( posedge clk_i )
  begin
  bsi.str_len       <= str_len_i;
  bsi.hash          <= hash_i;
  bsi.hash_mask_val <= hash_mask_val_i;
  bsi.wr_data       <= wr_data_i;
  bsi.wr_stb        <= wr_stb_i;
  bsi.full_clr_stb  <= full_clr_stb_i;

  ready_o           <= bsi.ready;         
  full_clr_done_o   <= bsi.full_clr_done;   
  end


top_bloom #(

  .MIN_S      ( 4      ),
  .MAX_S      ( 16      ),
  .HASH_CNT   ( 10   ),
  .HASH_WIDTH ( 12 )

) DUT (

  .clk_i          ( clk_i        ),
  .rst_i          ( rst_i        ),
 
  .data_i         ( data     ),
  .data_eop_i     ( data_eop ),
  .data_val_i     ( data_val ),

  .bsi            ( bsi          ), 

  .match_o        ( match      ),
  .match_val_o    ( match_val  )

);

endmodule
