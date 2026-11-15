//
// Created by kanishka on 13/11/26.
//

#ifndef PAGING_H
#define PAGING_H

#include <stdint.h>
#include <stddef.h>

#define PAGING_CACHE_DISABLED  0b00010000    //when the CPU reads or writes a memory address, it stores a copy of that data inside its ultra fast, on chip L1/L2/L3 CPU caches
                                            // instead of going all the way to RAM every time.
                                           // Setting PAGING_CACHE_DISABLED (1) forces the CPU to completely bypass its internal caches for that specific page,
                                          // reading and writing directly to the physical bus every single time.
#define PAGING_WRITE_THROUGH   0b00001000
#define PAGING_ACCESS_FROM_ALL 0b00000100
#define PAGING_IS_WRITEABLE    0b00000010
#define PAGING_IS_PRESENT      0b00000001    // if it's not set, it causes a page fault an then we load the page from disk

// These flags are used in both page directory and page entry
// When the CPU's Memory Management Unit (MMU) translates a virtual address, it treats the permission flags (R/W and U/S)
// as a logical AND gate across both page directory and page table, both have to be permissible to get the permission
// he most restrictive level wins

#define PAGING_TOTAL_ENTRIES_PER_TABLE 1024
#define PAGING_PAGE_SIZE 4096

struct paging_4gb_chunk
{
    uint32_t* directory_entry;
};

struct paging_4gb_chunk* paging_new_4gb(uint8_t flags);
void paging_switch(uint32_t* directory);
void enable_paging();
uint32_t* paging_4gb_chunk_get_directory(struct paging_4gb_chunk* chunk);

#endif
