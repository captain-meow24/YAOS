//
// Created by kanishka on 3/11/26.
//

#ifndef KHEAP_H
#define KHEAP_H

#include <stdint.h>
#include <stddef.h>

// These functions hide the heap object from the caller

void kheap_init();
void* kmalloc(size_t size);
void* kzalloc (size_t size);
void kfree(void* ptr);

#endif