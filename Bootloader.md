#LOSS OS > Bootlaoder
LOSS-OS, tamamen Assembly dili ile sıfırdan geliştirilen, 16-bit mimariye sahip bir işletim sistemi projesidir. Şu an görmüş olduğunuz bu kısım, projenin temelini oluşturan bootloader aşamasıdır. Gelecekte, işletim sistemi içinde kendi kod editörüne sahip olmayı hedefliyoruz. Bu editör sayesinde, sistem üzerinden doğrudan farklı programlama dillerinde yazılım geliştirilebilecektir.

LOSS-OS is a 16-bit operating system project developed entirely from scratch using pure Assembly language. This repository contains the foundational bootloader phase of the project. My long-term goal is to integrate a native code editor directly into the OS, allowing users to write and develop software in various programming languages within the environment itself.

DERLEME VE ÇALIŞTIRMAK İÇİN (builds run)

nasm -f bin boot.asm -o boot.bin

  KODLARIN PARÇA PARÇA ANLAMI(the meaning of the code segments)

  [org 0x7c00]: Programın hafızadaki başlangıç adresini belirler (Sets the memory origin address).

[bits 16]: İşlemcinin 16-bit modunda çalışacağını belirtir (Defines the processor mode).

start:: Kodun başlangıç noktasını işaretler (Marks the start label of the code).

cli: İşlemci kesmelerini devre dışı bırakır (Clears interrupts).

xor ax, ax: ax kaydedicisini sıfırlar (Resets/Clears the register).

mov ds, ax, mov es, ax, mov ss, ax: Segment kayıtlarını sıfırlayarak temiz bir sayfa açar (Initializes segment registers).

mov sp, 0x7c00: Yığın işaretçisini ayarlar (Sets the stack pointer).

mov ah, 0x06: Ekran temizleme fonksiyonunu seçer (Selects scroll/clear screen function).

mov al, 0: Tüm ekranı temizler (Clears the entire screen).

mov bh, 0x0A: Yazı ve arka plan rengini ayarlar (Sets background and text colors).

mov cx, 0 / dx, 184Fh: Ekranın sınırlarını belirler (Defines screen boundaries).

int 0x10: BIOS ekran hizmetlerini çağırır (Calls BIOS video services).

mov ah, 0x02: İmleç konumlandırma fonksiyonunu seçer (Selects set cursor position function).

mov dh, 10 / dl, 25: Satır ve sütun koordinatlarını belirler (Sets row and column coordinates).

mov si, STARTlOSS: Ekrana yazılacak metnin adresini yükler (Loads the address of the message).

call print_string: Yazdırma alt yordamını çağırır (Calls the printing subroutine).

mov ah, 0x86: Bekleme (gecikme) fonksiyonunu seçer (Selects wait function).

mov cx, 0x0016 / dx, 0xE360: 1.5 saniyelik süreyi ayarlar (Sets the 1.5-second delay duration).

int 0x15: BIOS zamanlayıcı hizmetini çağırır (Calls BIOS timer services).

mov ah, 0x02: Diskten okuma fonksiyonunu seçer (Selects disk read function).

mov al, 1: Okunacak sektör sayısını belirtir (Specifies sectors to read).

mov cl, 2: Okumaya başlanacak sektör numarasını belirler (Sets starting sector number).

mov dl, 0x80: Sabit diskten okumayı seçer (Selects primary hard disk).

mov bx, 0x1000: Verinin yükleneceği hafıza adresini belirler (Sets destination memory address).

int 0x13: BIOS disk hizmetlerini çağırır (Calls BIOS disk services).

jc disk_error: Eğer hata varsa, hata mesajı bölümüne atlar (Jumps if carry/error occurred).

jmp 0x0000:0x1000: Kontrolü yüklenen kernel dosyasına devreder (Transfers control to the kernel).

Yazdırma Fonksiyonu (Printing Function)
lodsb: Metinden bir karakter yükler (Loads next byte/character).

cmp al, 0: Metnin sonuna gelip gelmediğini kontrol eder (Checks for end of string).

je .done: Metin bittiyse çıkış yapar (Jumps if equal/end of string).

mov ah, 0x0E: Tele-tip (TTY) modunda karakter yazdırmayı seçer (Selects TTY mode).

int 0x10: Karakteri ekrana basar (Outputs character to screen).

jmp .loop: Bir sonraki harf için döngüyü sürdürür (Continues loop for next character).

ret: Fonksiyondan geri döner (Returns from function)
