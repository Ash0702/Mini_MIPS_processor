// Code your testbench here
// or browse Examples
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
      $monitor($time , "inp1 = %d and PC = %d : FloatingALUOUT = %d , wire_going_into_register_rd = %d, inp2 = %d, fregister[3] = %d" , uut.floating_point_ALU.inp1 , uut.PC , uut.floating_point_ALU.FPUout, uut.wire_going_into_register_rd , uut.floating_point_ALU.inp2, uut.Fpr.Registers[3]);
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
        inst_data = 32'b000001_10000_00000_0000_0000_0000_1010;//addi$31,$0,10
        #20;
        address = 1;
        inst_data = 32'b000001_10000_00000_0000_0000_0000_1010; // addi $27, $0, 10

        address = 2;
        inst_data = 32'b000001_00110_10000_0000_0000_0000_1011; // addi $6 , $0 , 10
        #20
        address = 3;
        inst_data = 32'b010001_00110_11111_0000_0000_0000_0001; // bne$6,$31,1
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
      inst_data = 32'b000111_01010_00000_0000_0000_0000_1111;//lw$10,15($0);
      	#20
      	address = 11;
      inst_data = 32'b000001_11111_00000_0000_0000_0000_1011;//addi$31,$0,11;
        #20;//000000_00001_11111_00111_00000_000000
      	address = 12;
      inst_data = 32'b000000_00001_11111_00111_00000_001100;//mflo$1,$31,$7
      	#20
      	address = 13;
      inst_data = 32'b000000_00011_00001_00000_00000_000000;//add$3,$0,$1;
        #20
        address = 14;
      inst_data = 32'b000000_00001_00001_00001_00000_001100;//mflo$1,$1,$1
      #20
      	address = 15;
      inst_data = 32'b100001_00001_00111_00000_00000_000000;//mtc1 $1,$7;
      #20
      address = 16;
      inst_data = 32'b100001_00010_00111_00000_00000_000000;//mtc1 $2,$7;
      #20
      address = 17;
     inst_data = 32'b100010_00011_00010_00001_00000_000000;//add.s $f3,$f2,$f1
      #20
     address = 18;
     inst_data = 32'b100000_00110_00011_00000_00000_000000;//mfc1 $6, $3
      	#52
      	rst = 0;
        write_instruction = 0;
        #200
        // Check output
        $display("Register $32 value = %d", uut.RAM.Registers[31]);
        $display("Register $7 value = %d", uut.RAM.Registers[7]); 
      $display("Register $27 value = %d", uut.RAM.Registers[27]); 
        $display("Register $6 value = %d", uut.RAM.Registers[6]);
        $display("Register $8 value = %d", uut.RAM.Registers[8]);
      $display("Register $10 value = %d", uut.RAM.Registers[10]);
      $display("Register $3 value = %d", uut.RAM.Registers[3]);
      $display("Register $1 value = %d", uut.RAM.Registers[1]);
      $display("Memeroy[0] = %d" , uut.data_mem.Address_locations[0]);
      $display("Memeroy[15] = %d" , uut.data_mem.Address_locations[15]);
      $display("fpr[3] = %b", uut.Fpr.Registers[3]);
      $display("fpr[2] = %b", uut.Fpr.Registers[2]);
      $display("fpr[1] = %b", uut.Fpr.Registers[1]);
      
        $finish;
    end
endmodule