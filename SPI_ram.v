module ram_spi(din,rx_valid,tx_valid,clk,rst_n,dout);

  parameter mem_depth=256;
  parameter addr_size=8;
  parameter mem_width =8;
  input [9:0] din;
  input rx_valid,clk,rst_n;
  output reg [7:0]dout;
  output reg tx_valid;

//creating memory
  reg [mem_width-1:0] mem [mem_depth-1:0];
  reg [addr_size:-1] addrW,addrR;



 always@( posedge clk or negedge rst_n) begin

  if (!rst_n)begin
    dout <=8'b0;
    tx_valid<=0;
  end
  else if(rx_valid) begin
    case(din[9:8])
	//hold din internally as write address
      2'b00: begin
        addrW <= din[7:0];
	    tx_valid<=0;
      end
	//write din in the memory with write address held previously 
	  2'b01: begin
        mem[addrW] <=din[7:0];
	    tx_valid<=0;
	  end
	//hold din internally as read address  
      2'b10: begin
        addrR <= din[7:0];
	    tx_valid<=0;
	  end
	//read the memory   
     2'b11: begin
       dout[7:0]<= mem[addrR];
       tx_valid<=1;
	 end
	endcase 
   end
end
endmodule



  
    
   
