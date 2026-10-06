FILES = ./build/kernel.asm.o
CROSS_PREFIX ?= $(HOME)/opt/cross/bin/i686-elf-

all: ./bin/os.bin

./bin/os.bin: ./bin/boot.bin ./bin/kernel.bin
	cat ./bin/boot.bin ./bin/kernel.bin > ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/kernel.bin: $(FILES) ./src/linker.ld
	$(CROSS_PREFIX)ld -g -r $(FILES) -o ./build/kernelfull.o
	$(CROSS_PREFIX)gcc -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./bin/boot.bin: ./src/boot/boot.asm
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

./build/kernel.asm.o: ./src/kernel.asm
	nasm -f elf -g ./src/kernel.asm -o ./build/kernel.asm.o

clean:
	rm -f ./bin/boot.bin ./bin/kernel.bin ./bin/os.bin ./build/kernelfull.o ./build/kernel.asm.o
