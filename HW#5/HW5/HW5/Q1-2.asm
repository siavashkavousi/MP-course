/*
 * Q1_2.asm
 *
 *  Created: 4/8/2016 12:04:42 PM
 *   Author: siavash
 */ 

.include "m8_lcd_4bit.inc"

.org 0x00
reset:
	jmp reset_isr

reset_isr:
	cli

	ldi	temp, low(RAMEND)
	out	SPL, temp
	ldi	temp, high(RAMEND)
	out	SPH, temp

	rcall LCD_init

	rcall load_print_chars

	sei
	jmp start

start:
	rjmp start

load_memory_address:
	ldi zh, high(2 * lcd_table)
	ldi zl, low(2 * lcd_table)
	ret

load_print_chars:
	rcall load_memory_address

	lpm temp, z
	mov local_var, temp
	adiw z, 2
load_print_chars_repeat:
	lpm temp, z
	rcall	LCD_delay
	mov	argument, temp
	rcall	LCD_putchar
	adiw z, 2
	dec local_var
	cpi local_var, 0x00
	brne load_print_chars_repeat
	ret

lcd_table:
	.dw 6, 'A', 'B', 'C', 'D', 'E', 'F'