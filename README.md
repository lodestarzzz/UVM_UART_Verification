# UVM Verification Environment for UART IP

![Status](https://img.shields.io/badge/Status-Completed-green)
![Language](https://img.shields.io/badge/Language-SystemVerilog%2FVerilog-blue)
![Framework](https://img.shields.io/badge/Framework-UVM-orange)

## 📖 项目简介 (Introduction)

本项目是一个基于 **UVM (Universal Verification Methodology)** 搭建的验证环境，用于验证 **UART (Universal Asynchronous Receiver/Transmitter)** IP 核的功能。

该环境采用了 **双 Agent 架构 (Dual-Agent Architecture)**，能够完整覆盖 UART 的发送 (TX) 和接收 (RX) 功能，并实现了自动化的数据比对 (Scoreboard) 和 覆盖率收集。

### 🔑 关键特性 (Key Features)

* **双 Agent 架构**:
    * `Host Agent`: 模拟 CPU 行为，驱动 `tx_start/tx_data` 等控制信号，验证 IP 的 TX 通路。
    * `UART Agent`: 模拟外部串口设备，驱动 `uart_rx` 串行信号，验证 IP 的 RX 通路。
* **自检机制 (Self-Checking)**: 集成 `Scoreboard`，利用 Reference Model (Queue) 自动比对期望数据与实际数据。
* **多场景测试**: 包含 Sanity Test (冒烟测试), Loopback Test (回环测试), Random Test (随机测试) 等。
* **自动化脚本**: 提供 `Makefile` 支持一键编译、仿真和打开波形。

---

## 🏗️ 验证架构 (Verification Architecture)



```mermaid
graph TD
    Test --> Env
    Env --> Host_Agent
    Env --> UART_Agent
    Env --> Scoreboard
    
    Host_Agent -- Drive Input --> DUT(UART IP)
    UART_Agent -- Drive RX Line --> DUT
    
    DUT -- TX Line --> UART_Agent
    DUT -- Output Data --> Host_Agent
    
    Host_Agent -- Monitor --> Scoreboard
    UART_Agent -- Monitor --> Scoreboard
