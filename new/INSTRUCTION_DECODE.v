
module INSTRUCTION_DECODE(
	clk,
	rst,
	PC,
	IR,
	MW_MemtoReg,
	MW_RegWrite,
	MW_RD,
	MDR,
	MW_ALUout,
    SW,

	MemtoReg,
	RegWrite,
	MemRead,
	MemWrite,
	branch,
	jump,
	ALUctr,
	JT,
	DX_PC,
	NPC,
	A,
	B,
	imm,
	RD,
	MD
);

input clk, rst, MW_MemtoReg, MW_RegWrite;
input [31:0] IR, PC, MDR, MW_ALUout;
input [4:0]  MW_RD;
input [12:0]SW;

output reg MemtoReg, RegWrite, MemRead, MemWrite, branch, jump;
output reg [2:0] ALUctr;
output reg [31:0]JT, DX_PC, NPC, A, B;
output reg [15:0]imm;
output reg [4:0] RD;
output reg [31:0] MD;

//register file
reg [31:0] REG [0:31];
reg [31:0] i;

always @(posedge clk or posedge rst)
    if(rst) begin
	REG[0] = 32'd0;
    REG[1] = 32'd1;
    //cpu.ID.REG[2] = 32'd4;

    for (i=2; i<32; i=i+1) REG[i] = 32'b0;
    
	
    end
	else if(MW_RegWrite)
		REG[MW_RD] <= (MW_MemtoReg)? MDR : MW_ALUout;

always @(posedge clk or posedge rst)
begin
	if(rst) begin //��l��
		A 	<=32'b0;		
		MD 	<=32'b0;
		imm <=16'b0;
	    DX_PC<=32'b0;
		NPC	<=32'b0;
		jump 	<=1'b0;
		JT 	<=32'b0;
	end else begin
		A 	<=REG[IR[25:21]]; //s
		MD 	<=REG[IR[20:16]];
		imm <=IR[15:0];
	    DX_PC<=PC;
		NPC	<=PC;
		jump<=(IR[31:26]==6'd2)?1'b1:1'b0;
		JT	<={PC[31:28], IR[26:0], 2'b0};
		
	end
end


		
always @(posedge clk or posedge rst)
begin
   if(rst) begin
   	B 		<= 32'b0;
		MemtoReg<= 1'b0;
		RegWrite<= 1'b0;
		MemRead <= 1'b0;
		MemWrite<= 1'b0;
		branch  <= 1'b0;
		ALUctr	<= 3'b0;
		RD 	<=5'b0;
		
   end else begin
   		case( IR[31:26] )
		6'd0:
                       begin  // R-type
                           B         <= REG[IR[20:16]];
                           RD     <=IR[15:11];
                           MemtoReg<= 1'b0;
                           RegWrite<= 1'b1;
                           MemRead <= 1'b0;
                           MemWrite<= 1'b0;
                           branch  <= 1'b0;
                           case(IR[5:0])
                               //funct
                               6'd32://add
                                   ALUctr <= 3'd0;
                               //sub
                               6'd34:
                                   ALUctr <= 3'd1;
                               //and
                               6'd36:
                                   ALUctr <= 3'd2;
                               //or
                               6'd37:
                                   ALUctr <= 3'd3;
                               //slt
                               6'd42:
                                   ALUctr <= 3'd4;
                                   
                           endcase
                       end
                   6'd35:  begin// lw   //�g���e���ݸӫ��O�榡�ΰT���u���Ǹӥ��}���Ǹ������Ainput A�b�W�z�w�g�]�w�n�F�A���ٻݭn�]�w����? for example:
                           B         <= { { 16{IR[15]} } , IR[15:0] };
                           RD     <=IR[20:16];
                           MemtoReg<= 1'b1;
                           RegWrite<= 1'b1;
                           MemRead <= 1'b1;
                           MemWrite<= 1'b0;
                           branch  <= 1'b0;
                           ALUctr  <= 3'd0;
                           /*checked*/
                        end
                   6'd43:  begin// sw  //��갵�k���ܹp�P�A�T�{�n���O�榡�ΰT���u�Y�i
                           B         <= { { 16{IR[15]} } , IR[15:0] };
                           RD     <=IR[20:16];
                           MemtoReg<= 1'b1;
                           RegWrite<= 1'b0;
                           MemRead <= 1'b0;
                           MemWrite<= 1'b1;
                           branch  <= 1'b0;
                           ALUctr  <= 3'd0;
                           /*checked*/
                        end
                   6'd4:   begin // beq
                           B         <= REG[IR[20:16]];
                           RD     <=IR[20:16];
                           MemtoReg<= 1'b0;
                           RegWrite<= 1'b0;
                           MemRead <= 1'b0;
                           MemWrite<= 1'b0;
                           branch  <= 1'b1;
                           ALUctr <= 3'd5;
                           /*������*/
                       end
                   6'd5:   begin // bne
                           B         <= REG[IR[20:16]];
                           RD     <=IR[20:16];
                           MemtoReg<= 1'b1;
                           RegWrite<= 1'b0;
                           MemRead <= 1'b0;
                           MemWrite<= 1'b0;
                           branch  <= 1'b1;
                           ALUctr <= 3'd6;
                           /*������*/
                       end
                   6'd2: begin  // j
                           branch  <= 1'b1;    
                           ALUctr <= 3'd7;
                           /*������*/
                       end
           
                       default: begin
                           //$display("ERROR instruction!!");
                       end
		endcase
   end
end

endmodule