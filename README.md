# Neural Network Implementation on FPGA  

### Development Environment : 
- *Vivado, version 2025*   


### Lab : 
- [x] **Lab01 (PE)**
- [X] **Lab02 (Systolic_Array)**
- [X] **Lab03 (Input Register)**
- [ ] **Lab04 (Max Pooling)**
- [ ] **Lab05 (ReLU Function)**
- [ ] **Lab06 (Moudle Integration)**
- [ ] **Lab07 (Data-Path Design)**

# 

## [Lab01](./Lab01) 
```
./Lab01/
├── lab01_testbench/  
│   └── test18_a.txt  
│   └── test18_b.txt  
├── PE.sv                        
└── tb_PE.sv    
```
實現一個Processing Element (PE)，如下圖所示 :  
   
<img width="600" height="300" alt="image" src="https://github.com/user-attachments/assets/5e62ab76-81d2-4af2-ba27-ad5c3426a452" />

``` Verilog
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
                1'b1 : psum_out_r <= psum_out_r;
                default : psum_out_r <= 0;
            endcase
        end
    end
endmodule
```


## [Lab02](./Lab02)  
```
./Lab02/
├── lab02_testbench/    
├── PE.sv  
├── PE_Array.sv                          
├── tb_PE.sv
├── SA_4x4/                    # Test 4x4 Result  
│   └── lab02_testbench_4x4/
│   └── PE.sv 
│   └── PE_Array.sv 
│   └── tb_PE.sv 
```
根據 Output Satationary Data Flow 實現一個 N x N 的 Systolic Array，我們也測試了陣列參數調整成4的結果。  
   
``` SystemVerilog
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
```

## [Lab03](./Lab03)  
```
./Lab02/
├── lab03_testbench/    
├── Input_Register.sv  
├── Input_Register_Line.sv                          
└── tb_Input_Register_Line.sv  
```

