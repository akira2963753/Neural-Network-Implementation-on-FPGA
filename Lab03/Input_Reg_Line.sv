module Input_Reg_Line #(
    parameter ARRAY_SIZE = 4,
    parameter DATA_WIDTH = 8,
    parameter BUFFER_DATA_WIDTH = ARRAY_SIZE * DATA_WIDTH
)(
    input clk,
    input rst_n,
    input reg_line_en,
    input data_done,
    input [BUFFER_DATA_WIDTH-1:0] buffer_data_in,
    output [DATA_WIDTH-1:0] data_out [0:ARRAY_SIZE-1]
);
    wire [ARRAY_SIZE-1:0] read_en,write_en;
    reg pipeline_done;
    reg start;
    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pipeline_done <= 0;
            start <= 0;
            cnt <= 0;
        end
        else begin
            if(cnt==3) pipeline_done <= 1;
            start <= 1;
            cnt <= (start)? cnt + 1 : 0;
        end
    end

    generate
        for(genvar i = 0; i < ARRAY_SIZE; i++) begin : en_control
            assign write_en[i] = (cnt[1:0] == i); // 4個一組
            assign read_en[i] = ((cnt>i)||pipeline_done);
        end
    endgenerate
    
    generate 
        for(genvar i = 0; i < ARRAY_SIZE; i++) begin : input_reg_connection
            Input_Reg #(
                .ARRAY_SIZE(ARRAY_SIZE),
                .DATA_WIDTH(DATA_WIDTH),
                .BUFFER_DATA_WIDTH(BUFFER_DATA_WIDTH)
            )IFM_Input_Reg(
                .clk(clk),
                .rst_n(rst_n),
                .write_en(write_en[i]),
                .read_en(read_en[i]),
                .buffer_data_in(buffer_data_in),
                .data_out(data_out[i]));
        end
    endgenerate
endmodule