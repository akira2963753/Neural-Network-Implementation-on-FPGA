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
| Type | Signal Name | WIDTH(bit) | Description |
|:-----:|:-----:|:----:|:----:|
|Parameter| DATA_WIDTH | 8 | Weight與IFM輸入的大小 |
|Parameter| SUM_WIDTH | 32 | Partial Sum 的大小 |
|Input| clk | 1 | Postive-edge 觸發的clock|
|Input| rst_n | 1 | Negative-edge 觸發的rst|
|Input| ifm_in | DATA_WIDTH | Input Feature Map 輸入資料|
|Input| w_in | DATA_WIDTH | Weight 權重輸入資料|
|Input| done | 1 | 控制信號，決定是否繼續累加|
|Output| ifm_pass | DATA_WIDTH | Input Feature Map 傳遞輸出|
|Output| w_pass | 8 | Weight 權重傳遞輸出|
|Output| psum_out | SUM_WIDTH | Partial Sum 累加結果輸出|


電路模塊與模擬結果如下圖所示 :  
   
| <img width="500" height="300" alt="image" src="https://github.com/user-attachments/assets/5e62ab76-81d2-4af2-ba27-ad5c3426a452" /> | <img width="850" height="300" alt="image" src="https://github.com/user-attachments/assets/53c84f2c-fce0-4ab7-8ba9-ab60e7877d22" /> | 
|:--:|:--:|

  
## [Lab02](./Lab02)  
```
./Lab02/
├── Conv/
│   └── lab02_testbench/    # Test Pattern for Conv  
│   └── PE.sv  
│   └── PE_Array.sv                          
│   └── tb_PE_Array.sv
├── Matrix/
│   └── lab02_testbench/    # Test Pattern for 4x4 Matrix Mul  
│   └── PE.sv  
│   └── PE_Array.sv                          
│   └── tb_PE_Array.sv
```
**目的 : 根據 Output Satationary Data Flow 實現一個 N x N 的 Systolic Array**  

在這個Lab中，我們分別會去測試兩種運算，並且兩種測資皆會幫助我們做正45度角的Pipeline。  
- 捲積運算 : 我們將以3 x 3的Systolic Array為例，送入36筆資料來模擬捲積運算      
- 矩陣運算 : 我們會以4 x 4的Systolic Array為例，做一個4x4矩陣的相乘    
  
由於我們的程式是參數化設計，因此皆可以擴展到 N X N 的 Systolic Array (包含TB)，我們根據會每個對角線計算完的時間，從每個PE中取出答案存到TestBench中的Result_Matrix，當最後一個對角線計算完後，輸出Result_Matrix的結果出來，如下圖所示。     
|<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/8a61552b-3ed4-4f5b-b446-6df64ff81c02" />| <img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/0d876759-43a4-452e-a230-998179423ac7" /> |
|:--:|:--:|
  
|<img width="396" height="122" alt="image" src="https://github.com/user-attachments/assets/f84de17b-4e7e-4d5a-b7ee-9c4b7e2767ed" /> | <img width="396" height="122" alt="image" src="https://github.com/user-attachments/assets/24f55342-2242-4b7b-bfc0-909e20f0f8c2" />|
|:--:|:--:|


   

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



## [Lab05](./Lab05)  

**目的 : 實現激活函數(Activation Function)進行非線性運算，讓神經網路能逼近更複雜的函數。ReLU的計算效率高且能改善梯度消失問題。**  
```
./Lab05/
├── lab05_testbench/  
│   └── input_data.txt  
│   └── generate_input_data.py
├── RELU.sv                        
└── tb_RELU.sv   
```
