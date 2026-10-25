//
// Created by kanishka on 25/10/26.
//
#include "config.h"
#include "idt.h"

struct idt_desc idt_descriptors[YOAS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;
