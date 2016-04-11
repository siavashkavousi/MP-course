/*
 * Q1_3.inc
 *
 *  Created: 4/8/2016 1:13:50 PM
 *   Author: siavash
 */ 

.include "m8_lcd_4bit.inc"

.def A = r20
.def B = r21
.def ROW_HOLDER = r22
.def COL_HOLDER = r23
.def NUM_HOLDER = r24

.org 0x00
reset:
	jmp reset_isr

.org 0x02
interrupt0:
	jmp interrupt0_isr

reset_isr:
	cli
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	rcall column_set
	rcall pullup_pd2

	ldi A, (1 << INT0)
	out GICR, A

	rcall LCD_init

	sei
	jmp start

interrupt0_isr:
	cli
	rcall column_finder

	rcall row_set
	nop
	nop
	nop
	nop
	rcall row_finder

	or ROW_HOLDER, COL_HOLDER
	mov NUM_HOLDER, ROW_HOLDER
	rcall print_key

	sei
	reti

start:
	rjmp start

pullup_pd2:
	ldi A, (1 << PD2)
	out PORTD, A
	ret

column_set:
	ldi A, (1 << PC4) | (1 << PC5) | (1 << PC6) | (1 << PC7)
	out DDRC, A
	ldi A, (1 << PC0) | (1 << PC1) | (1 << PC2) | (1 << PC3)
	out PORTC, A
	ret

column_finder:
	in COL_HOLDER, PINC
	com COL_HOLDER
	andi COL_HOLDER, 0x0F
	ret

row_set:
	ldi A, (1 << PC0) | (1 << PC1) | (1 << PC2) | (1 << PC3)
	out DDRC, A
	ldi A, (1 << PC4) | (1 << PC5) | (1 << PC6) | (1 << PC7)
	out PORTC, A
	ret

row_finder:
	in ROW_HOLDER, PINC
	com ROW_HOLDER
	andi ROW_HOLDER, 0xF0
	ret

print_key:
	rcall	LCD_delay
zero:
	cpi NUM_HOLDER, 0x11
	brne one
	ldi argument, '0'
	rjmp key_finder_end
one:
	cpi NUM_HOLDER, 0x12
	brne two
	ldi argument, '1'
	rjmp key_finder_end
two:
	cpi NUM_HOLDER, 0x14
	brne three
	ldi argument, '2'
	rjmp key_finder_end
three:
	cpi NUM_HOLDER, 0x18
	brne four
	ldi argument, '3'
	rjmp key_finder_end
four:
	cpi NUM_HOLDER, 0x21
	brne five
	ldi argument, '4'
	rjmp key_finder_end
five:
	cpi NUM_HOLDER, 0x22
	brne six
	ldi argument, '5'
	rjmp key_finder_end
six:
	cpi NUM_HOLDER, 0x24
	brne seven
	ldi argument, '6'
	rjmp key_finder_end
seven:
	cpi NUM_HOLDER, 0x28
	brne eight
	ldi argument, '7'
	rjmp key_finder_end
eight:
	cpi NUM_HOLDER, 0x41
	brne nine
	ldi argument, '8'
	rjmp key_finder_end
nine:
	cpi NUM_HOLDER, 0x42
	brne AA
	ldi argument, '9'
	rjmp key_finder_end
AA:
	cpi NUM_HOLDER, 0x44
	brne BB
	ldi argument, 'A'
	rjmp key_finder_end
BB:
	cpi NUM_HOLDER, 0x48
	brne CC
	ldi argument, 'B'
	rjmp key_finder_end
CC:
	cpi NUM_HOLDER, 0x81
	brne DD
	ldi argument, 'C'
	rjmp key_finder_end
DD:
	cpi NUM_HOLDER, 0x82
	brne EE
	ldi argument, 'D'
	rjmp key_finder_end
EE:
	cpi NUM_HOLDER, 0x84
	brne FF
	ldi argument, 'E'
	rjmp key_finder_end
FF:
	ldi argument, 'F'	
key_finder_end:
	rcall LCD_putchar
	rcall column_set
	rcall pullup_pd2
	ret