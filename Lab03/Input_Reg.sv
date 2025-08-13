module Input_Reg #(
    parameter ARRAY_SIZE = 4,
    parameter DATA_WIDTH = 8,
    parameter BUFFER_DATA_WIDTH = ARRAY_SIZE * DATA_WIDTH
)(
    input clk,
    input rst_n,
    input write_en,
    input read_en,
    input [BUFFER_DATA_WIDTH-1:0] buffer_data_in,
    output [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] Input_Reg [0:ARRAY_SIZE-1];
    reg [1:0] cnt;

    assign data_out = (read_en)? Input_Reg[cnt] : 0;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(int i = 0; i < ARRAY_SIZE; i++) Input_Reg[i] <= 0; 
            cnt <= 0;
        end
        else begin
            if(write_en) begin
                Input_Reg[0] <= buffer_data_in[7:0];
                Input_Reg[1] <= buffer_data_in[15:8];
                Input_Reg[2] <= buffer_data_in[23:16];
                Input_Reg[3] <= buffer_data_in[31:24];
            end
            cnt <= (read_en)? cnt + 1 : 0;
        end
    end
endmodule