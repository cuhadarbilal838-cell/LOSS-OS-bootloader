[org 0x7c00]
[bits 16]

start:
    ; EKRAN TEMİZLEME (screen cleaning)
    mov ah, 06h
    mov al, 0
    mov bh, 1Ah
    mov cx, 0
    mov dx, 184Fh
    int 0x10

    ; SI'yi mesajin adresine ayarla  (Set SI to the message address.)
    mov si, mesaj
    call print_string

    jmp $              ; sonsuz dongu (kernel hazir olana kadar)  infinite loop (until the kernel is ready)


;YAZI YAZDIRMAK İÇİN GEREKEN KODLAR (CODES REQUIRED TO PRINT TEXT)
print_string:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

mesaj db 'STARTING LOSS OS >_', 0

times 510-($-$$) db 0
dw 0xAA55
