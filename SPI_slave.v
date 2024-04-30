module SPI_SLAVE(MOSI,SS_n, clk,,reset, rx_data,rx_valid,tx_data,tx_valid,MISO);

  parameter IDILE =3'b0;
  parameter CHK_CMD =3'b001;
  parameter WRITE =3'b010;
  parameter READ_ADD =3'b011;
  parameter READ_DATA =3'b100;

  
    input MOSI,tx_valid,SS_n;
    input clk,reset;
    input [7:0] tx_data;
    output reg [9:0] rx_data;
    output reg MISO;
    output reg rx_valid;
	
 //internal signal
    reg SEL;	
    reg cntrl ;
    reg [10:0] temp;
    reg [2:0] ns,cs;




    integer i=0;
    integer j=7;

 // STATE MEMORY
   always @(posedge clk or negedge reset)begin
    if(!reset)
      cs<=IDILE;
    else 	  
       cs<=ns;
   end





  
 //OUTPUT LOGIC 
   always @( posedge clk or negedge reset) begin
        if (!reset)begin
            temp<=0;
            SEL<=0;
			rx_data<=0;
			rx_valid<=0;
			MISO<=0;
			
        end
	  
        else begin
          case (cs)
		    WRITE : begin
		
		        if(i<=11) begin
                    temp[i] <= MOSI;
                    i<=i+1;
                end
                 
				if(i==4'd11)begin
                    i<=0;
                    rx_data <= temp[10:1];
                    rx_valid<=1'b1;
     	            cntrl<=temp[0];
                    temp<=11'd0;
                end
            end
			
			
		    READ_ADD: begin
			
		        if(i<=11) begin
                   temp[i] <= MOSI;
                   i<=i+1;
                end
                if(i==4'd11)begin
                   i<=0;
                   rx_data <= temp[10:1];
                   rx_valid<=1'b1;
     	           cntrl<=temp[0];
                   temp<=11'd0;
		        end
		    end
		 
		    READ_DATA:begin
			
		        if(i<=11) begin
                  temp[i]<= MOSI;
                  i<=i+1;
                end
                if(i==4'd11)begin
                  i<=0;
                  rx_data <= temp[10:1];
                  rx_valid<=1'b1;
     	          cntrl<=temp[0];
                  temp<=11'd0; 
				end
				  
                if(tx_valid) begin  
                  if(j>=0) begin
                    MISO<=tx_data[j] ;
                    j <= j-1;
                  end
		        end 
			    if(j=='b0)begin
                   j<=7;
        
                end
			    SEL<=0;
            end
		    default :rx_data<=0;
        endcase
      end
     
    end

 
 //NEXT STATE MEMORY
	always @(*) begin
		case (cs)
			IDILE: begin
				if (SS_n)
					ns = IDILE;
				else 
					ns = CHK_CMD;
			end
			WRITE: begin
				if (SS_n)
					ns = IDILE;
				else if(SS_n==0&& !cntrl)
					ns = WRITE;
			end		
			CHK_CMD: begin
				if (!SS_n && !MOSI)
					ns = WRITE;
				else if( SS_n)
					ns = IDILE;
					
                else if( SS_n==0 && MOSI==1&& !SEL)
					ns = READ_ADD;
					
				 else if( SS_n==0 && MOSI==1&& SEL)
					ns = READ_DATA;	
            end
			READ_ADD: begin
				if (SS_n==1 )
					ns = IDILE;
				else if(SS_n==0&& cntrl&&rx_data[9:8]==2'b10)
					ns = READ_ADD;
			end		
			READ_DATA: begin
				if (SS_n==1 )
					ns = IDILE;
				else if(SS_n==0&& cntrl&&rx_data[9:8]==2'b11)
					ns = READ_DATA;
			end		
			default: 	ns = IDILE;
		endcase
	end
   
	
  
     



endmodule