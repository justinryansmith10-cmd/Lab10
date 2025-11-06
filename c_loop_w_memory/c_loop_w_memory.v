module c_loop_w_memory (

	//////////// ADC //////////
	//output		          		ADC_CONVST,
	//output		          		ADC_DIN,
	//input 		          		ADC_DOUT,
	//output		          		ADC_SCLK,

	//////////// Audio //////////
	//input 		          		AUD_ADCDAT,
	//inout 		          		AUD_ADCLRCK,
	//inout 		          		AUD_BCLK,
	//output		          		AUD_DACDAT,
	//inout 		          		AUD_DACLRCK,
	//output		          		AUD_XCK,

	//////////// CLOCK //////////
	//input 		          		CLOCK2_50,
	//input 		          		CLOCK3_50,
	//input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	//output		    [12:0]		DRAM_ADDR,
	//output		     [1:0]		DRAM_BA,
	//output		          		DRAM_CAS_N,
	//output		          		DRAM_CKE,
	//output		          		DRAM_CLK,
	//output		          		DRAM_CS_N,
	//inout 		    [15:0]		DRAM_DQ,
	//output		          		DRAM_LDQM,
	//output		          		DRAM_RAS_N,
	//output		          		DRAM_UDQM,
	//output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	//output		          		FPGA_I2C_SCLK,
	//inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	//output		     [6:0]		HEX4,
	//output		     [6:0]		HEX5,

	//////////// IR //////////
	//input 		          		IRDA_RXD,
	//output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	//inout 		          		PS2_CLK,
	//inout 		          		PS2_CLK2,
	//inout 		          		PS2_DAT,
	//inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW

	//////////// Video-In //////////
	//input 		          		TD_CLK27,
	//input 		     [7:0]		TD_DATA,
	//input 		          		TD_HS,
	//output		          		TD_RESET_N,
	//input 		          		TD_VS,

	//////////// VGA //////////
	//output		          		VGA_BLANK_N,
	//output		     [7:0]		VGA_B,
	//output		          		VGA_CLK,
	//output		     [7:0]		VGA_G,
	//output		          		VGA_HS,
	//output		     [7:0]		VGA_R,
	//output		          		VGA_SYNC_N,
	//output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_1
);

//	Turn on all display
	//assign	HEX0		=	7'h00;
	//assign	HEX1		=	7'h00;
	//assign	HEX2		=	7'h00;
	//assign	HEX3		=	7'h00;
	//assign	HEX4		=	7'h00;
	//assign	HEX5		=	7'h00;
	//assign	GPIO_0		=	36'hzzzzzzzzz;
	//assign	GPIO_1		=	36'hzzzzzzzzz;
	//assign LEDR[9:0] = 10'd0;

wire [8:0]ins;
wire [6:0]seg7_neg_sign;
wire [6:0]seg7_dig0;
wire [6:0]seg7_dig1;
wire [6:0]seg7_dig2;

assign HEX0 = seg7_dig0;
assign HEX1 = seg7_dig1;
assign HEX2 = seg7_dig2; // constant 0
assign HEX3 = seg7_neg_sign;
	
assign ins = SW[8:0];

reg done;
assign LEDR[3:0] = {start, rst, clk, done};
assign LEDR[5:4] = display_control;
assign LEDR[9:6] = S;

wire clk;
assign clk = CLOCK_50;
wire rst;
assign rst = ~KEY[3];
wire start;
assign start = ~KEY[2];
wire [1:0]display_control; // {0 = sum, 1 = my i variable, }
assign display_control = KEY[1:0];

/* memory signals */
reg [4:0] array_mem_addr;
wire [7:0] array_mem_out;
reg [7:0] array_mem_in;
reg array_mem_wren;

/* Seven seg signals */
reg [7:0]seven_seg_in;

/* FSM signals and parameters */
reg [2:0] S;
reg [2:0] NS;
parameter START = 3'd0,
			F_i_0 = 3'd1,
			VAL_i = 3'd2,
			ADD = 3'd3,
			i_INC = 3'd4,
			DONE = 3'd5,
			ERROR =  3'd6;

/* sum and i variables */
reg [31:0] i; // All integers subject to change once reviewing lab specifications
reg [31:0] sum;	// All integers subject to change once reviewing lab specifications

/* instantiate the module to display the 8 bit result */
three_decimal_vals_w_neg two_d(seven_seg_in, seg7_neg_sign, seg7_dig0, seg7_dig1, seg7_dig2);

/* instantiate IP memory for the array of numbers */
array_mem numbers()
	
/* S update always block */
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		S <= START;
	else
		S <= NS;
end

/* NS transitions always block */
always @(*)
begin
	case (S)
		START: if (start == 1'b1) NS = F_i_0;
				else NS = START;
		F_i_0: if(i < 3'd8) NS = VAL_i;
				else NS = DONE;
		VAL_i: NS = ADD;
		ADD: NS = i_INC;
		i_INC: NS = F_i_0;
		default: NS = ERROR;
	endcase
end

/* clocked control signals always block */
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		
	end
	else
	begin
		case (S)
		
		endcase
	end
end
		
always @(*)
begin
	/* Mux for display on seven segs */
	
end

endmodule