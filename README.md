# pcf8563-spin 
--------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the PCF8563 Real-time clock

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* I2C connection at up to ~30kHz (P1: SPIN I2C), 400kHz (P1: PASM I2C, P2)
* Read and set days, hours, months, minutes, seconds, weekday, year (individually)
* Clock data integrity flag
* Set, clear, query interrupts
* Set on-chip timer (operates independently of time clock)
* Set CLKOUT pin clock frequency

## Requirements

P1/SPIN1:
* 1 extra core/cog for the PASM I2C engine (none if SPIN I2C engine is used)

P2/SPIN2:
* p2-spin-standard-library

## Compiler Compatibility

* P1/SPIN1 OpenSpin (bytecode): Untested (deprecated)
* P1/SPIN1 FlexSpin (bytecode): OK, tested with 5.9.7-beta
* P1/SPIN1 FlexSpin (native): OK, tested with 5.9.7-beta
* ~~P2/SPIN2 FlexSpin (nu-code): FTBFS, tested with 5.9.7-beta~~
* P2/SPIN2 FlexSpin (native): OK, tested with 5.9.7-beta
* ~~BST~~ (incompatible - no preprocessor)
* ~~Propeller Tool~~ (incompatible - no preprocessor)
* ~~PNut~~ (incompatible - no preprocessor)

## Limitations

* Very early in development - may malfunction, or outright fail to build

