module dotProduct(
    input [31:0] vector_a,
    input [31:0] vector_b,
    output [5:0] result
);
    integer i;
    reg [5:0] temp;

    always @(*) begin
        temp = 6'b0; // 操你妈的初始化
        // Verilog中不允许使用自增自减运算符 ++ / --， 也不能使用 += / -=
        for (i = 0; i < 32; i = i + 1) begin 
            temp = temp + (vector_a[i] * vector_b[i]); // 内积计算
        end
    end

    assign result = temp;
endmodule //dotProduct
