(*use_dsp="yes"*)module PE#(
    parameter DATA_WIDTH = 8,
    parameter SUM_WIDTH = 32
)(
    input [DATA_WIDTH-1:0] ifm_in,
    input [DATA_WIDTH-1:0] w_in,
    input clk,
    input rst_n,
    input done,
    output [DATA_WIDTH-1:0] ifm_pass,
    output [DATA_WIDTH-1:0] w_pass,
    output [SUM_WIDTH-1:0] psum_out
);
    // Register 
    reg [DATA_WIDTH-1:0] ifm_pass_r;
    reg [DATA_WIDTH-1:0] w_pass_r;
    wire [SUM_WIDTH-1:0] mul;
    reg [SUM_WIDTH-1:0] psum_out_r;

    // Register output 
    assign ifm_pass = ifm_pass_r;
    assign w_pass = w_pass_r;
    assign psum_out = psum_out_r;
    assign mul =  w_in * ifm_in;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ifm_pass_r <= 0;
            w_pass_r <= 0;
            psum_out_r <= 0;
        end
        else begin
            ifm_pass_r <= ifm_in;
            w_pass_r <= w_in;
            case(done)
                1'b0 : psum_out_r <= psum_out_r + mul;
                1'b1 : psum_out_r <= mul;
                default : psum_out_r <= 0;
            endcase
        end
    end
endmodule