module tb_PE_Array();

    parameter DATA_WIDTH = 8;
    parameter ARRAY_SIZE = 3;
    parameter DIAG_NUM = 2 * ARRAY_SIZE - 1;
    parameter DIAG_SIZE = $clog2(DIAG_NUM);
    parameter SUM_WIDTH = 32;
    parameter TEST_LIST = 38;
    parameter GROUP_SIZE = 5;
    parameter CNT_WIDTH = $clog2(TEST_LIST);

    reg clk, rst_n;
    reg [CNT_WIDTH-1:0] cnt;
    
    // Test data arrays
    reg [DATA_WIDTH-1:0] A[0:ARRAY_SIZE-1][0:TEST_LIST-1]; // IFM
    reg [DATA_WIDTH-1:0] B[0:ARRAY_SIZE-1][0:TEST_LIST-1]; // Weight
    
    // Interface signals for PE_Array
    reg [DATA_WIDTH-1:0] ifm_in [0:ARRAY_SIZE-1];
    reg [DATA_WIDTH-1:0] w_in [0:ARRAY_SIZE-1];
    reg done [0:DIAG_NUM-1];
    wire [DATA_WIDTH-1:0] ifm_pass [0:ARRAY_SIZE-1];
    wire [DATA_WIDTH-1:0] w_pass [0:ARRAY_SIZE-1];
    wire [SUM_WIDTH-1:0] psum_out [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    
    // Control signals
    reg pe_done;
    reg [DIAG_SIZE-1:0] done_cnt;

    generate
        for (genvar i = 0; i < ARRAY_SIZE; i++) begin : read_files
            initial begin
                $readmemh($sformatf("C:/Verilog/Lab02/lab02_testbench/matA_%0d.txt", i), A[i]);
                $readmemh($sformatf("C:/Verilog/Lab02/lab02_testbench/matB_%0d.txt", i), B[i]);
            end
        end
    endgenerate
    
    // Instantiate PE_Array
    PE_Array #(
        .DATA_WIDTH(DATA_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE),
        .DIAG_NUM(DIAG_NUM),
        .SUM_WIDTH(SUM_WIDTH)
    ) dut (
        .ifm_in(ifm_in),
        .w_in(w_in),
        .clk(clk),
        .rst_n(rst_n),
        .done(done),
        .ifm_pass(ifm_pass),
        .w_pass(w_pass),
        .psum_out(psum_out)
    );
    
    // Initialize signals
    initial begin
        clk <= 1;
        rst_n <= 1;
        cnt <= 0;
        pe_done <= 0;
        done_cnt <= 3'b000;
        
        // Initialize input arrays
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            ifm_in[i] <= 0;
            w_in[i] <= 0;
        end
        // Reset PE_Array
        #2 rst_n <= 0;  
        #2 rst_n <= 1; 
    end
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Input data feeding
    always @(posedge clk) begin
        if (rst_n) begin
            for(int i = 0; i < ARRAY_SIZE; i++) begin
                ifm_in[i] <= A[i][cnt];
                w_in[i] <= B[i][cnt];
            end

            if(cnt==TEST_LIST-1) begin
                if(done[DIAG_NUM-1]) #5 $finish;
            end
            else cnt <= cnt + 1;
        
            if ((cnt % GROUP_SIZE) < GROUP_SIZE - 1) begin
                if ((cnt % GROUP_SIZE) == GROUP_SIZE - 2) begin
                    pe_done <= 1'b1;
                end
            end
            else begin
                pe_done <= 1'b0;
            end
        end
    end
    
    // Done signal control
    always @(posedge clk) begin
        if (rst_n) begin
            if (pe_done) done_cnt <= 1;
            else begin
                if (done_cnt > 0) begin
                    if (done_cnt < DIAG_NUM) done_cnt <= done_cnt + 1;
                    else done_cnt <= 0;
                end
            end
        end
        else done_cnt <= 0;
    end
    
    // Done signal assignment
    always @(posedge clk) begin
        if (rst_n) begin
            for (int i = 0; i < DIAG_NUM; i++) begin
                if (done_cnt == i + 1) done[i] <= 1'b1; 
                else done[i] <= 1'b0;
            end
        end 
        else for (int i = 0; i <= ARRAY_SIZE + 1; i++) done[i] <= 1'b0;
    end
    
    // Result collection (optional - for monitoring)
    reg [SUM_WIDTH-1:0] result_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    
    always @(negedge clk) begin
        if (rst_n) begin
            // Collect results when computation is done
            for (int diag = 0; diag < DIAG_NUM; diag++) begin
                if (done[diag]) begin
                    if (diag <= ARRAY_SIZE - 1) begin
                        for (int i = 0; i <= diag; i++) result_matrix[i][diag - i] <= psum_out[i][diag - i];
                    end 
                    else begin
                        for (int i = diag - (ARRAY_SIZE - 1); i < ARRAY_SIZE; i++) begin
                            if ((diag - i) < ARRAY_SIZE) begin  // 確保在範圍內
                                result_matrix[i][diag - i] <= psum_out[i][diag - i];
                            end
                        end
                    end
                end
            end            
        end
    end    
    
    // Optional: Display results
    always @(posedge clk) begin
        if (rst_n && done[DIAG_NUM-1]) begin
            $display("Matrix multiplication result:");
            for (int i = 0; i < ARRAY_SIZE; i++) begin
                for (int j = 0; j < ARRAY_SIZE; j++) begin
                    $write("%h ", result_matrix[i][j]);
                end
                $display("");
            end
        end
    end

endmodule