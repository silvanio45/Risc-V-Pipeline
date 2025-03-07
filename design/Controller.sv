`timescale 1ns / 1ps

module Controller (
    // Input
    input logic [6:0] Opcode,
    // 7-bit opcode field from the instruction

    // Outputs
    output logic ALUSrc,
    // 0: The second ALU operand comes from the second register file output (Read data 2); 
    // 1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    // 0: The value fed to the register Write data input comes from the ALU.
    // 1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, // The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  // Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, // Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  // 00: LW/SW; 01: Branch; 10: Rtype; 11: Addi
    output logic Branch,  // 0: branch is not taken; 1: branch is taken
    output logic Halt, 
    output logic Jump,
    output logic JumpReg
);

  logic [6:0] R_TYPE, LW, SW, BR, HALT, I_TYPE, JAL, JALR;

  assign R_TYPE = 7'b0110011;  // add, and, xor
  assign LW = 7'b0000011;  // lw, lb
  assign SW = 7'b0100011;  // sw
  assign BR = 7'b1100011;  // beq
  assign HALT = 7'b1111111;  
  assign I_TYPE = 7'b0010011;  // addi
  assign JAL = 7'b1101111; // jal 
  assign JALR = 7'b1100111;

  // Control signal assignments
  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == I_TYPE || Opcode == JALR);  // ADDI uses immediate operand
  assign MemtoReg = (Opcode == LW);  // MemtoReg is 1 only for LW
  assign RegWrite = (Opcode == R_TYPE || Opcode == LW || Opcode == I_TYPE || Opcode == JAL || Opcode == JALR);  // R_TYPE, LW, and ADDI write to register
  assign MemRead = (Opcode == LW);  // MemRead is 1 only for LW
  assign MemWrite = (Opcode == SW);  // MemWrite is 1 only for SW
  assign ALUOp[0] = (Opcode == BR || Opcode == JALR);  // ALUOp[0] is 1 for branches and addi
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == JALR);  // ALUOp[1] is 1 only for R_TYPE (arithmetic operations)
  assign Branch = (Opcode == BR);  // Branch is 1 for BR
  assign Halt = (Opcode == HALT);  // Halt is 1 for HALT instruction
  assign Jump = (Opcode == JAL || Opcode == JALR); // jal
  /*always @(*) begin
      $display("Time: %0t | Jump: %b", 
               $time, Branch);
  end*/

endmodule
