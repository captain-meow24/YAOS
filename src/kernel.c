#include "kernel.h"
#include <stdint.h>

void kernel_main()
{
    uint8_t *video_mem = (uint8_t*)(0xB8000);
    video_mem[0] = 'S';
    video_mem[1] = 0x4;
    video_mem[2] = 'H';
    video_mem[3] = 0x2;
}