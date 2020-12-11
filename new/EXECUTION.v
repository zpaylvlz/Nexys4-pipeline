
module EXECUTION(
	clk,
	rst,
	DX_MemtoReg,
	DX_RegWrite,
	DX_MemRead,
	DX_MemWrite,
	DX_branch,
	ALUctr,
	NPC,
	A,
	B,
	imm,
	DX_RD,
	DX_MD,
	
	JT,
	DX_PC,
	DX_jump,

	XM_MemtoReg,
	XM_RegWrite,
	XM_MemRead,
	XM_MemWrite,
	XM_branch,
	ALUout,
	XM_RD,
	XM_MD,
	XM_BT
);

input clk, rst, DX_MemtoReg, DX_RegWrite, DX_MemRead, DX_MemWrite, DX_branch, DX_jump;
input [2:0] ALUctr;
input [31:0]JT, DX_PC, NPC, A, B;
input [15:0]imm;
input [4:0] DX_RD;
input [31:0] DX_MD;

output reg XM_MemtoReg, XM_RegWrite, XM_MemRead, XM_MemWrite, XM_branch;
output reg [31:0]ALUout, XM_BT;
output reg [4:0] XM_RD;
output reg [31:0] XM_MD;

//set pipeline register
always @(posedge clk or posedge rst)
begin
	if(rst) begin //??��?��??
		XM_MemtoReg	<= 1'b0;
		XM_RegWrite	<= 1'b0;
		XM_MemRead 	<= 1'b0;
		XM_MemWrite	<= 1'b0;
		XM_RD 	   	<= 5'b0;
		XM_MD 	   	<= 32'b0;
		XM_branch	<= 1'b0;
		XM_BT		<=32'b0;
	end else begin
		XM_MemtoReg	<= DX_MemtoReg;
		XM_RegWrite	<= DX_RegWrite;
		XM_MemRead 	<= DX_MemRead;
		XM_MemWrite	<= DX_MemWrite;
		XM_RD 	   	<= DX_RD;
		XM_MD 	   	<= DX_MD;
	    XM_branch<=((ALUctr==32'd5) && (A == B) && (DX_branch))? 1'b1: ((ALUctr==32'd6) && (A != B) && (DX_branch))?1'b1:1'b0;
		XM_BT<=NPC+{ { 15{imm[15]}}, imm, 2'b0};  //Branch Target = ?��??��?�PC?? + ?��對�?��? (EX. beq??�令)
		//beq??�令?��"execution"中�???要�?�設定其實大多都完�?��?��?��?��?�可以�?�閱上方?��行�?�令?��?��?�方ALUout??�是記�?��?�給?��?��?��?��?��??0
	end
end

always @(posedge clk or posedge rst)
begin
   if(rst) begin
   		ALUout <= 32'b0;
   end else begin
   		case(ALUctr)		
			
		  	3'd0: //add / lw ...  //�bID���q�ɤw�g�ѽX�X���O�F�A���ӫ��O�ݭn���@�عB��?
                            ALUout <= A + B;
                       3'd1:
                           ALUout <= A - B;
                       3'd2:
                           ALUout <= A & B;
                       3'd3:
                           ALUout <= A | B;
                       3'd4:
                           ALUout <= A < B;
                       3'd5:
                           ALUout <= 0;
                       3'd6:
                           ALUout <= 0;
                       3'd7:
                           ALUout <= 0;
		endcase
   end
end


endmodule
	
