# Digital Signal Processing on FPGA

This repository contains a Systemverilog implementation of an **Audio Equalizer** designed for FPGA platforms.  
The system supports real-time audio processing, frequency band filtering, and adjustable gain controls.

It was developed as a semester project at **University of Technology – VNU-HCM** as part of the Digital Signal Processing on FPGA course.

<img width="919" height="507" alt="image" src="https://github.com/user-attachments/assets/135b3f6e-564e-46ec-a19e-bb8f0d070229" />

## Project Overview

The Audio Equalizer receives audio input, processes it through multiple digital filters (e.g., **FIR**, **IIR**), and outputs the modified signal in real time via an audio CODEC.

Key components include:
- Audio input/output interface (via **WM8731 Audio CODEC**)
- Multiple-band filter modules (e.g., low-pass, band-pass, high-pass)
- Gain control for each frequency band
- Control interface for dynamic adjustment
---

## Getting Started
To simulate or synthesize the design, use the following tools:

- ✅ **ModelSim** for Verilog simulation
- ✅ **Quartus Prime** for FPGA implementation
- ✅ **DE10-Lite / DE2-115 FPGA board** (or similar)
- ✅ **WM8731 Audio CODEC module** for real audio I/O

## License

This project is licensed under the MIT License – see the LICENSE file for details.

## Acknowledgments

* University of Technology(VNU-HCM) for the course on Digital Signal Processing on FPGA.
* ThS. Nguyễn Tuấn Hùng, the instructor of this course, for his guidance, troubleshooting support, and for providing detailed lab materials throughout the project.
* 2 group members, Phương Hiển Long and Huỳnh Kiến Hào for their strong collaboration and contributions in designing, implementing, and testing various modules of the Audio Equalizer system.

