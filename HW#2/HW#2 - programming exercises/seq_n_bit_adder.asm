; multi-segment executable file template.

data segment
    n dw 12 
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov ax, n
    
repeat:
    mov bx, ax
    dec bx
    add cx, ax, bx
    dec ax
    jnz repeat
                    
    mov ax, cx
              
    lea dx, pkey
    mov ah, 9h
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1h
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
