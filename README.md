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
   
| <img width="400" height="200" alt="image" src="https://github.com/user-attachments/assets/5e62ab76-81d2-4af2-ba27-ad5c3426a452" /> | <img width="800" height="300" alt="image" src="https://github.com/user-attachments/assets/53c84f2c-fce0-4ab7-8ba9-ab60e7877d22" /> | 
|:--:|:--:|

  
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

