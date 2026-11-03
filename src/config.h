//
// Created by kanishka on 25/10/26.
//

#ifndef CONFIG_H
#define CONFIG_H

#define YAOS_TOTAL_INTERRUPTS 512

#define KERNEL_CODE_SELECTOR 0x08    // Points to Entry 1 (byte offset 0x08) in your GDT.
#define KERNEL_DATA_SELECTOR 0x10    // Points to Entry 2

// 100MB heap size
#define YAOS_HEAP_SIZE_BYTES 104857600
#define YAOS_HEAP_BLOCK_SIZE 4096
#define YAOS_HEAP_ADDRESS 0x01000000
#define YAOS_HEAP_TABLE_ADDRESS 0x00007E00

#endif //CONFIG_H
