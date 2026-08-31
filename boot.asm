ORG 0      ; Tell the assembler to assume this code starts at offset 0.-
BITS 16         ; tells assembler how many bits the instructions should be assembled into
jmp 0x7C0:start

_start:
    jmp short start
    nop
times 33 db 0
start:
    jmp 0x7C0:step2
step2:
    cli        ; clear interrupts
    mov ax, 0x7c0
    mov ds, ax      ; setting segment registers
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti        ; enable interrupts (from keyboard, etc that BIOS initialised)
    mov ah, 2    ; READ SECTOR COMMAND
    mov al, 1    ; ONE SECTOR TO BE READ
    mov ch, 0    ; cylinder = 0
    mov cl, 2    ; read sector 2
    mov dh, 0    ; head number
    mov bx, buffer
    int 0x13
    jc error
    mov si, buffer
    call print
    jmp $

error:
    mov si, error_message
    call print
    jmp $

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

error_message:
    db "Disk read error!", 0

times 510-($-$$) db 0      ; fills rest of the memory with 0 for 510 bytes
dw 0xAA55         ; saves 0x55aa at the end because BIOS looks for boot signature (reverse because our machine is little endian)

buffer: