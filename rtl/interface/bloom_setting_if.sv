interface bloom_setting_if
#(
  parameter MIN_S      = 4,
  parameter MAX_S      = 32,
  parameter HASH_CNT   = 10,
  parameter HASH_WIDTH = 12
)
(
  input clk_i
);
  
logic [$clog2(MAX_S):0]                      str_len;
logic [HASH_CNT-1:0][HASH_WIDTH-1:0]         hash;
logic [HASH_CNT-1:0]                         hash_mask_val;
logic                                        wr_stb;
logic                                        wr_data;
logic                                        full_clr_stb;  // полный сброс памяти

logic                                        ready;
logic                                        full_clr_done;

modport app(

  input  str_len,
  input  hash,
  input  hash_mask_val,
  input  wr_data,
  input  wr_stb,
  input  full_clr_stb,

  output ready,
  output full_clr_done

);


// synthesis translate_off

clocking cb @( posedge clk_i );
endclocking

task write( input int _str_len, bit [HASH_CNT-1:0][HASH_WIDTH-1:0] _hash,
                   bit [HASH_CNT-1:0] _hash_mask_val, bit _wr_data );

  wait( ready );

  @cb;
  str_len       <= _str_len;        
  hash          <= _hash;
  hash_mask_val <= _hash_mask_val;
  wr_data       <= _wr_data;

  wr_stb        <= 1'b0;
  
  @cb;
  wr_stb        <= 1'b1;
  
  @cb;
  wr_stb        <= 1'b0;

endtask

task rm_all_str;

  @cb;
  full_clr_stb <= 1'b0;
  @cb;
  full_clr_stb <= 1'b1;
  @cb;
  full_clr_stb <= 1'b0;

  wait( full_clr_done );
endtask

task read_bloom_settings( input string fname );
                          
  int                                str_len;
  bit [HASH_CNT-1:0][HASH_WIDTH-1:0] hash;
  bit [HASH_CNT-1:0]                 hash_mask_val;
  bit                                wr_data;

  integer fd;
  integer code;
  int i = 0;
  
  fd   = $fopen( fname, "r" );

  while( 1 )
    begin
      i++;
      // format: port, str_len, hash[9:0][11:0], hash_mask_val[9:0], wr_data
      code = $fscanf( fd, "%d %h %h %h %h %h %h %h %h %h %h %b %b %b %b %b %b %b %b %b %b %b ", str_len, 
                                          hash[0], hash[1], hash[2], hash[3],
                                          hash[4], hash[5], hash[6], hash[7],
                                          hash[8], hash[9],
                                          hash_mask_val[0], hash_mask_val[1], hash_mask_val[2], hash_mask_val[3], 
                                          hash_mask_val[4], hash_mask_val[5], hash_mask_val[6], hash_mask_val[7], 
                                          hash_mask_val[8], hash_mask_val[9],
                                          wr_data
                    );

      if( code <= 0 )
        begin
          $display("Settings file is ended");
          break;
        end
      else 
        begin
          write( str_len, hash, hash_mask_val, wr_data );
        end
    end

endtask

// synthesis translate_on
endinterface : bloom_setting_if
