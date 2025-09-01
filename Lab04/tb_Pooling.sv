module tb_Inpue_Reg_Line();

    parameter DATA_WIDTH = 8;
    parameter MAP_WIDTH = 10;

    reg clk;
    reg rst_n;
    reg start;
    reg [DATA_WIDTH-1:0] input_data;
    wire [DATA_WIDTH-1:0] output_data;
    wire done;

    Pooling #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAP_WIDTH(MAP_WIDTH)
    ) UUT(
        .clk(clk),
        .rst_n(rst_n),
        .input_data(input_data),
        .output_data(output_data),
        .done(done)
    );

    reg [DATA_WIDTH-1:0] test_data [0:99];

    initial begin
        $readmemh("C:/Project_vivado/Neural_Network_Implementation_on_FPGA_lab04/lab04_testbench/pooling_input.txt",test_data);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 1;
        rst_n = 1;
        start = 0;
        #2 rst_n = 0;
        #2 begin
            rst_n = 1;
            start = 1;
        end
    end
    
    reg [10:0] data_count;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            data_count <= 11'd1;
            input_data <= test_data[0];
        end
        else begin
            input_data <= test_data[data_count];
            data_count <= data_count + 1;
        end
    end

    always @(*) begin
        if(done) #5 $finish;
    end


endmodule