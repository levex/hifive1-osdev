SDK=/home/lkurusa/dev/freedom-e-sdk
SDK_PREFIX=$(SDK)/work/build/riscv-gnu-toolchain/riscv64-unknown-elf/prefix/bin
CROSS=$(SDK_PREFIX)/riscv64-unknown-elf-
OPENOCD=$(SDK)/work/build/openocd/prefix/bin/openocd

CFLAGS=-g \
       -march=rv32imac \
       -mabi=ilp32 \
       -mcmodel=medany

LINKER_SCRIPT=hifive1.lds
LDFLAGS=-T $(LINKER_SCRIPT) \
	-nostartfiles

	#-L .
	#--specs=nano.specs

main.img: main.c
	$(CROSS)gcc $< $(CFLAGS) -o $@ $(LDFLAGS)

.PHONY: openocd
openocd:
	$(OPENOCD) -f openocd.cfg

.PHONY: flash
flash: main.img
	$(OPENOCD) \
		-f openocd.cfg\
		-c "flash protect 0 64 last off;\
		    program main.img verify;\
		    resume 0x20400000;\
		    exit"

.PHONY: clean
clean:
	rm -rf main.img
	rm -rf main.o
