module tb_PE_Array();

    parameter DATA_WIDTH = 8;
    parameter ARRAY_SIZE = 4;
    parameter DIAG_NUM = 2 * ARRAY_SIZE - 1;
    parameter SUM_WIDTH = 32;
    parameter GROUP_SIZE = 4;
    parameter TEST_LIST = GROUP_SIZE + (ARRAY_SIZE - 1);
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

    // Read Input files
    generate
        for (genvar i = 0; i < ARRAY_SIZE; i++) begin : read_files
            initial begin
                $readmemh($sformatf("C:/Verilog/Lab02/Matrix/lab02_testbench/matA_%0d.txt", i), A[i]);
                $readmemh($sformatf("C:/Verilog/Lab02/Matrix/lab02_testbench/matB_%0d.txt", i), B[i]);
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
        .psum_out(psum_out));
    
    // Initialize signals
    initial begin
        clk <= 1;
        rst_n <= 1;
        cnt <= 0;
        pe_done <= 0;
        
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
        
            if ((cnt % GROUP_SIZE) == GROUP_SIZE - 1) begin
                pe_done <= 1'b1;
            end
            else begin
                pe_done <= 1'b0;
            end
        end
    end
    
    // Done signal assignment
    always @(posedge clk) begin
        if (rst_n) begin
            done[0] <= pe_done;
            for (int i = 1; i < DIAG_NUM; i++) done[i] <= done[i-1];
        end 
        else for (int i = 0; i <= ARRAY_SIZE + 1; i++) done[i] <= 0;
    end
    
    
    // Result collection (optional - for monitoring)
    reg [SUM_WIDTH-1:0] result_matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    
    always @(negedge clk) begin
        if (rst_n) begin
            // Collect results when computation is done
            for (int diag = 0; diag < DIAG_NUM; diag++) begin
                if (done[diag]) begin
                    for(int i = 0; i < ARRAY_SIZE; i++) begin
                        for(int j = 0; j < ARRAY_SIZE; j++) begin
                            if(i+j==diag) result_matrix[i][j] <= psum_out[i][j];
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