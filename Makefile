# pcf8563-spin Makefile - requires GNU Make, or compatible
# Variables below can be overridden on the command line
#	e.g. make TARGET=PCF8563_SPIN PCF8563-Demo.binary

# P1, P2 device nodes and baudrates
#P1DEV=
P1BAUD=115200
#P2DEV=
P2BAUD=2000000

# P1, P2 compilers
P1BUILD=flexspin --interp=rom
#P1BUILD=flexspin
P2BUILD=flexspin -2

# For P1 only: build using the bytecode or PASM-based I2C engine
# (independent of overall bytecode or PASM build)
#TARGET=PCF8563_SPIN
TARGET=PCF8563_PASM

# Paths to spin-standard-library, and p2-spin-standard-library,
#  if not specified externally
SPIN1_LIB_PATH=~/spin-standard-library/library
SPIN2_LIB_PATH=~/p2-spin-standard-library/library


# -- Internal --
SPIN1_DRIVER_FN=$(SPIN1_LIB_PATH)/time.rtc.pcf8563.spin
SPIN2_DRIVER_FN=$(SPIN2_LIB_PATH)/time.rtc.pcf8563.spin2
SPIN1_CORE_FN=$(SPIN1_LIB_PATH)/core.con.pcf8563.spin
SPIN2_CORE_FN=$(SPIN2_LIB_PATH)/core.con.pcf8563.spin
# --

# Build all targets (build only)
all: PCF8563-Demo.binary PCF8563-Demo.bin2

# Load P1 or P2 target (will build first, if necessary)
p1demo: loadp1demo
p2demo: loadp2demo

# Build binaries
PCF8563-Demo.binary: PCF8563-Demo.spin $(SPIN1_DRIVER_FN) $(SPIN1_CORE_FN)
	$(P1BUILD) -L $(SPIN1_LIB_PATH) -b -D $(TARGET) PCF8563-Demo.spin

PCF8563-Demo.bin2: PCF8563-Demo.spin2 $(SPIN2_DRIVER_FN) $(SPIN2_CORE_FN)
	$(P2BUILD) -L $(SPIN2_LIB_PATH) -b -2 -D $(TARGET) -o PCF8563-Demo.bin2 PCF8563-Demo.spin2

# Load binaries to RAM (will build first, if necessary)
loadp1demo: PCF8563-Demo.binary
	proploader -t -p $(P1DEV) -Dbaudrate=$(P1BAUD) PCF8563-Demo.binary

loadp2demo: PCF8563-Demo.bin2
	loadp2 -SINGLE -p $(P2DEV) -v -b$(P2BAUD) -l$(P2BAUD) PCF8563-Demo.bin2 -t

# Remove built binaries and assembler outputs
clean:
	rm -fv *.binary *.bin2 *.pasm *.p2asm

