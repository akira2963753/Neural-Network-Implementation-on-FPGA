// Pooling.sv
module Pooling #(
    parameter DATA_WIDTH = 8,
    parameter MAP_WIDTH = 8
)(
    input clk,
    input rst_n,
    // input [DATA_WIDTH-1:0] fm_width,
    input [DATA_WIDTH-1:0] input_data,
    output reg [DATA_WIDTH-1:0] output_data,
    output done
);
    parameter ADDR_WIDTH = $clog2(MAP_WIDTH*MAP_WIDTH/2);
    parameter POOL_ADDR_WIDTH = $clog2(MAP_WIDTH*MAP_WIDTH/4);

    reg switch;
    reg [DATA_WIDTH-1:0] input_data_a [0:MAP_WIDTH*MAP_WIDTH/2-1];
    reg [DATA_WIDTH-1:0] input_data_b [0:MAP_WIDTH*MAP_WIDTH/2-1];
    reg [ADDR_WIDTH-1:0] addr_a;
    reg [ADDR_WIDTH-1:0] addr_b;

    reg pool_start;
    reg [POOL_ADDR_WIDTH-1:0] pool_addr;
    reg [DATA_WIDTH-1:0] A_in1;
    reg [DATA_WIDTH-1:0] A_in2;
    reg [DATA_WIDTH-1:0] B_in1;
    reg [DATA_WIDTH-1:0] B_in2;
    reg [DATA_WIDTH-1:0] max1;
    reg [DATA_WIDTH-1:0] max2;


    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for (i = 0; i < MAP_WIDTH*MAP_WIDTH/2; i = i + 1) begin
                input_data_a[i] <= 0;
                input_data_b[i] <= 0;
            end
        end
        else begin
            if(pool_start == 1'b0) begin
                if (switch == 1'b0) begin
                    input_data_a[addr_a] <= input_data;
                end
                else if(switch == 1'b1) begin
                    input_data_b[addr_b] <= input_data;
                end
            end
        end
    end

    reg [$clog2(MAP_WIDTH)-1:0] switch_cnt;
    // switch
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            switch <= 1'b0;
            switch_cnt <= {$clog2(MAP_WIDTH){1'b0}};
        end
        else begin
            if(switch_cnt == MAP_WIDTH-1 ) begin
                switch <= ~switch;
                switch_cnt <= {$clog2(MAP_WIDTH){1'b0}};
            end
            else begin
                switch_cnt <= switch_cnt + 1;
            end
        end
    end

    // addr_a , addr_b
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pool_start <= 1'b0;
            addr_a <= {ADDR_WIDTH{1'b0}};
            addr_b <= {ADDR_WIDTH{1'b0}};
        end
        else if(pool_start == 1'b0)begin
            if (switch == 1'b0) begin
                addr_a <= addr_a + 1;
            end
            else if(switch == 1'b1) begin
                if(addr_b == MAP_WIDTH*MAP_WIDTH/2-1) begin
                    pool_start <= 1'b1;
                end
                else begin
                    addr_b <= addr_b + 1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pool_addr <= {POOL_ADDR_WIDTH{1'b0}};
            A_in1 <= 0;
            A_in2 <= 0;
            B_in1 <= 0;
            B_in2 <= 0;
        end
        else begin
            if(pool_start) begin
                if(pool_addr == MAP_WIDTH*MAP_WIDTH/4-1) begin
                    pool_addr <= {POOL_ADDR_WIDTH{1'b0}};
                end
                else begin
                    pool_addr <= pool_addr + 1;
                end
                
                A_in1 <= input_data_a[pool_addr*2];
                A_in2 <= input_data_a[pool_addr*2+1];
                B_in1 <= input_data_b[pool_addr*2];
                B_in2 <= input_data_b[pool_addr*2+1];

                if(A_in1 > A_in2) max1 <= A_in1;
                else max1 <= A_in2;

                if(B_in1 > B_in2) max2 <= B_in1;
                else max2 <= B_in2;

                if(max1 > max2) output_data <= max1;
                else output_data <= max2;
            end
        end
    end

    reg pool_done;
    reg [1:0]wait_count;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pool_done <= 1'b0;
        end
        else begin
            if(pool_addr == MAP_WIDTH*MAP_WIDTH/4-1) begin
                pool_done <= 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wait_count <= 2'b0;
        end
        else begin
            if(pool_done) wait_count <= wait_count + 1;
            else wait_count <= 2'b0;
        end
    end

    assign done = (wait_count == 2'b10);

endmodule