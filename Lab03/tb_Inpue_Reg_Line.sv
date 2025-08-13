module tb_Inpue_Reg_Line();

    parameter ARRAY_SIZE = 4;
    parameter DATA_WIDTH = 8;
    parameter BUFFER_DATA_WIDTH = ARRAY_SIZE * DATA_WIDTH;

    reg clk;
    reg rst_n;
    reg start;
    reg line_en;
    reg data_done;
    reg [BUFFER_DATA_WIDTH-1:0] buffer_data_in;
    wire [DATA_WIDTH-1:0] data_out [0:ARRAY_SIZE-1];

    Input_Reg_Line #(
        .ARRAY_SIZE(ARRAY_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .BUFFER_DATA_WIDTH(BUFFER_DATA_WIDTH)
    )test(
        .clk(clk),
        .rst_n(rst_n),
        .reg_line_en(line_en),
        .data_done(data_done),
        .buffer_data_in(buffer_data_in),
        .data_out(data_out));

    reg [BUFFER_DATA_WIDTH-1:0] test_data [0:1023];

    initial begin
        $readmemh("C:/Verilog/Lab03/lab03_testbench/32by1024.txt",test_data);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 1;
        rst_n = 1;
        start = 0;
        line_en = 0;
        data_done = 0;
        #2 rst_n = 0;
        #2 begin
            rst_n = 1;
            start = 1;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) line_en <= 0;
        else if(start) line_en <= 1;
    end

    reg [10:0] data_count;
    reg [9:0] read_addr;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            buffer_data_in <= {BUFFER_DATA_WIDTH{1'b0}};
            data_count <= {10{1'b0}};
            read_addr <= {9{1'b0}};
        end
        else begin
            if(start) begin
                buffer_data_in <= test_data[read_addr];
                data_count <= data_count + 1;
                read_addr <= read_addr + 1;
            end
        end
    end

    always @(posedge clk) begin
        if(start) begin
            if(data_count == 1024) begin
                data_done <= 1;
                #5 $finish;
            end
        end
    end

endmodule