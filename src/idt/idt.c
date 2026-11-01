#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "kernel.h"
#include "io/io.h"

struct idt_desc idt_descriptors[YAOS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;

void idt_zero()
{
    print("Divide by zero error\n",15);
}

void idt_set(int interrupt_no, void* address)    // sets values for every interrupt descriptor
{
    struct idt_desc* desc = &idt_descriptors[interrupt_no];    // IDT is an array, each interrupt is one entry/index
    desc->offset_1 = (uint32_t) address & 0x0000ffff;    //lower 16 bits
    desc->selector = KERNEL_CODE_SELECTOR;    //code offset to GDT
    desc->zero = 0x00;        //Intel reserved this byte for future CPU architecture expansions and alignment
    desc->type_attr = 0xEE;    //permissions, present flag, gate type
    desc->offset_2 = (uint32_t) address >> 16;    //higher 16 bits
}

extern void idt_load(struct idtr_desc* ptr);
extern void int21h();
extern void no_interrupt();

void int21h_handler()
{
    print("Keyboard pressed!\n", 12);
    outb(0x20, 0x20);
}

void no_interrupt_handler()
{
    outb(0x20, 0x20);
}

void idt_init()
{
    memset(idt_descriptors, 0, sizeof(idt_descriptors));    //initalising idt array
    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptor.base = (uint32_t)idt_descriptors;

    for (int i = 0; i < YAOS_TOTAL_INTERRUPTS; i++)    //set up all entries with no_interrupt
    {
        idt_set(i, no_interrupt);
    }

    idt_set(0, idt_zero);
    idt_set(0x21, int21h);

    idt_load(&idtr_descriptor);
}