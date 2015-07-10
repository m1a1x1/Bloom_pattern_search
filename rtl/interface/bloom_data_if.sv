interface bloom_data_if
( 
  input clk_i
);

logic [7:0] data;
logic       data_eop;
logic       data_val;   

modport app(

  input  data,
  input  data_eop,
  input  data_val

);

//synopsys translate_off

clocking cb @( posedge clk_i );
endclocking


task send_one_data( input string   _one_data
                  );
data_val = 1'b0;

for ( int i = 0; i < _one_data.len() ; i++ )
begin
  @cb;
  data = _one_data.getc( i );
  data_val = 1'b1;
  data_eop = 1'b0;
  if( i == ( _one_data.len() - 1 ) )
    begin
      data_eop = 1'b1;
      @cb;
      data_val = 1'b0;
      data_eop = 1'b0;
    end
end

endtask


task send_data_bloom( input  string   fname,
                      output int      total_data_cnt
                    );
integer fd;
integer code;
string  one_data;

int i = 0;

fd = $fopen( fname, "r" );

while( 1 )
  begin
    code = $fscanf( fd, "%s", one_data );
 
    if( code <= 0 )
      begin
        $display("Settings file is ended");
        break;
      end
    else 
      begin
        send_one_data( one_data );
        i = i + 1;
      end
  end

total_data_cnt = i;

endtask

//synopsys translate_on

endinterface : bloom_data_if
