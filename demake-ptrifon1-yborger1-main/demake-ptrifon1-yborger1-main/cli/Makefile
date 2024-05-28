CC := cc65
CA := ca65
LD := ld65

TARGET_PLATFORM := nes

TARGETS := hello.nes
TARGETS += scroll.nes

EMULATOR ?= fceux

EXAMPLES := $(TARGETS:..nes=)
OBJECTS := $(TARGETS:.nes=.o)
ASSEMBLY_SOURCES := $(TARGETS:.nes=.s)
C_SOURCES := $(TARGETS:.nes=.c)

.PHONY: all

# Disable builtin rules (for .c, .o) by providing an empty .SUFFIXES rule
# Yes. GNU make is a rat's nest
.SUFFIXES:

# Make sure intermediate files are *NOT* deleted
# Yes. GNU make is a rat's nest
.PRECIOUS: %.s %.o

all: $(TARGETS)


%: %.nes
	$(EMULATOR) $<

clean:
	@rm -fv $(TARGETS)
	@rm -fv $(OBJECTS)
	@rm -fv $(ASSEMBLY_SOURCES)
	@rm -fv crt0.o
	@rm -fv tiles.o

%.s: %.c
	$(CC) -Oi $< --target $(TARGET_PLATFORM) --add-source

%.o: %.s
	$(CA) $<

%.nes: %.o crt0.o tiles.o
	$(LD) -C nrom_128_horz.cfg -o $@ $^ $(TARGET_PLATFORM).lib

