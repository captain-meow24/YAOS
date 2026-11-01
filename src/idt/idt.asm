section .asm

extern int21h_handler
global int21h

extern no_interrupt_handler
global no_interrupt

global idt_load     ; since c cannot call this special instruction lidt, this routine will
idt_load:
    push ebp
    mov ebp, esp
    mov ebx, [ebp+8]     ; When a C function calls an assembly function with arguments (for example, my_func(arg1, arg2)), the CPU builds the stack frame in a specific order:
    lidt [ebx]
    pop ebp
    ret

int21h:
    cli                 ; Disable interrupts during frame save
    pushad              ; Push general purpose registers (EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI)
    call int21h_handler  ; Call C handler function
    popad               ; Restore registers
    sti                 ; Re-enable interrupts
    iret                ; Return from interrupt (pops EIP, CS, EFLAGS)

no_interrupt:
    cli
    pushad
    call no_interrupt_handler
    popad
    sti
    iret