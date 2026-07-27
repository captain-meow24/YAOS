ORG 0      ; Tell the assembler to assume this code starts at offset 0.-
BITS 16         ; tells assembler how many bits the instructions should be assembled into
jmp 0x7C0:start

_start:
    jmp short start
    nop
times 33 db 0
start:
    jmp 0x7C0:step2
handle_one:
    mov ah, 0eh
    mov al, "A"
    mov bx, 0x00
    int 0x10
    iret        ; return from interrupt
step2:
    cli        ; clear interrupts
    mov ax, 0x7c0
    mov ds, ax      ; setting segment registers
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0
    sti        ; enable interrupts (from keyboard, etc that BIOS initialised)
    int 1
    mov si, message    ; moves the address of message into SI which is a pointer register
    call print        ; calls print()
    jmp $             ; jumps to current address 

print:                ; print is a global label, can be called from anywhere
    mov bx, 0         ; bx is used by int 0x10 for settings, 0 = default, 
.loop:                ; .loop is a local label, can only be called by the global label above it
    lodsb            ; lodsb is used to take the char stored inside si and save it into al (al = *si) and then increments si
    cmp al, 0         ; compares if al = 0 (string ends with 0)
    je .done          ; calls done if al is 0
    call print_char   ; calls print_char if not
    jmp .loop         ; jumps back to loop

.done:
    ret

print_char:
    mov ah, 0eh       ; the BIOS routine int 0x10 checks ah to see which video function is to be used, 0x0E means to print character
    int 0x10
    ret

message: db 'HELLO WORLLLD', 0     
times 510-($-$$) db 0      ; fills rest of the memory with 0 for 510 bytes
dw 0xAA55         ; saves 0x55aa at the end because BIOS looks for boot signature (reverse because our machine is little endian)