FILES = ./build/kernel.asm.o ./build/kernel.o
NCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -oo -Iinc
CROSS_PREFIX ?= $(HOME)/opt/cross/bin/i686-elf-

all: ./bin/os.bin

./bin/os.bin: ./bin/boot.bin ./bin/kernel.bin
	cat ./bin/boot.bin ./bin/kernel.bin > ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/kernel.bin: $(FILES) ./src/linker.ld
	$(CROSS_PREFIX)ld -g -r $(FILES) -o ./build/kernelfull.o
	$(CROSS_PREFIX)gcc $(FLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./bin/boot.bin: ./src/boot/boot.asm
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

./build/kernel.asm.o: ./src/kernel.asm
	nasm -f elf -g ./src/kernel.asm -o ./build/kernel.asm.o

./build/kernel.o: ./src/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAG) -std=gnu99 -c ./src/kernel.c -o ./build/kernel.o

clean:
	rm -rf ./bin/boot.bin ./bin/kernel.bin ./bin/os.bin ./build/kernelfull.o 
	rm -rf ${FILES}
