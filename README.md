# Assembly Language Programming Tasks - README

## Overview

This repository contains solutions for four assembly language programming tasks, focusing on control flow, data manipulation, modular programming, and simulation of control systems. Each program demonstrates core concepts of low-level programming, including conditional logic, looping, stack management, and memory operations.

### Task 1: Control Flow and Conditional Logic
- **Purpose**: Classifies a user-provided number as **"POSITIVE,"** **"NEGATIVE,"** or **"ZERO"** using conditional and unconditional jumps.
- **Key Concepts**: Conditional branching (`je`, `jg`, `jl`), program flow control, and output display.

### Task 2: Array Manipulation with Looping and Reversal
- **Purpose**: Accepts an array of integers, reverses it in place using loops, and outputs the reversed array.
- **Key Concepts**: Looping structures, in-place memory manipulation, and direct handling of registers.

### Task 3: Modular Program with Subroutines for Factorial Calculation
- **Purpose**: Computes the factorial of a user-provided number using a separate subroutine. Demonstrates modular programming and stack usage.
- **Key Concepts**: Subroutines, stack operations, and modular code design.

### Task 4: Data Monitoring and Control Using Port-Based Simulation
- **Purpose**: Simulates a sensor-based control system that turns a motor and alarm ON/OFF based on sensor values.
- **Key Concepts**: Memory location manipulation, control logic, and hardware simulation.

---

## Compilation and Execution Instructions

1. **Ensure an Assembly Compiler/Debugger**  
   Install an assembler like [NASM](https://www.nasm.us/) and ensure the system has a linker (e.g., `ld` for Linux).

2. **Compile the Program**  
   ```bash
   nasm -f elf64 task1.asm -o task1.o

3. **Link the Program**  
   ```bash
   ld task1.o -o task1

4. **Run the Program**  
   ```bash
   ./task1
