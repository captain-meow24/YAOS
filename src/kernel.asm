
[BITS 32]
global _start
global problem
extern kernel_main
CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; enable A20 Line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Remap master PIC, by default IRQ 0 was mapped to 0x8 index in the IDT by IBM because page fault etc interrupts didn't exist at that time because the 8086 intel chips could only run real mode
    mov al, 00010001b   ; 00010001b will
    out 0x20, al    ; 0x20 is the command port of master PIC

    ; this operation would initialise the master PIC (ICW1)

    mov al, 0x20    ; 0x20 is the interrupt vector offset
    out 0x21, al    ; 0x21 is the master PIC's data port

    mov al, 00000001b   ; send ICW4 to the master PIC, to operate in 8086 mode
    out 0x21, al
    ; end remap of master PIC


    call kernel_main

    jmp $

problem:
    mov eax, 0
    div eax
times 512-($ - $$) db 0