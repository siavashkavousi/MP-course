; multi-segment executable file template.

data segment
    size equ 5
    numbers dw 10, 3, 12, 13, 14 
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
              
    mov ax, offset numbers 
	mov bx, size
	push ax      
	push bx
	call bubble_sort     
	add esp, 4 ; 2 parameters * 2 bytes each
	
	; caller convention (restore)	                      
	pop dx
	pop cx
	pop bx               
	
	jmp end
    
	bubble_sort proc
		; standard subroutine prologue
		push bp
		mov bp, sp
		push di
		push si
		
		; subroutine body
		mov si, [bp + 6]
		mov di, [bp + 4]
		
repeat:              
        ; swapped flag initialize to zero
        mov bx, 0          
        
inner_loop:
        mov ax, [si]
        inc si      
        inc si
        mov dx, [si]      
        
        dec di          
        cmp di, 0
        jz end_of_loop
        
        cmp ax, dx        
        jb inner_loop
        
        mov bx, 1    
        ; swap
	    mov [si], ax
		dec si
		dec si
		mov [si], dx
		
		inc si
		inc si         
		
end_of_loop:		
		cmp bx, 0
		jnz repeat
		
		; standard subroutine epilogue
		pop si    
		pop di
		mov sp, bp
		pop bp
		ret
	bubble_sort endp
	
	
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
