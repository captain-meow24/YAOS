section .asm

global insb
global insw
global outb
global outw

insb:           ; input byte function
    push ebp        ; saving the value in ebp
    mov ebp, esp        ; copying the top of the stack into ebp

    xor eax, eax        ;  Zero out EAX (EAX = 0x00000000)
    mov edx, [ebp+8]    ;  fetching first parameter of the c function (it pushed port number onto the stack)
    in al, dx           ;  in is the core x86 assembly instruction for reading data from an I/O port into the CPU, al here, which is the lowest byte of eax, dx is the lower 16 bits of edx

    pop ebp
    ret                 ; Return to C (eax is used as the default return value in 32 bit systems)

insw:           ; input word fnctio
    push ebp
    mov ebp, esp

    xor eax, eax
    mov edx, [ebp+8]
    in ax, dx           ;  ax is the lowest 16 bits of eax

    pop ebp
    ret

outb:           ; output byte function
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]
    mov edx, [ebp+8]
    out dx, al

    pop ebp
    ret

outw:           ; output word function
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]
    mov edx, [ebp+8]
    out dx, ax

    pop ebp
    ret
