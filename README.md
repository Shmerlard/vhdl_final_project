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
- [ ] synchronous reset
<!---->
- [ ] interrupts
    - [ ] make sure the program stops,
    - [ ] emulated ins may be a problem
    - [ ] save the state
    - [ ] save temporary register?
<!---->
- [ ] GPIO preipheral
    - [X] make the memory map
    - [ ] hex driver
    - [ ] led driver
    - [ ] gpi driver
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

