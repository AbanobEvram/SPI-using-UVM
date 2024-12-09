# SPI-using-UVM
Design and implementation of the Serial Peripheral Interface (SPI) communication protocol using SystemVerilog, with verification conducted through the Universal Verification Methodology (UVM).
# About SPI
The Serial Peripheral Interface (SPI) is a high-speed, synchronous serial communication protocol commonly used in embedded systems for short-distance, full-duplex communication between a master and one or more slaves.

## Key Features:

* Synchronous Communication: Data is clock-synchronized for precision and reliability.
* Full-Duplex Transmission: Enables simultaneous two-way data exchange.
* High Speed: Suitable for high-bandwidth applications.
* Simple Hardware: Minimal lines required (MOSI, MISO, SCK, and optionally SS).
## Signal Lines:

* MOSI: Master to Slave data line.
* MISO: Slave to Master data line.
* SCK: Master-generated clock for synchronization.
## Communication Steps:

* Initialization: Master sets up the clock and SPI configurations.
* Data Transfer: Simultaneous data exchange on MOSI and MISO lines, synchronized by SCK.
* Transmission: Bits shift serially, exchanging data per clock cycle.
## Advantages:

* High speed and flexibility in configurations.
* Minimal hardware requirements.
## Disadvanttage:

* No standardized protocol, leading to compatibility challenges.
* Additional coordination needed for multiple slaves (not used in our design).
* ************************************************
# SPI Architecture:
![SPI_Architecture](https://github.com/AbanobEvram/SPI-using-UVM/blob/main/Photos/SPI_Architecture.png)
***************************************************************************
# SPI State Diagram:
![SPI_State_Diagram](https://github.com/AbanobEvram/SPI-using-UVM/blob/main/Photos/SPI_State_Diagram.png)
*********************************************************

# UVM Structure
The verification environment comprises three distinct setups:

1. Wrapper Environment: Contains an active driver and sequencer, responsible for generating and driving sequences for the wrapper.
2. RAM Environment: Includes a passive driver and sequencer, used to monitor and verify RAM-related signals.
3. Slave Environment: Features a passive driver and sequencer, dedicated to monitoring and verifying the Slave's behavior.
The sequence generation is centralized in the wrapper environment
****************************************************************************
![UVM_Structure](https://github.com/AbanobEvram/SPI-using-UVM/blob/main/Photos/UVM_Structure.png)
***************************************************************************
## Note:
* You can check the uvm flow from the report
