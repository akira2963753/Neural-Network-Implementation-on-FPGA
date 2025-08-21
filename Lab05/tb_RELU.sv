module RELU_tb;

  parameter SUM_WIDTH = 32;
  parameter NUM_DATA = 128;
  logic clk, rst_n; // logic declaration can replace wire and reg
  logic [SUM_WIDTH-1:0] in_data;
  logic [SUM_WIDTH-1:0] out_data;

  logic [SUM_WIDTH-1:0] data_mem [0:NUM_DATA-1];
  integer i, outfile;

  // Instantiate the DUT
  RELU #(.SUM_WIDTH(SUM_WIDTH)) uut (
    .clk(clk),
    .rst_n(rst_n),
    .in_data(in_data),
    .out_data(out_data)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Read input file
  initial begin
    $readmemh("C:/verilog/NCUE/LAB5/input_data.txt", data_mem); // read 128 lines of hex
  end

  // Output result file
  initial begin
    clk = 0;
    rst_n = 0;

    #20;
    rst_n = 1;

    outfile = $fopen("output_data.txt", "w");

    for (i = 0; i < NUM_DATA; i = i + 1) begin
      in_data = data_mem[i];
      @(posedge clk);
      //#1; // wait 1ns after clock edge
      $fdisplay(outfile, "%08x", out_data);  // write in hex
    end

    $fclose(outfile);
    $finish;
  end

endmodule

