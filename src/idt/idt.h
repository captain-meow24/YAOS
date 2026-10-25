//
// Created by kanishka on 25/10/26.
//

#ifndef IDT_H
#define IDT_H

#include <stdint.h>

struct idt_desc
{
    uint16_t offset_1;    //0-15 bits
    uint16_t selector;
    uint8_t zero;    //does nothing
    uint8_t type_attr;    //descriptor type and attribute
    uint16_t offset_2;    //16-31 bits
} __attribute__((packed));

struct idtr_desc
{
    uint16_t limit;    //size of descriptor table - 1
    uint32_t base;    //base address of the start of the interrupt descriptor table
} __attribute__((packed));

void idt_init();

#endif //IDT_H
