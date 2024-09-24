`timescale 1ns/1ps
module test(
  input a,
  input b,
  input c,
  output result
);

assign result = (a==1&&b==1&&c==1)? 1:
                (a==1&&b==1)? 1:
                (a==1&&c==1)? 1:
                (b==1&&c==1)? 1:
                0;
endmodule