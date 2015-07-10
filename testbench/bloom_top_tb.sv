`include "defines.vh" // Defining filenames and filer parameters

module bloom_top_tb;

timeunit           1ns;
timeprecision      0.1ns;


// Initializing signals for simulation
//

bit                rst_done;
bit                bloom_set_done;
bit                send_data_done;

// Input ports of Bloom-filter
//

logic              clk;
logic              rst;

logic              match;
logic              match_val;

bloom_setting_if   bsi( clk );

bloom_data_if      bdi( clk );


// Generating clock
//
initial
  begin
    clk = 1'b0;
    forever
      begin
        #10 clk = !clk;
      end
  end

// Generating reset
//
initial
  begin
    rst = 1'b0;
    @( posedge clk );
    rst = 1'b1;
    @( posedge clk );
    rst = 1'b0;

    rst_done = 1'b1;
    $display( "RESET DONE" );
  end

// Writing strings in memory of Bloom-filter
//
initial
  begin
    wait( rst_done )

    bsi.read_bloom_settings( `SETTINGS_FNAME );

    bloom_set_done = 1'b1;
    $display( "STRINGS WRITING DONE" );
  end


// Sending data for checking
//

int total_data_cnt;

initial
  begin
    wait( bloom_set_done )

    bdi.send_data_bloom( `DATA_FNAME , total_data_cnt);

    send_data_done = 1'b1;
    $display( "SEND DATA DONE" );
  end


// Monitoring result of Bloom-filter checking
//

int total_cnt;
int match_cnt;

initial
  begin
    total_cnt = 0;
    match_cnt = 0;
    forever
      begin
        @(posedge clk )
        if( match_val )
          begin
            total_cnt = total_cnt + 1;
            $display( ">> Total data send:    %d", total_cnt );
            if( match )
              match_cnt = match_cnt + 1;
              $display( ">> Data with patterns: %d", match_cnt );
          end
      end
  end


// Writing output file
// format of file:
// number of data in input file, match(1) or nomatch(0) flag
//
// 0 1
// 1 1
// 2 0
// 3 1
//

int i;
int mcd;

initial
  begin
    mcd = $fopen( `OUTDATA_FNAME );
    $fdisplay( mcd, "DATA N | MATCH/NOMATCH" );
    i = 1;
    forever
      begin
        @( posedge clk )
        if( match_val )
          begin
            if( match )
              $fdisplay( mcd, "%0d", i, " 1");
            else
              $fdisplay( mcd, "%0d", i, " 0");
            i = i + 1;
          end
      end
  end

//top_bloom portmap
top_bloom #(

  .MIN_S      ( `MIN_S      ),
  .MAX_S      ( `MAX_S      ),
  .HASH_CNT   ( `HASH_CNT   ),
  .HASH_WIDTH ( `HASH_WIDTH )

) DUT (

  .clk_i          ( clk          ),
  .rst_i          ( rst          ),
 
  .data_i         ( bdi.data     ),
  .data_eop_i     ( bdi.data_eop ),
  .data_val_i     ( bdi.data_val ),

  .bsi            ( bsi          ), 

  .match_o        ( match        ),
  .match_val_o    ( match_val    )

);

endmodule
