`timescale 1ns / 1ps


module top(
    input clk, 
	input rst,
	input[31:0] bigger,
	input[31:0] smaller,
	
    output sa,
    output sb,
    output sc,
    output sd,
    output se,
    output sf,
    output sg,
    //output dp,
    output d0,
    output d1,
    output d2,
    output d3,
    output d4,
    output d5,
    output d6,
    output d7 
    );
//reg [5:0] first_number,second_number;
reg [20:0] counter;
reg [2:0] status;
reg [6:0] seg_ans,seg_print;
reg [12:0] ans1, ans2;
reg [7:0] scan_total;


//wtite down your code here
always@(posedge clk)begin
	if(rst) begin
		ans1 <= 13'd0;
		ans2 <= 13'd0;
	end
	//second_number <= {sw5,sw4,sw3,sw2,sw1,sw0};
	//first_number <= {sw11,sw10,sw9,sw8,sw7,sw6};
	else begin
		  ans1 <= bigger[12:0];
		  ans2 <= smaller[12:0];
	end
end

//8??(d0~d7)7-segment(a~g)??? dp???k?U????.
assign {d7,d6,d5,d4,d3,d2,d1,d0} = scan_total; //?G???@??LED
//assign dp = ((status==1) || (status==3)) ? 0 : 1;  //1,3 light_on
always@(posedge clk) begin
  counter <=(counter<=100000) ? (counter +1) : 0;
  status <= (counter==100000) ? (status + 1) : status;

	case(status)
		0:begin
			//seg_result <= first_number/10;//6??switch???h??63,63/10=6,???b????
			seg_ans <= ans1/1000;
			scan_total <= 8'b0111_1111;
		end
		1:begin
			//seg_result <= first_number%10;//63%10=3,???b?k??
			seg_ans <= (ans1/100)%10;
			scan_total <= 8'b1011_1111;
		end
		2:begin
			//seg_result <= second_number/10;
			seg_ans <= (ans1/10)%10;
			scan_total <= 8'b1101_1111;
		end
		3:begin
			//seg_result <= second_number%10;
			seg_ans <= ans1%10;
			scan_total <= 8'b1110_1111;
		end
		4:begin
			//seg_result <= answer_number/1000;//63*63=3969,3969/1000=3
			seg_ans <= ans2/1000;
			scan_total <= 8'b1111_0111;
		end
		5:begin
			//seg_result <= (answer_number%1000)/100;//3969%1000=969,969/1000=9
			seg_ans <= (ans2/100)%10;
			scan_total <= 8'b1111_1011;
		end
		6:begin
			//seg_result <= (answer_number%100)/10;
			seg_ans <= (ans2/10)%10;
			scan_total <= 8'b1111_1101;
		end
		7:begin
			//seg_result <= answer_number%10;
			seg_ans <= ans2%10;
			scan_total <= 8'b1111_1110;
		end
		default: status <= status;
	endcase 
end  


assign {sg,sf,se,sd,sc,sb,sa} = seg_print;
always@(posedge clk) begin  
  case(seg_ans)
	16'd0:seg_print <= 7'b100_0000;
	16'd1:seg_print <= 7'b111_1001;
	16'd2:seg_print <= 7'b010_0100;
	16'd3:seg_print <= 7'b011_0000;
	16'd4:seg_print <= 7'b001_1001;
	16'd5:seg_print <= 7'b001_0010;
	16'd6:seg_print <= 7'b000_0010;
	16'd7:seg_print <= 7'b101_1000;
	16'd8:seg_print <= 7'b000_0000;
	16'd9:seg_print <= 7'b001_0000;
	default: seg_ans <= seg_ans;
  endcase
end 
endmodule
