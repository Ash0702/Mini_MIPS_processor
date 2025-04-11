// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module CPU_tb;
    reg clk, rst;
    reg [31:0] inst_data;
    reg [9:0] address;
    reg write_instruction, write_data;
    wire [31:0] OutputOfRs;
    // Instantiate the CPU
    CPU uut (
        .rst(rst),
        .clk(clk),
        .inst_data(inst_data),
        .address(address),
        .write_instruction(write_instruction),
        .write_data(write_data),
        .OutputOfRs(OutputOfRs)
    );
    // Clock Generation
    always #5 clk = ~clk;
    initial begin
        // Initialize

       
        clk = 0;
        rst = 1;
        address = 0;
        write_instruction = 0;
        write_data = 0;
        inst_data = 32'b0;
		
      $monitor($time , " : clk : %b : PC = %d , uut.data_mem.d = %d , uut.data_mem.a = %d , uut.data_mem.we = %b , Memory[10] = %d" ,clk, uut.PC, uut.data_mem.d , uut.data_mem.a , uut.data_mem.we , uut.data_mem.Address_locations[10]);
      
      
        #10;
        // Write the addi instruction to instruction memory at address 0
        write_instruction = 1;
        address = 0;
      	inst_data = 32'b000001_11111_00000_0000_0000_0000_0001;
      	#20
      	address = 1;
      	inst_data = 32'b000001_11111_00000_0000_0000_0000_1010;//addi$31,$0,10
      	#20
      	address = 2;
      	inst_data = 32'b000001_11011_00000_0000_0000_0000_1010;//addi$27,$0,10		
      	#20
      	address = 3;
      	inst_data = 32'b000000_00001_11111_11011_00000_000000;//add$1,$27,$31
      #20
      address = 4;
      inst_data = 32'b010000_11111_11011_0000_0000_0000_0001;//beq$31,$27,1
      #20
      address = 5;
      inst_data = 32'b000001_00001_00000_0000_0000_0000_1111;//addi$1,$0,15
      #20
      address = 6;
      inst_data = 32'b001000_11111_11011_0000_0000_0000_0000;//sw$27,0($31)
      #20
      address = 7;
      inst_data = 32'b000111_00001_00000_0000_0000_0000_1010;//lw$1,10($0)
      #20
      address = 8;
      inst_data = 32'b000111_00010_00000_0000_0000_0000_0110;//lw$2,6($0)
      #20
      address = 9;
      inst_data = 32'b000000_00011_00001_00010_00000_001100;//mflo$3,$1,$2;
      #20
      write_instruction = 0;
      write_data = 1;
      #20
      address = 6;
      inst_data = 32'd7;
      #54
      	rst = 0;
        write_instruction = 0;
      	write_data = 0;
        #200
        // Check output
      $display("Reg[1] = %d" , uut.RAM.Registers[1]);
      $display("Reg[2] = %d" , uut.RAM.Registers[2]);
      $display("Reg[3] = %d" , uut.RAM.Registers[3]);
      $display("Memory[10] = %d", uut.data_mem.Address_locations[10]);
        $finish;
    end
endmodule