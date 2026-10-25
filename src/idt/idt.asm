section .asm

global idt_load     ; since c cannot call this special instruction lidt, this routine will
idt_load:
    push ebp
    mov ebp, esp
    mov ebx, [ebp+8]
    lidt [ebx]
    pop ebp
    ret