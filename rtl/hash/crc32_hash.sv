//////////////////////////////////////////////////
//     Hash calculator based on crc32           //
//////////////////////////////////////////////////
//                                              //
// Author: Tolkachev Maxim                      //
//                                              //
// Date: 08.07.2015                             //                                         
//                                              //
// Description:                                 //                      
//   Module calculate 10 hashes from input data.//
//                                              //
//   In this implementation parameters HASH_CNT //
// and HASH_WIDTH can't be changed.             //
//                                              //
//                                              //
//   For more information see README.           //
//                                              //
//////////////////////////////////////////////////

module crc32_hash
#(
  parameter BF_N       = 4,
  parameter MAX_S      = 32,

  parameter HASH_CNT   = 10,

  parameter HASH_WIDTH = 12
)

(
  input                                       clk_i,
  input                                       rst_i,

  input        [MAX_S-1:0][7:0]               symbs_data_i,   
  input        [MAX_S-1:0]                    symbs_data_val_i,

  output logic [HASH_CNT-1:0][HASH_WIDTH-1:0] hash_o,
  output logic                                hash_val_o
);

logic [BF_N-1:0][7:0] data_tmp;
logic                 hash_val;


//reversing data and val
logic [MAX_S-1:0][7:0] data_rev;
logic [MAX_S-1:0]      data_val_rev;
logic [MAX_S-1:0][7:0] data_rev_d;    
logic [MAX_S-1:0]      data_val_rev_d;

always_comb
  begin
    data_rev     = 0;
    data_val_rev = 0;
    for( int i = 0; i < MAX_S; i++ )
      begin
        data_rev[ i ] 	  = symbs_data_i[ MAX_S - i - 1 ]; 
        data_val_rev[ i ] = symbs_data_val_i[ MAX_S - i - 1 ];
      end
  end

//для улучшения частотных свойств  
always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        data_rev_d     <= 1'b0; 
        data_val_rev_d <= 1'b0;
      end
    else
      begin
        data_rev_d     <= data_rev;
        data_val_rev_d <= data_val_rev;
      end
  end

//hash val  
assign hash_val = &( data_val_rev_d [BF_N-1:0] );
 
//geting N data
assign data_tmp = data_rev_d[BF_N-1:0];

logic [3:0][31:0] crc32_res;

//crc32 cnt with different polinoms:

crc32_POL_1 crc_p_1(

  .string_i    ( data_tmp     ),
  .crc32_res_o ( crc32_res[3] )
  
);
defparam crc_p_1.BYTES_CNT = BF_N;

crc32_POL_2 crc_p_2(

  .string_i    ( data_tmp     ),
  .crc32_res_o ( crc32_res[2] )
  
);
defparam crc_p_2.BYTES_CNT = BF_N;

crc32_POL_3 crc_p_3(

  .string_i    ( data_tmp     ),
  .crc32_res_o ( crc32_res[1] )
  
);
defparam crc_p_3.BYTES_CNT = BF_N;

crc32_POL_4 crc_p_4(

  .string_i    ( data_tmp     ),
  .crc32_res_o ( crc32_res[0] )
  
);
defparam crc_p_4.BYTES_CNT = BF_N;

//getting 10 hash function from crc32 results:
logic [127:0]                        crc32_res_all;
logic [HASH_CNT-1:0][HASH_WIDTH-1:0] hash_tmp;
logic [HASH_CNT-1:0][HASH_WIDTH-1:0] hash_rev;
 
assign crc32_res_all = crc32_res;

assign hash_tmp = crc32_res_all[127:( 127 - HASH_CNT * HASH_WIDTH + 1 )];

//reversing hash:
always_comb
  begin
    for( int i = 0; i < HASH_CNT; i++ )
      begin
        hash_rev[i] = hash_tmp[HASH_CNT-1-i];
      end
  end


always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        hash_o     <= 0;
        hash_val_o <= 0;
      end
    else
      begin
        hash_o     <= hash_rev;
        hash_val_o <= hash_val;
      end
  end

endmodule
