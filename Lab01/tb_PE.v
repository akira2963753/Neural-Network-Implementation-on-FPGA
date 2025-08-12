module tb_PE(
    );
    parameter WIDTH = 8;
    parameter TESTLIST = 18;
    
    reg     [WIDTH-1:0] in_ifm, in_w;
    
    wire    [WIDTH-1:0] pass_ifm, pass_w;
    wire    [31:0] pass_ofm;
    
    reg     clk, rst_n;
    reg     [WIDTH-1:0]A[TESTLIST-1:0];
    reg     [WIDTH-1:0]B[TESTLIST-1:0];
    reg     [4:0]cnt;
    reg     pe_done;

    initial begin
        $readmemh("D:/Project/NN/Lab01/lab1_testbench/test18_a.txt", A);
        $readmemh("D:/Project/NN/Lab01/lab1_testbench/test18_b.txt", B);
    end

    PE test_PE(
        .ifm_in(in_ifm),
        .ifm_pass(pass_ifm),
        .w_in(in_w),
        .w_pass(pass_w),
        .psum_out(pass_ofm),
        .clk(clk),
        .rst_n(rst_n),
        .done(pe_done)
    );

    initial begin
        cnt = 0;
        clk = 1;
        in_ifm = 0;
        in_w = 0;
        rst_n = 1;
        pe_done = 0;
        #2 rst_n = 0;
        #2 rst_n = 1;
    end

    always @(posedge clk) begin
        in_ifm <= A[cnt];
        in_w <= B[cnt];
        cnt <= cnt + 1;
        if (cnt < 19) begin
            pe_done <= 1'b0;
        end
        else begin
            pe_done <= 1'b1;
            cnt <= 0;
            $finish;
        end
    end

    always #5 clk = ~clk;

endmodule