// Modulo de driver de display de 7 segmentos, este modulo toma un numero de 16 bites y lo muestra en 4 displays de 7segm multiplexados
// segmentos[7:0] -> DP-G...A
// digitos[3:0] -> MSD--LSD    (catodo comun)

// Barrido configurable y blanking interdigito
//v0.2

module display_driver(
	input clk,                      // clk: 50MHz
	input [15:0] numero,            //numeros a mostrar en formato DCBA
	output reg [7:0] segmentos,	    //lineas driver de los segmentos
	output reg [3:0] digitos		//lineas driver de los digitos
	);
	

parameter cuenta_top = 8'd249;	//constante parametrizable de tiempo

parameter periodo_blanking = 10'd10;	//10 veces 10uS = 100uS
parameter periodo_muestra  = 10'd100;   //100 veces 10uS = 1mS

reg [9:0] temporizador_display;	//contador para temporizar cuanto tiempo se muestra un digito o se hace blanking
reg [7:0] pre_escaler;				//pre escalador para dividir el clock un poco
reg [3:0] estado_display;			//estado en el que esta el display

reg clock_display;		//registro del clock que va a mover el display  		
reg [3:0] bus_dcba;		//bus que va a contener los bites de DCBA <- TO DO: Modificar para tener Blank y DP.


//------------- prescaler para dividir 50MHz en 500 ----------
// de modo que clock_display = 100KHz -> 10uS cada clock
always @(posedge clk) begin
		if (pre_escaler==cuenta_top) begin
			pre_escaler = 0;
			clock_display = ~clock_display; 
//			if (clock_display == 1'b1) begin 
//				clock_display = 1'b0;
//				end
//			else begin
//				clock_display = 1'b1;
//				end
			end
		else begin
			pre_escaler = pre_escaler+1'b1;
			end
		end

//-------- contador de display y generador de clock ------------
//----------- maquina de etaados para multiplexar display -----------
always @(posedge clock_display) begin
		if (temporizador_display != 9'd0) begin
			temporizador_display <= temporizador_display - 1'b1;
			end
		else begin
			case (estado_display) 
				4'd0   : begin //muestro primer digito.
							 bus_dcba <= numero[15:12]; //segmentos <= 8'h19 para prueba;								 
							 digitos <= 4'b0111;
							 estado_display <= 4'd1;
							 temporizador_display <= periodo_muestra;	//temporizo este periodo
							 end
				4'd1   : begin //hago blanking							
							 //segmentos <= 8'h0;
							 digitos <= 4'b1111;
							 estado_display <= 4'd2;
							 temporizador_display <= periodo_blanking;
							 end
				4'd2   : begin //muestro degundo digito
							 bus_dcba <= numero[11:8];
							 //segmentos <= 8'h22;
							 digitos <= 4'b1011;
							 estado_display <= 4'd3;
							 temporizador_display <= periodo_muestra;	//temporizo
							 end
				4'd3   : begin //hago blanking
							 //segmentos <= 8'h0;
							 digitos <= 4'b1111;
							 estado_display <= 4'd4;
							 temporizador_display <= periodo_blanking;
							 end
				4'd4   : begin //muestro tercer digito
							 bus_dcba <= numero[7:4];;
							 //segmentos <= 8'h44;
							 digitos <= 4'b1101;
							 estado_display <= 4'd5;
							 temporizador_display <= periodo_muestra;	//temporizo
							 end
				4'd5   : begin //hago blanking
							 //segmentos <= 8'h0;
							 digitos <= 4'b1111;
							 estado_display <= 4'd6;
							 temporizador_display <= periodo_blanking;
							 end
				4'd6   : begin //muestro cuarto digito
							 bus_dcba <= numero[3:0];
							 //segmentos <= 8'h7F;
							 digitos <= 4'b1110;
							 estado_display <= 4'd7;
							 temporizador_display <= periodo_muestra;	//temporizo
							 end
				4'd7   : begin //hago blanking
							 //segmentos <= 8'h0;
							 digitos <= 4'b1111;
							 estado_display <= 4'd0;
							 temporizador_display <= periodo_blanking;
							 end
				default : begin //blanking
							 estado_display <= 4'd0;
							 temporizador_display <= periodo_blanking;
							 end
				endcase
			end
end
	

//----------- combinacional para convertir bin a 7 segm	----------
always @(bus_dcba)
    begin
      case (bus_dcba) //           pGFEDCBA
        4'b0000 : segmentos <= 8'b00111111;  //0
        4'b0001 : segmentos <= 8'b00000110;  //1
        4'b0010 : segmentos <= 8'b01011011;  //2
        4'b0011 : segmentos <= 8'b01001111;  //3
        4'b0100 : segmentos <= 8'b01100110;  //4     
        4'b0101 : segmentos <= 8'b01101101;  //5
        4'b0110 : segmentos <= 8'b01111101;  //6
        4'b0111 : segmentos <= 8'b00000111;  //7
        4'b1000 : segmentos <= 8'b01111111;  //8
        4'b1001 : segmentos <= 8'b01101111;  //9
        4'b1010 : segmentos <= 8'b01110111;  //A
        4'b1011 : segmentos <= 8'b01111100;  //b
        4'b1100 : segmentos <= 8'b00111001;  //C 
        4'b1101 : segmentos <= 8'b01011110;  //d
        4'b1110 : segmentos <= 8'b01111001;  //E
        4'b1111 : segmentos <= 8'b01110001;  //F 
      endcase
    end // always @ (bus)
	 
	 
endmodule
