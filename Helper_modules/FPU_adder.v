`timescale 1ns/1ps


module floating_adder (
    input wire [31:0] inp1 , input [31:0] inp2 , output reg[31:0] out
);
    reg signa , signb;
    reg [7:0] exponenta, exponentb ;
    reg [7:0] diff;
    reg [22:0] ruffa , ruffb;
  reg[24:0] ans;
  reg[23:0] manta, mantb ;
    
    always @(inp1 or inp2) begin
        signa = inp1[31]; signb = inp2[31];
        exponenta = inp1[31:23]; exponentb = inp2[31:23];
        manta = {1'b1, inp1[22:0]}; mantb = {1'b1, inp2[22:0]};
        if(signa == signb) begin
            if(exponenta > exponentb) begin
                diff = exponenta - exponentb;
                ruffb = mantb >> diff;
                ans = ruffb + manta;
              if(ans[24] == 1) begin
                    ans = ans >> 1;
                    exponenta = exponenta + 1;
                end
                else begin
                    ans = ans;
                end
                out = {signa , exponenta , ans[22:0]};
            end
            else begin
                diff = exponentb - exponenta;
                ruffa = manta >> diff;
                ans = ruffa + mantb;
              if(ans[24] == 1) begin
                    ans = ans >> 1;
                    exponentb = exponentb + 1;
                end
                else begin
                    ans = ans;
                end
                out = {signb, exponentb , ans[22:0]};
            end
        end
        else begin
            if(inp1 > inp2) begin
                diff = exponenta - exponentb;
                ruffb = mantb >> diff;
                ans = manta - ruffb;
              while(ans[23] == 0) begin
                    ans = ans << 1;
                    exponenta = exponenta - 1;
                end
                out = {signa , exponenta , ans[22:0]};
            end
            else begin
                diff = exponentb - exponenta;
                ruffa = manta >> diff;
                ans = mantb - ruffa;
              while (ans[23] == 0) begin
                    ans = ans << 1;
                    exponentb = exponentb - 1;
                end
                out = {signb, exponentb , ans[22:0]};
            end
        end
    end
endmodule
