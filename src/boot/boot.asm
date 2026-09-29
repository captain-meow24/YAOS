ORG 0      ; Tell the assembler to assume this code starts at offset 0, this will be used to calculate addresses for labels (size of the label as offset)
BITS 16         ; tells assembler how many bits the instructions should be assembled into

;  Global descriptor table stores the address of code and data segments, separate segments for each process help in memory protection from malicious processes by keeping each one's memory separate
;  The hardware mandates atleast one segment, I am not implementing more because I will implement paging

CODE_SEG equ gdt_code - gdt_start    ; assembler constants that store offset to code and data segments, code segments are executable, data segments are meant to be read or written to
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop
times 33 db 0
start:
    jmp 0:step2
step2:
    cli        ; clear interrupts
    mov ax, 0x00
    mov ds, ax      ; setting segment registers
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti        ; enable interrupts (from keyboard, etc that BIOS initialised)

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

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

; GDT
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

print_char:
    mov ah, 0eh       ; the BIOS routine int 0x10 checks ah to see which video function is to be used, 0x0E means to print character
    int 0x10
    ret

; offset 0x8

gdt_code:     ; CS SHOULD POINT TO THIS
    dw 0xffff          ; Segment limit first 0-15 bits
    dw 0               ; Base first 0-15 bits
    db 0               ; Base 16-23 bits
    db 0x9a             ; Access byte
    db 11001111b       ; High 4 bit flags and the low 4 bit flags
    db 0               ; Base 24-31 bits

; offset 0x10

gdt_data:     ; DS, SS, ES, FS, GS
    dw 0xffff          ; Segment limit first 0-15 bits
    dw 0               ; Base first 0-15 bits
    db 0               ; Base 16-23 bits
    db 0x92             ; Access byte
    db 11001111b       ; High 4 bit flags and the low 4 bit flags
    db 0               ; Base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
load32:
    mov eax, 1
    mov ecx, 100
    mov edi, 0x100000
    call ata_lba_read

ata_lba_read:
    mov ebx, eax,   ; Backup the LBA
    ; Send the higest 8 bits of the LBA to disk controller
    shr eax, 24
    or eax, 0xE0
    mov dx, 0x1F6
    out dx, al
    ; Finished sending the highest 8 bits of the LBA

    ; Send the total sectors to read
    mov eax, ebx   ; Restore the backup LBA
    mov dx, 0x1f3
    out dx, al
    shr eax, 16
    out dx, al
    ; Finished sending upper 16 bits of the LBA

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; Read all sectors into memory
.next_sector:
    push ecx

; Checking if we need to read
.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

; We need to read 256 words at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw
    pop ecx
    loop .next_sector


times 510-($-$$) db 0      ; fills rest of the memory with 0 for 510 bytes
dw 0xAA55         ; saves 0x55aa at the end because BIOS looks for boot signature (reverse because our machine is little endian)
