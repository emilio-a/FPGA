// Modulo para hacer un ADC de aproximaciones sucesivas
// de 8 bit usando un DAC R-2R y un LM393
// V0.1

//                              Vcc
//                              /
// Vin ---|+ \                  \
//        |   | s-- comparador--|
//     |--|- /      __________
//     |___________/ DAC R-2R | r_2r  [7:0]
//                 \__________| 
//

module adc_8bit(
    input clk,  //clock de conversion, NO de sistema
    input sc,   //start conversion,
    input comparador,
    output reg eoc, //1=end of conversion, 0=convirtiendo
    output reg [7:0] r_2r,  //salida del DAC    
    output reg [7:0]resultado
    );
    
reg [3:0] estados_adc;
reg sc_interno;

//always @(posedge sc) begin
        //sc_interno <= 1'b1; //senializo sc
        //eoc <= 1'b0;        //senializo busy
//    end
    
always @(posedge clk, posedge sc) begin
	if (sc==1'b1) begin
        sc_interno <= 1'b1; //senializo sc
        eoc <= 1'b0;        //senializo busy	
	end
	else begin
    case (estados_adc)
        4'd0:   begin           //estado idle
            if (sc_interno==1) begin
                sc_interno <=1'b0;
                estados_adc<=4'd2;
                r_2r <=8'b10000000;
            end
        end
        
        4'd1:   begin
            r_2r[7]<=1'b1;  //msb=1
            estados_adc <= 4'd2;
        end
        
        4'd2:   begin
            if (comparador ==0) begin
                r_2r[7]<= 1'b0;
            end 
            r_2r[6]<=1'b1;
            estados_adc<= 4'd3;
        end
        
        4'd3: begin
            if (comparador ==0) begin
                r_2r[6]<= 1'b0;
            end 
            r_2r[5]<=1'b1;
            estados_adc<= 4'd4;
        end
        
        4'd4:   begin
            if (comparador ==0) begin
                r_2r[5]<= 1'b0;
            end 
            r_2r[4]<=1'b1;
            estados_adc<= 4'd5;
        end
        
        4'd5:   begin
            if (comparador ==0) begin
                r_2r[4]<= 1'b0;
            end 
            r_2r[3]<=1'b1;
            estados_adc<= 4'd6;
        end
        
        4'd6:   begin
            if (comparador ==0) begin
                r_2r[3]<= 1'b0;
            end 
            r_2r[2]<=1'b1;
            estados_adc<= 4'd7;
        end
        
        4'd7:   begin
            if (comparador ==0) begin
                r_2r[2]<= 1'b0;
            end 
            r_2r[1]<=1'b1;
            estados_adc<= 4'd8;
        end
        
        4'd8:   begin
            if (comparador ==0) begin
                r_2r[1]<= 1'b0;
            end 
            r_2r[0]<=1'b1;
            estados_adc<= 4'd9;
        end
        
		  4'd9:   begin
            if (comparador ==0) begin
                r_2r[0]<= 1'b0;
            end 
            estados_adc<= 4'd10;
        end
		  
        4'd10:   begin
            resultado <= r_2r;
            eoc <= 1'b1;
            estados_adc<= 4'd0;
        end
        
        default: begin
            estados_adc <=4'd0;
				eoc <= 1'b1;
				sc_interno <=1'b0;
        end
		endcase
	end	//end del if
	end	//end del always
		
endmodule 
