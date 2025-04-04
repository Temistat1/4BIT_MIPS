module MainProcessor (
    input clk
);

    reg [3:0] opcode;
    reg [3:0] operandA, operandB;
    wire [3:0] result, memory_out, memory_in;
    wire mem_write, mem_read, reg_write, alu_src, mem_to_reg;
    reg [3:0] write_data;
    reg [3:0] write_reg, read_reg1, read_reg2;
    wire [3:0] read_data1, read_data2;

    // Instantiate components
    ControlUnit CU (
        .opcode(opcode), 
        .reg_write(reg_write), 
        .mem_read(mem_read), 
        .mem_write(mem_write), 
        .alu_src(alu_src), 
        .mem_to_reg(mem_to_reg)
    );
    
    RegisterFile RF (
        .clk(clk), 
        .reg_write(reg_write), 
        .read_reg1(read_reg1), 
        .read_reg2(read_reg2), 
        .write_reg(write_reg), 
        .write_data(write_data), 
        .read_data1(read_data1), 
        .read_data2(read_data2)
    );
    
    Memory MEM (
        .clk(clk), 
        .mem_read(mem_read), 
        .mem_write(mem_write), 
        .address(operandB), 
        .write_data(memory_out), 
        .read_data(memory_in)
    ); // Memory instance
    
    ALU ALU (
        .opcode(opcode), 
        .operandA(read_data1), 
        .operandB(read_data2), 
        .result(result), 
        .mem_write(mem_write), 
        .mem_read(mem_read), 
        .memory_in(memory_in), 
        .memory_out(memory_out)
    ); // ALU instance

    always @(posedge clk) begin
        if (mem_to_reg)
            write_data <= memory_in;  // Load data from memory if mem_to_reg is active
        else
            write_data <= result;    // Otherwise, use ALU result
    end

endmodule
