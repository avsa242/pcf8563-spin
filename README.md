# pcf8563-spin 
--------------

This is a P8X32A/Propeller driver object for the PCF8563 Real-time clock

## Salient Features

* I2C connection at up to 400kHz
* Read and set days, hours, months, minutes, seconds, weekday, year (individually)
* Clock data integrity flag

## Requirements

P1/SPIN1:
* 1 extra core/cog for the PASM I2C engine

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81)

## Limitations

* Very early in development - may malfunction, or outright fail to build

## TODO

- [ ] Support interrupts
- [ ] Support CLKOUT control
- [ ] Port to P2/SPIN2
