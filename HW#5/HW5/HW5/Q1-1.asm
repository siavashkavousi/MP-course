/*
 * Q1_1.asm
 *
 *  Created: 4/3/2016 4:26:44 PM
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

	rcall print_hello_world

	sei
	jmp start

start:
	rjmp start

print_hello_world:
	rcall	LCD_init
	
	rcall	LCD_delay
	ldi	argument, 'H'
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'E'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'L'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'L'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'O'	
	rcall	LCD_putchar
	
	rcall	LCD_delay
	ldi	argument, ' '	
	rcall	LCD_putchar

	rcall	LCD_delay
	ldi	argument, 'W'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'O'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'R'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'L'	
	rcall	LCD_putchar
	rcall	LCD_delay
	ldi	argument, 'D'	
	rcall	LCD_putchar
	ret