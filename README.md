# ATTILA: A Wave Digital Circuit Simulator

<p align="center"><img src="https://github.com/polimi-ispl/attila/blob/ef6fdf4b24b623ccad1e480d1068833d43c5c408/Assets/logo2.png"/>

Welcome to the official repository of **ATTILA** (*wAve digiTal circuiT sImuLAtor*), an open-source framework for the **automatic generation and simulation of Wave Digital (WD) circuit models** starting from standard SPICE netlists.

This repository accompanies the paper:

> **“ATTILA: A Wave Digital Circuit Simulator”**  
> R. Giampiccolo, S. Ravasi, A. Bernardini  
> *submitted to IEEE Transactions on Circuits and Systems—II: Express Briefs*

---

## 📖 About ATTILA

ATTILA is a general-purpose circuit simulator based on **Wave Digital Filter (WDF) theory**, designed to bridge conventional SPICE workflows with modern wave-based circuit modeling techniques.

Starting from a SPICE netlist (e.g., generated in LTspice), ATTILA:
1. Parses the circuit topology,
2. Automatically constructs the corresponding WDF,
3. Simulates the circuit in the time domain under user-defined inputs.

The framework leverages recent theoretical advances in WDFs, including automatic topology handling and port adaptation, enabling efficient and numerically robust simulation of large-scale nonlinear circuits.

ATTILA is released as a **MATLAB application** with an intuitive graphical user interface.

---

## ✨ Main Features

- Automatic WDF generation from standard SPICE netlists  
- Multiple wave definitions (voltage, current, power-normalized)  
- Multiple discretization schemes (BDF, Adams–Moulton, various orders)  
- Explicit and iterative solution strategies for nonlinear circuits  
- Several iterative solvers for multiple nonlinearities  
- Graphical visualization of tree–cotree decomposition  
- Flexible plotting of voltages and currents at any port  
- Open-source and extensible research-oriented implementation  

---

## 💻 Requirements

- **MATLAB R2022b or later** (tested on both R2022b and R2024a)
- No additional MATLAB toolboxes are strictly required

ATTILA has been tested on:
- macOS (Apple Silicon)
- Windows

---

## 🚀 Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/polimi-ispl/attila.git
   ```

2. Open MATLAB and add the repository to the path:
   ```matlab
   addpath(genpath('path/to/attila'))
   ```

3. Launch ATTILA by opening 'Design APP' and loading `Main.mlapp`.

4. Load a SPICE netlist (`.net`, `.cir`, or `.txt`) and configure the simulation parameters via the GUI.

---

## 🧮 Algorithms and Simulation Strategies

ATTILA supports two main solution paradigms depending on circuit structure.

### Explicit Solution (Single Nonlinear One-Port)

If the circuit contains **only one nonlinear one-port element** (possibly after diode consolidation), ATTILA applies a **fully explicit wave digital algorithm**, avoiding iterative solvers altogether.  
This is enabled by automatically adapting the junction port connected to the nonlinear element.

### Iterative Solution (Multiple Nonlinear One-Ports)

For circuits with multiple nonlinear one-port elements, ATTILA employs iterative wave-based solvers. The following methods are implemented:

- Scattering Iterative Method (SIM)
- Wave Digital Newton–Raphson (WDNR)
- Fixed WDNR (WDFNR)
- Wave Digital Extended Fixed-Point (WDEFP)
- Wave Digital Potra–Pták (WDPP)

Dynamic Scattering Recomposition (DSR) is used to reduce the computational cost associated with recomputing scattering matrices.

---

## 🖥️ Graphical User Interface (GUI)

The ATTILA GUI allows the user to configure all simulation parameters.

### Input Signal
- **Function**: MATLAB expression `f(t)`
- **File**: `.wav`, `.txt`, or `.mat`

### Simulation Parameters
- Simulation length
- Sampling frequency (Function mode)
- Wave definition (voltage / current / power-normalized)
- Discretization method and order
- Iterative solver and tolerance
- DSR activation and tolerance

### Visualization
- Automatic display of tree–cotree decomposition
- Plotting of arbitrary port voltages and currents

---

## 🔌 LTspice Integration

ATTILA is designed to work seamlessly with **LTspice**.

### Workflow
1. Draw the circuit schematic in LTspice
2. Export the netlist
3. Load the netlist into ATTILA

### Schematic Design Rules

To ensure compatibility:

- Use a single input source (voltage or current)
- Avoid duplicate component names
- Do not manually rename nodes
- Ensure the presence of a global reference node (ground)
- Supported nonlinear elements:
  - Diodes
  - Diode series
  - Antiparallel diode pairs
- Ideal operational amplifiers are supported via nullor modeling

Further details and examples are provided in the `examples/` directory.

---

## ⚠️ Current Limitations

- Only **one-port nonlinear elements** are currently supported
- Multi-port nonlinearities are not yet implemented
- Focus is on time-domain simulation (no AC or noise analysis)

These limitations are architectural rather than theoretical and can be addressed in future extensions.

---

## 📊 Reproducibility and Benchmarking

Simulation results reported in the accompanying paper were obtained using:
- Apple Silicon M1 Pro processor
- MATLAB R2022b
- Simulation times averaged over 100 runs

ATTILA prioritizes **flexibility and configurability** over low-level optimization; nevertheless, it exhibits favorable scalability for large nonlinear circuits.

---

## 📌 Citation

If you use ATTILA in your research, please cite:

```bibtex
@article{giampiccolo2026attila,
  title={ATTILA: A Wave Digital Circuit Simulator},
  author={Giampiccolo, Riccardo and Ravasi, Stefano and Bernardini, Alberto},
  year={2025}
}
```

---

## 🛣️ Roadmap

- Support for additional nonlinear element types
- Performance optimizations
- Extended documentation and tutorials
- Additional benchmark circuits

---

## 🤝 Contributing

Contributions are welcome. You can:
- Open issues
- Propose features
- Submit pull requests

---

## 📧 Contact

For questions or feedback:
- **riccardo.giampiccolo@polimi.it**
- **stefanoravasi98@gmail.com**

---

## 📜 License

This project is licensed under the **GPL-3.0 License**.  
See the `LICENSE` file for details.
