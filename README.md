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

## [Lab03](./Lab03)  
```
./Lab02/
├── lab03_testbench/    
├── Input_Register.sv  
├── Input_Register_Line.sv                          
└── tb_Input_Register_Line.sv  
```

