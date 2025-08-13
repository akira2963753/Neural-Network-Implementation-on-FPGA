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
**目的 : 實現一個Processing Element (PE)**  
  
電路模塊與模擬結果如下圖所示 :  
   
| <img width="500" height="300" alt="image" src="https://github.com/user-attachments/assets/5e62ab76-81d2-4af2-ba27-ad5c3426a452" /> | <img width="850" height="300" alt="image" src="https://github.com/user-attachments/assets/53c84f2c-fce0-4ab7-8ba9-ab60e7877d22" /> | 
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
**目的 : 根據 Output Satationary Data Flow 實現一個 N x N 的 Systolic Array，輸出每個矩陣計算的結果**  
  
Lab02的測資會幫我們做正45度角的Pipeline，這個測資是要處理[5x5的矩陣，一共有7個]，我們根據每個對角線計算完的時間，從每個PE中取出答案存到TestBench中的Result_Matrix，當最後一個對角線計算完後，輸出Result_Matrix的結果出來，如下圖所示。並且由於我們的程式是參數化設計，因此可以擴展到 N X N 的 Systolic Array (包含TB)，我們也用 4 x 4 Systolic Array [(SA_4x4)](./Lab02/SA_4x4) 做為測試。
  
|<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/8a61552b-3ed4-4f5b-b446-6df64ff81c02" />| <img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/0d876759-43a4-452e-a230-998179423ac7" /> |
|:--:|:--:|
<img width="1300" height="397" alt="image" src="https://github.com/user-attachments/assets/7bdb3451-054d-4ea2-b179-0373cf1fa46c" />




   

## [Lab03](./Lab03)  
```
./Lab02/
├── lab03_testbench/    
├── Input_Register.sv  
├── Input_Register_Line.sv                          
└── tb_Input_Register_Line.sv  
```
**目的 : 實現一個 Input Register 來幫助系統將輸入的資料分流到正確的位置**  

Lab03的測資一共會輸入1024個資料，然後通過Input Register將資料分流到正確的位置，並且會做正45度Pipeline。    
  
| <img width="1615" height="695" alt="image" src="https://github.com/user-attachments/assets/a2dc9a1e-f869-49bf-9b0c-096cf3489972" /> |<img width="1800" height="900" alt="image" src="https://github.com/user-attachments/assets/0069a1f6-8895-4efb-a442-d51d591f7f14" />|
|:--:|:--:|


