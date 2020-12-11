
module MEMORY(
	clk,
	rst,
	XM_MemtoReg,
	XM_RegWrite,
	XM_MemRead,
	XM_MemWrite,
	ALUout,
	XM_RD,
	XM_MD,
	SW,
	
	MW_MemtoReg,
	MW_RegWrite,
	MW_ALUout,
	MDR,
	MW_RD
);
input clk, rst, XM_MemtoReg, XM_RegWrite, XM_MemRead, XM_MemWrite;
//input sw0,sw1,sw2,sw3,sw4,sw5,sw6,sw7,sw8,sw9,sw10,sw11,sw12;
input [31:0] ALUout;
input [4:0] XM_RD;
input [31:0] XM_MD;
input [12:0]SW;

output reg MW_MemtoReg, MW_RegWrite;
output reg [31:0]	MW_ALUout, MDR;
output reg [4:0]	MW_RD;
integer i;
//data memory
reg [31:0] DM [0:127];
always @(posedge clk) begin
    if(rst) begin
	   DM[0] = {19'b0,SW};  	// INPUT 若input超過123 請調大INSTRUCTION_NUMBERS
	   DM[1] = {19'b0,SW}; 
      // DM[1] = 32'd3;
       for (i=2; i<128; i=i+1) DM[i] = 32'b0;
        
    end
	if(XM_MemWrite)
		DM[ALUout[6:0]] <= XM_MD;
end

always @(posedge clk or posedge rst)
	if (rst) begin
		MW_MemtoReg 		<= 1'b0;
		MW_RegWrite 		<= 1'b0;
		MDR					<= 32'b0;
		MW_ALUout			<= 32'b0;
		MW_RD				<= 5'b0;
	end
	else begin
		MW_MemtoReg 		<= XM_MemtoReg;
		MW_RegWrite 		<= XM_RegWrite;
		MDR					<= (XM_MemRead)?DM[ALUout[6:0]]:MDR;
		MW_ALUout			<= ALUout;
		MW_RD 				<= XM_RD;
	end

endmodule
