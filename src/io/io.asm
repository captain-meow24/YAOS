section .asm

global insb

insb:
    push ebp        ; saving the value in ebp
    mov ebp, esp        ; copying the top of the stack into ebp

    xor eax, eax        ;  Zero out EAX (EAX = 0x00000000)
    mov edx, [ebp+8]    ;  fetching first parameter of the c function (it pushed port number onto the stack)
    in al, dx           ;  in is the core x86 assembly instruction for reading data from an I/O port into the CPU, AL here, which is the last byte of eax

    pop ebp
    ret                 ; 4. Return to C (eax is default return valur in 32 bit systems)