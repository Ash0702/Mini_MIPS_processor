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

        $monitor($time, " PC=%d\n", uut.legs.PC);
        //$monitor($time , "Register $6 value = %d\n", uut.RAM.Registers[6]);
      $monitor($time , "ALU_out[0] = %d and PC = %d : memory_in = %d, memory_write = %d : mem_we = %b  Memoroy[0] = %d , rt_out = %d" , uut.ALU_out , uut.PC , uut.memory_in , uut.memory_write , uut.data_mem.we , uut.data_mem.Address_locations[0] , uut.rt_out);
      //assign memory_write = (write_data)? inst_data : rt_out;
      //$monitor($time , "PC = %d , memory_write = %d , write_data = %b , inst_data = %d , rt_out = %d , rt = %d" , uut.PC , uut.memory_write , uut.write_data , uut.inst_data , uut.rt_out, uut.rt);
        clk = 0;
        rst = 1;
        address = 0;
        write_instruction = 0;
        write_data = 0;
        inst_data = 32'b0;

        #10;
        // Write the addi instruction to instruction memory at address 0
        write_instruction = 1;
        address = 0;
        inst_data = 32'b000001_11111_00000_0000_0000_0000_1010;//addi$31,$0,10
        #20;
        address = 1;
        inst_data = 32'b000001_11011_00000_0000_0000_0000_1010; // addi $31, $0, 10

        address = 2;
        inst_data = 32'b000001_00110_00000_0000_0000_0000_1010; // addi $6 , $0 , 10
        #20
        address = 3;
        inst_data = 32'b010000_00110_11111_0000_0000_0000_0001; // bne$6,$31,1
        #20
        address = 4;
        inst_data = 32'b000001_01000_00000_0000_0000_0000_0001; //addi $8, $0, 1
        #20
        address = 5;
        inst_data = 32'b000001_00111_00000_0000_0000_0000_1000; //addi $7 , $0 , 8
        #20
        address = 6;
        inst_data = 32'b001000_00000_11111_0000_0000_0000_0000; //sw $31 , 0($0)
      	#20
      	address = 7;
      	inst_data = 32'b000001_01111_00000_0000_0000_0000_1111;//addi$15,$0,15
		#20
      	address = 8;
      inst_data = 32'b001000_11111_00111_0000_0000_0000_0101; //sw $7,5($31) basically M[15] = 10
      	#20
      	address = 9;
      inst_data = 32'b000111_00110_00000_0000_0000_0000_1111;//lw$6,15($0)
      	#20
      	address = 10;
      inst_data = 32'b000111_01010_00000_0000_0000_0000_0000;//lw$10,0($0);
        #50;
        rst = 0;
        write_instruction = 0;
        #100
        // Check output
        $display("Register $32 value = %d", uut.RAM.Registers[31]);
        $display("Register $7 value = %d", uut.RAM.Registers[7]); 
        $display("Register $6 value = %d", uut.RAM.Registers[6]);
        $display("Register $8 value = %d", uut.RAM.Registers[8]);
      $display("Register $10 value = %d", uut.RAM.Registers[10]);
        $display("Memeroy[0]" , uut.data_mem.Address_locations[0]);
      	$display("Memeroy[15]" , uut.data_mem.Address_locations[15]);
        $finish;
    end
endmodule