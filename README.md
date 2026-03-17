# Basic People Counting System on DE1 FPGA

A hardware-based monitoring system designed to track and manage real-time occupancy and total visitor traffic using the **Terasic DE1 FPGA (Cyclone III)** FPGA platform.

## 📝 Project Overview
In the rapidly evolving field of integrated circuit design, practicing digital logic on FPGA platforms provides essential hands-on experience. This project, titled **"Design and Implementation of a People Counter System,"** bridges the gap between theoretical digital design and real-world embedded applications.

By implementing this system, we have:
* Reinforced core concepts of digital logic and hardware description languages.
* Gained direct experience with industry-standard hardware (FPGA, DE1-SoC board).
* Developed systematic thinking and problem-solving skills for electronics and electrical engineering.

## 🎯 Objectives
The project focuses on the following key goals:
* **Design & Simulation:** Develop and simulate a basic digital circuit on an FPGA.
* **Toolchain Mastery:** Understand the full design flow (programming, synthesis, and configuration) using **Intel Quartus II**.
* **Hardware Verification:** Deploy the design onto the **DE1-SoC** board to evaluate accuracy and efficiency in a real-world environment.
* **Documentation:** Complete a comprehensive technical report including theory, design schematics, and experimental analysis within a one-week timeframe.

## 🚀 Key Features
The system monitors and manages occupancy based on a pre-set threshold, offering several real-time functionalities:

* **Dual-Track Statistics:** Simultaneously monitors the current number of people in the area and the total cumulative visitor count.
* **Visual & Audible Alerts:** * **Green Level:** Low occupancy, normal operation.
    * **Yellow Level:** Moderate occupancy, caution advised.
    * **Red Level:** High occupancy, near capacity.
    * **Buzzer Alarm:** Triggered immediately when the threshold is exceeded (Overload).
* **Independent Reset Logic:** Features a specialized reset mechanism where the "Current Occupancy" can be cleared (e.g., at the end of a shift) without affecting the "Total Cumulative Count." This ensures long-term data integrity for business reporting.

## 🛠 Tech Stack & Components
* **Hardware Description Language:** Verilog HDL / VHDL
* **Development Software:** Intel Quartus II (v13.1)
* **Main Controller:** DE1-SoC FPGA (Cyclone V)
* **Peripherals:**
    * Infrared (IR) Sensors
    * Multi-color LEDs (Red, Yellow, Green)
    * 7-Segment Displays (HEX0 - HEX5)
    * Active Buzzer
    * Breadboard and Jumper Wires

## 📈 Practical Significance
This system provides managers with real-time data to optimize operational efficiency. Insights gained from occupancy trends allow for better staff coordination, space management, and strategic business planning during peak hours.

## 👥 Contributors
* **Cao Khanh Duy** (Student ID: 22130040)
* **Supervisor:** Mr. Kien

---
*This project was developed as part of a Digital Integrated Circuit Design course.*
