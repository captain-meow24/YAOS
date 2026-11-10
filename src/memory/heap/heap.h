//
// Created by kanishka on 3/11/26.
//

#ifndef HEAP_H
#define HEAP_H

#include "config.h"
#include <stdint.h>
#include <stddef.h>

#define HEAP_BLOCK_TABLE_ENTRY_TAKEN 0x01    // these are flags used in the 8-bit entries of the table
#define HEAP_BLOCK_TABLE_ENTRY_FREE  0x00
#define HEAP_BLOCK_HAS_NEXT 0b10000000
#define HEAP_BLOCK_IS_FIRST 0b01000000

typedef unsigned char HEAP_BLOCK_TABLE_ENTRY;    // size of each entry is 8 bits

struct heap_table    // describes the table that keeps track of the heap blocks
{
    HEAP_BLOCK_TABLE_ENTRY* entries;    // stores the address of the array of block entries
    size_t total;
};

struct heap    // manages heap memory region
{
    struct heap_table* table;    // address of the struct heap_table object
    void* saddr;    // start address of actual heap memory
};

// These functions require you to explicitly provide a heap object

int heap_create(
    struct heap* heap,    // heap object
    void* ptr,        // Starting address of the memory region that will become the heap
    void* end,        // Ending address of that memory region
    struct heap_table* table    // heap table object
);

void* heap_malloc(struct heap* heap, size_t size);    // allocates a requested amount of memory from the heap

void heap_free(struct heap* heap, void* ptr);        // frees memory from the heap

#endif


