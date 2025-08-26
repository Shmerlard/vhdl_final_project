# VHDL Project

## directories
```text
.
├── doc                 -- documantation files
└── src
    ├── DUT
    │   ├── core        -- top level cpu entity
    │   ├── units       -- all pipeline stages
    │   ├── modules     -- components
    │   ├── memory      -- external memory?
    │   └── utils       -- utilities (const)
    ├── SIM             -- simulation files (wave, do)
    ├── SW              -- software and programs
    └── TB              -- test benches

```
## Todo
<!---->
- [X] create initial structure for directories
- [X] synchronous reset
<!---->
- [ ] cpu
    - [ ] more testing for lw sw and hazards
    - [ ] clean signals
    - [ ] make sure all register are correct
    - [X] check on changing the memory after programming
<!---->
- [ ] interrupts
    - [X] add support for writing to ifg reg
    - [X] tests
    - [X] make sure the program stops,
    - [X] emulated ins may be a problem
    - [X] save the state
    - [X] save temporary register?
<!---->
- [ ] GPIO preipheral
    - [X] make the memory map
    - [X] hex driver
    - [X] led driver
    - [X] gpi driver
    - [ ] integration with main cpu
<!---->
- [ ] HW accel
    - [ ] more modules
        - [ ] extended nbit_dff with autoclear and read as zero.
    - [ ] FIR
        - [ ] Build
        - [ ] Test
        - [ ] Documantation
    - [ ] Timers
        - [X] Build
        - [X] Test
        - [ ] Documantation
    - [ ] UART
<!---->
- [ ] Compile using mars
- [ ] Documantation !!!
- [ ] graphs using draw.io

