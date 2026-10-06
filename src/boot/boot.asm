ORG 0x7C00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

start:
    jmp short boot
    nop
    times 33 db 0                 ; Keep the BPB-sized area used by this project.

boot:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:protected_mode

gdt_start:
    dq 0
gdt_code:
    dq 0x00CF9A000000FFFF
gdt_data:
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

BITS 32
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    ; Enable A20 before accessing memory at or above 1 MiB.
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Read 100 sectors beginning at LBA 1 to physical address 1 MiB.
    mov eax, 1
    mov ecx, 100
    mov edi, 0x00100000
    call ata_lba_read

    jmp 0x00100000

; EAX = starting LBA, ECX = sector count, EDI = destination address.
ata_lba_read:
    push ebx
    push esi
    mov ebx, eax
    mov esi, ecx

    ; Select the primary master and provide the high LBA nibble.
    mov dx, 0x1F6
    mov eax, ebx
    shr eax, 24
    and al, 0x0F
    or al, 0xE0
    out dx, al

    ; ATA sector count (8-bit count; this loader reads at most 255 sectors).
    mov dx, 0x1F2
    mov eax, esi
    out dx, al

    ; LBA bits 0..23.
    mov eax, ebx
    mov dx, 0x1F3
    out dx, al
    mov dx, 0x1F4
    shr eax, 8
    out dx, al
    mov dx, 0x1F5
    shr eax, 8
    out dx, al

    ; READ SECTORS command.
    mov dx, 0x1F7
    mov al, 0x20
    out dx, al

.read_sector:
    ; Wait until BSY clears and DRQ is set; halt on device error.
.wait_drq:
    mov dx, 0x1F7
    in al, dx
    test al, 1
    jnz .disk_error
    test al, 0x80
    jnz .wait_drq
    test al, 8
    jz .wait_drq

    mov dx, 0x1F0
    mov ecx, 256
    rep insw
    dec esi
    jnz .read_sector

    pop esi
    pop ebx
    ret

.disk_error:
    cli
.halt:
    hlt
    jmp .halt

times 510-($-$$) db 0
dw 0xAA55
