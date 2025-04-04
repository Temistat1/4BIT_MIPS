module Testbench;

reg clk;
reg [3:0] opcode;
reg [3:0] operandA, operandB;
wire [3:0] result;
wire mem_write, mem_read;
reg [3:0] memory_in;  // Changed to reg to drive value directly in testbench
wire [3:0] memory_out;

// Instantiate the ALU
ALU uut (
    .opcode(opcode),
    .operandA(operandA),
    .operandB(operandB),
    .result(result),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .memory_in(memory_in),
    .memory_out(memory_out)
);

reg [3:0] memory [0:15];  // Simulated memory

integer i, j, k;

// Initialize memory values
initial begin
    // Initialize memory to known values for testing
    for (i = 0; i < 16; i = i + 1) begin
        memory[i] = i[3:0];  // Simple pattern 0, 1, 2, 3, ..., 15
    end
end

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, Testbench);
   
    clk = 0;

    // Iterate over all opcode values (0000 to 1111)
    for (i = 0; i < 16; i = i + 1) begin
        opcode = i[3:0];

        // Iterate over all possible values for operandA
        for (j = 0; j < 16; j = j + 1) begin
            operandA = j[3:0];

            // Iterate over all possible values for operandB
            for (k = 0; k < 16; k = k + 1) begin
                operandB = k[3:0];

                // For LW operation, set memory_in based on operandB
                if (opcode == 4'b1010) begin
                    memory_in = memory[operandB];  // Load from memory at operandB address
                end else begin
                    memory_in = 4'b0000;  // Default value if not loading from memory
                end

                #10; // Wait for ALU to process

                // Display results in console for debugging
                $display("Opcode: %b | OperandA: %b | OperandB: %b | Result: %b | MemWrite: %b | MemRead: %b | MemoryIn: %b",
                         opcode, operandA, operandB, result, mem_write, mem_read, memory_in);
            end
        end
    end
   
    $stop; // Stop simulation after all tests
end

always #5 clk = ~clk; // Clock signal

endmodule
v
