//////////////////////////////////////////////////
//    Memory module of Bloom pattern search     //
//////////////////////////////////////////////////
//                                              //
// Author: Tolkachev Maxim                      //
//                                              //
// Date: 08.07.2015                             //                                         
//                                              //
// Description:                                 //                      
//   Module get the hash functions and cosired  //
// them as memory addres. bsi interface uses    //
// for writing new srtings.                     //
//                                              //
//   Parameters MIN_S and MAX_S can be changed  //
// here. HASH_CNT and HASH_WIDTH can't be.      //
//                                              //
//                                              //
//   For more information see README.           //
//                                              //
//////////////////////////////////////////////////

module bloommem
#(
  parameter BF_N       = 10,
  parameter MAX_S      = 32,
  parameter HASH_CNT   = 10,
  parameter HASH_WIDTH = 12
)
(
  input                                clk_i,
  input                                rst_i,

  input [HASH_CNT-1:0][HASH_WIDTH-1:0] hash_i,
  input                                hash_val_i,

  bloom_setting_if.app                 bsi,

  output logic                         match_o,
  output logic                         long_clr_o
  
);

logic [HASH_CNT-1:0]                 read_data; // q_a and q_b for every hash     

logic [HASH_CNT-1:0]                 wr_en;
logic [HASH_CNT-1:0][HASH_WIDTH-1:0] addr;

logic                                match;

logic                                val_for_matching;

logic                                wr_req;
logic                                wr_delayed;

logic [HASH_WIDTH-1:0]               f_clr_cnt;
logic                                long_clr;

assign long_clr_o = long_clr;

// prolonging strobe
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        long_clr <= 1'b0;
        bsi.full_clr_done <= 0;
      end
    else
      begin
        if( bsi.full_clr_stb )
          begin
            long_clr <= 1'b1;
            bsi.full_clr_done <= 1'b0;
          end
        else
          begin
            if( f_clr_cnt == ( 2**HASH_WIDTH - 1 ) )  // counter is full, all clear
              begin
                long_clr <= 1'b0;
                bsi.full_clr_done <= 1'b1;
              end
          end
      end
  end

// counter for full memory reset
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      f_clr_cnt <= '0;
    else
      if( long_clr )
        f_clr_cnt <= f_clr_cnt + 1;
      else 
        if( f_clr_cnt == ( 2**HASH_WIDTH - 1 ) )  // counter is full, all clear
          f_clr_cnt <= '0;
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      wr_req <= '0;
    else
      if( wr_delayed )
        wr_req <= 1'b0;
      else
        if( bsi.wr_stb )
          wr_req <= 1'b1;
  end

assign match = ( &( read_data ) ) && !long_clr;  // no matching while full clear

assign wr_en = {HASH_CNT{wr_delayed}} & bsi.hash_mask_val | {HASH_CNT{long_clr}};

always_comb
  begin
    if( !long_clr )
      begin
        if( wr_delayed )
          addr = bsi.hash;
        else
          addr = hash_i;
      end
    else
      addr = {HASH_CNT{f_clr_cnt}};
  end

assign wr_delayed = wr_req && ( !hash_val_i );

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        match_o <= 0;
        val_for_matching <= 0;
      end
    else
      begin
        match_o          <= ( match & val_for_matching );
        val_for_matching <= hash_val_i;
      end
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        bsi.ready <= 1'b1;
      end
    else
      begin
        if( !bsi.ready && !wr_req )
          bsi.ready <= 1'b1;

        if( wr_delayed )
          bsi.ready <= 1'b1;
        else    
          if( bsi.wr_stb )
            bsi.ready <= 1'b0;
          if( long_clr )
            bsi.ready <= 1'b0;
      end
  end

logic  wr_dt;
assign wr_dt = long_clr ? '0 : bsi.wr_data;

genvar i;
generate
  for( i = 0; i < ( HASH_CNT / 2 ); i++ ) 
    begin : true_dual_port_ram_single_clock
      true_dual_port_ram_single_clock    dr(
        
        .clk       ( clk_i                  ),

        .we_a      ( wr_en[ 2 * i ]         ),
        .we_b      ( wr_en[ 2 * i + 1 ]     ),

        .data_a    ( wr_dt                  ),
        .data_b    ( wr_dt                  ),

        .addr_a    ( addr[ 2 * i ]          ),
        .addr_b    ( addr[ 2 * i + 1 ]      ),

        .q_a       ( read_data[ 2 * i ]     ),
        .q_b       ( read_data[ 2 * i + 1 ] )

      );
      defparam true_dual_port_ram_single_clock[ i ].dr.DATA_WIDTH = 1;
      defparam true_dual_port_ram_single_clock[ i ].dr.ADDR_WIDTH = HASH_WIDTH;
    end
endgenerate

endmodule
