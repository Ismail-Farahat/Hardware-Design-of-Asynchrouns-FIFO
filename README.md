# Hardware-Design-of-Asynchrouns-FIFO

## Overview
This repository contains the RTL implementation and testbench for a parameterized FIFO (First-In-First-Out) memory design. The FIFO is designed to handle efficient data buffering between different clock domains or processing units, ensuring smooth data flow in digital systems.

## Features
- Parameterized FIFO depth and width
- Support for both synchronous and asynchronous clock domains
- Gray code-based pointer synchronization for reliable operation in asynchronous mode
- Full and empty flag generation for flow control
- Read and write pointer management
- Fully synthesizable and verified using SystemVerilog testbench

## File Structure

### RTL Files
- **fifo_mem.v**: Implements the core FIFO memory storage using register arrays.
- **FIFO_TOP.v**: Top-level module integrating FIFO components.
- **rd_ptr_handler.v**: Handles the read pointer logic and synchronization.
- **wr_ptr_handler.v**: Manages the write pointer logic and synchronization.
- **sync.v**: Synchronization module to safely transfer data between different clock domains.

### Testbench
- **FIFO_TOP_tb.sv**: SystemVerilog testbench that applies stimulus to the FIFO design and verifies its behavior.

## Design Details
The FIFO design consists of separate read and write pointer handlers, ensuring proper management of data flow. The memory is implemented as a register-based array with flags for full and empty conditions. The design can operate in both synchronous and asynchronous modes, making it suitable for various digital applications such as data buffering, pipelining, and inter-module communication.

### Key Functional Blocks:
1. **Write Pointer Handler**: Increments write pointer and handles full condition detection.
2. **Read Pointer Handler**: Manages read operations and empty condition detection.
3. **Memory Storage**: A register-based implementation for storing data.
4. **Synchronization Module**: Ensures reliable pointer updates in asynchronous mode.

## Usage
### Simulation
To run a simulation of the FIFO design:
1. Use a simulator like ModelSim, VCS, or Verilator.
2. Compile the testbench along with the RTL files:
   ```shell
   vlog FIFO_TOP_tb.sv fifo_mem.v FIFO_TOP.v rd_ptr_handler.v wr_ptr_handler.v sync.v
   vsim FIFO_TOP_tb
   ```
3. Run the simulation and analyze waveforms using a viewer like GTKWave or ModelSim.

### Synthesis
To synthesize the design using Vivado:
1. Open Vivado and create a new project.
2. Add the RTL files.
3. Set the target FPGA and run synthesis.

