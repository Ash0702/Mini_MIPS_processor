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
        $monitor($time , "ALU_out[0] = %d and branch = %b" , uut.ALU_out , uut.branch);
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
        inst_data = 32'b000001_11111_00000_0000_0000_0000_1010; // addi $31, $0, 10
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

        #50;
        rst = 0;
        write_instruction = 0;
        #100
        // Check output
        $display("Register $32 value = %d", uut.RAM.Registers[31]);
        $display("Register $7 value = %d", uut.RAM.Registers[7]); // Should be 30
        $display("Register $6 value = %d", uut.RAM.Registers[6]);
        $display("Register $8 value = %d", uut.RAM.Registers[8]);
        $display("Memeroy[0]" , uut.data_mem.Address_locations[0]);
        $finish;
    end
endmodule