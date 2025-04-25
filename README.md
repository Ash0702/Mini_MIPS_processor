# Mini-MIPS Processor Documentation

## Overview

This project implements a **Mini-MIPS processor** in Verilog with a 32-bit single-cycle architecture. The design uses **separate Instruction Memory and Data Memory**, and supports:

- 32 general-purpose registers
- 32 floating-point registers
- R-type, I-type, and J-type instructions

Instruction fetch, decode, execution, and control are modularized for clarity and maintainability.

Uses the Distributed memory (Dual Port RAM) available from IP catalogue in Vivado

---

## Instruction Set Architecture

The processor uses a custom instruction encoding with three types:

### R-Type Instructions
- **Format:** `[31:26] opcode | [25:21] rd | [20:16] rt | [15:11] rs | [10:6] shamt | [5:0] func`
- **Examples:** `add`, `sub`, `and`, `sll`, `xor`

### I-Type Instructions
- **Format:** `[31:26] opcode | [25:21] rd | [20:16] rt | [15:0] immediate`
- **Examples:** `addi`, `lw`, `sw`, `beq`, `slti`

### J-Type Instructions
- **Format:** `[31:26] opcode | [25:0] jaddress`
- **Examples:** `j`, `jal`

The **Splitter** module handles decoding by extracting the appropriate fields from the 32-bit instruction input.

---

## Key Components and Functionality

### 🔹 DistributedMemory
- Dual-port memory (1024 locations)
- **Reads:** Positive clock edge
- **Writes:** Negative clock edge
- Used for **Instruction Memory** and **Data Memory**

### 🔹 RegisterFile
- 32 general-purpose + 32 floating-point registers
- **Reads:** Asynchronous
- **Writes:** Negative clock edge
- All registers reset to `0`
- Outputs: `rs_out`, `rt_out`, and `Reg1` to `Reg5`

### 🔹 Splitter
- Decodes a 32-bit instruction into:
  - `opcode`, `rs`, `rt`, `rd`, `shamt`, `func`, `address_constant`, `jaddress`

### 🔹 ALU
- Operations:
  - Arithmetic: `add`, `sub`, `addu`, `subu`
  - Logic: `and`, `or`, `xor`, `not`
  - Shift: `sll`, `srl`, `sla`, `sra`
  - Comparison: `slt`, `seq`, etc.
- Supports 64-bit multiplication

### 🔹 Floating Point Units
- **floating_adder:**
  - Handles floating-point `add/sub` with proper sign/exponent/mantissa logic
- **FPU:**
  - Executes floating-point operations (`add.s`, `sub.s`, `c.eq.s`)

### 🔹 PC_Controller
- Controls the **Program Counter**
- On reset: PC = 0
- Updates based on jumps, branches, or sequential instructions

### 🔹 ALU_controller
- Maps `opcode` and `func` to ALU control signal (`ALUctrl`)
- Example: `0 → add`, `1 → sub`, etc.

### 🔹 SignExtender
- Extends 16-bit immediate values to 32-bit (with sign extension)

### 🔹 mux2_1
- 2-to-1 multiplexer for input selection

### 🔹 Controller
- Generates control signals:
  - `write_reg`, `data_write`, `immediate`, `jump`, `branch`, `jal`, `select_ALU_or_Mem`, `mfc1`

### 🔹 FPR_controller
- Handles floating-point register write and `mtc1` control

### 🔹 CPU (Top-Level)
- Integrates all modules:
  - Fetch → Decode → Execute → Memory Access → Writeback
- Outputs:
  - `OutputOfR1` to `OutputOfR5`
  - `done` signal (when PC reaches 50)

---

## How It Works

###  Instruction Flow:
1. **Fetch:** PC fetches instruction from Instruction Memory
2. **Decode:** Splitter decodes; Controller sets control lines
3. **Execute:**
   - ALU → integer ops
   - FPU → floating-point ops
   - Data Memory → `lw`, `sw` with computed addresses
4. **Branch/Jump:** PC updated based on control logic
5. **Write Back:** Registers or memory are updated in one cycle

---

## Usage

- **Reset:** Set `rst = 1` to initialize registers and PC
- **Load Instructions:**
  - Use `write_instruction` at `address` with `inst_data`
- **Run:**
  - Supply `clk`
  - Monitor outputs: `OutputOfR1` to `OutputOfR5`, `done` signal

###  Data Memory Access
- Use `write_data` with:
  - `memory_in` (address)
  - `memory_write` (data)

---

## Notes

- **Read behavior:** Asynchronous for memory/registers
- **Write behavior:** Synchronous on negative clock edge
- Design is **modular and well-commented**
- Floating-point logic is **simplified** for single precision  (Changes can be made for full IEEE-754).

---

# Developers 
- Saksham Verma
- Rohit Yadav  
