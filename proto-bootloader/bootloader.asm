org 0
bits 16                     ; real mode 16bit

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:setup

setup:
    
    cli                     ; clear interrupts
    mov ax, 0x7c0           ; origin address: bios loads program in this address
    mov ds, ax
    mov es, ax
    mov ax, 00
    mov ss, ax
    mov sp, 0x7c00
    sti                     ; enable interrupts
    call print_boot_msg
    jmp $

print_boot_msg:
    mov ah, 0x0E            ; teletype output code for BIOS interrupt
    mov si, boot_msg        ; point si to msg
.loop:
    lodsb                   ; loads si into al and increments si
	or al, al               ; check if al = 0
	jz .done                ; if equal, end of string, jump to done and ret
	int 0x10                ; else, interrupt 0x10 calls BIOS with ah=0x0E
	jmp .loop               ; loop
.done:
    ret                     ;

boot_msg: db "[bootloader] loaded", 0   ; boot up message

;; Magic numbers
times 510 - ($ - $$) db 0 ; fills memory
dw 0xAA55 ; boot flag