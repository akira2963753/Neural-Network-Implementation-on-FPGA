(*use_dsp="yes"*)module RELU#(
    parameter SUM_WIDTH = 32
)(
    input [SUM_WIDTH-1:0] in_data,
    input clk,
    input rst_n,
    output reg [SUM_WIDTH-1:0] out_data
);
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out_data <= 0;
        end
        else begin
            out_data <= (in_data[SUM_WIDTH-1]) ? 0 : in_data;
        end
    end

endmodule
