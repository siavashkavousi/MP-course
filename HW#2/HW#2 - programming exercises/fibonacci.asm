; multi-segment executable file template.

data segment
    n equ 4
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
	
	; caller convention (save)	            
    push bx
    push cx
    push dx
              
	mov ax, n
	push ax
	call fib     
	add esp, 2 ; 1 parameters * 2 bytes each
	
	; caller convention (restore)	                      
	pop dx
	pop cx
	pop bx               
	
	jmp end
    
	fib proc
		; standard subroutine prologue
		push bp
		mov bp, sp
		push si
		
		; subroutine body
		mov si, [bp + 4]
		             
        dec si		             
		mov ax, 0
		mov bx, 1
    repeat:	    
	    add ax, bx
	    mov dx, ax
	    mov ax, bx
	    mov bx, dx
	    dec si    
	    cmp si, 0
	    jnz repeat
	    
	    mov ax, bx
		
		; standard subroutine epilogue
		pop si    
		pop di
		mov sp, bp
		pop bp
		ret
	fib endp
	
	
end:            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
