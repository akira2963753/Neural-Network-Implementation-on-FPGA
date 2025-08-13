module PE_Array #(
    parameter DATA_WIDTH = 8,
    parameter ARRAY_SIZE = 3,
    parameter SUM_WIDTH = 32
)(
    input [DATA_WIDTH-1:0] ifm_in [0:ARRAY_SIZE-1],
    input [DATA_WIDTH-1:0] w_in [0:ARRAY_SIZE-1],
    input clk,
    input rst_n,
    input done [0:ARRAY_SIZE+1],
    output [DATA_WIDTH-1:0] ifm_pass [0:ARRAY_SIZE-1],
    output [DATA_WIDTH-1:0] w_pass [0:ARRAY_SIZE-1],
    output [SUM_WIDTH-1:0] psum_out [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1]
);
    wire [DATA_WIDTH-1:0] ifm_wire [0:ARRAY_SIZE-1][0:ARRAY_SIZE];
    wire [DATA_WIDTH-1:0] w_wire [0:ARRAY_SIZE][0:ARRAY_SIZE-1];
    
    // Connect input from the last row/column
    generate
        for(genvar i=0; i<ARRAY_SIZE; i=i+1) begin : input_connections
            assign ifm_wire[i][0] = ifm_in[i];
            assign w_wire[0][i] = w_in[i];
        end
    endgenerate

    // Connect output from the last row/column
    generate
        for(genvar i=0; i<ARRAY_SIZE; i=i+1) begin : output_connections
            assign ifm_pass[i] = ifm_wire[i][ARRAY_SIZE];
            assign w_pass[i] = w_wire[ARRAY_SIZE][i];
        end
    endgenerate

    // 3 x 3 Systolic Array
    generate
        for(genvar i=0;i<ARRAY_SIZE;i=i+1) begin : row_gen
            for(genvar j=0;j<ARRAY_SIZE;j=j+1) begin : col_gen
                PE #(
                .DATA_WIDTH(DATA_WIDTH),
                .SUM_WIDTH(SUM_WIDTH)
                )Processing_Element(
                .ifm_in(ifm_wire[i][j]),
                .w_in(w_wire[i][j]),
                .clk(clk),
                .rst_n(rst_n),
                .done(done[i+j]),
                .ifm_pass(ifm_wire[i][j+1]),
                .w_pass(w_wire[i+1][j]),
                .psum_out(psum_out[i][j])
                );
            end
        end
    endgenerate
    
endmodule