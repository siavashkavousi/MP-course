/*
 * Q2_3_KeyFind.asm
 *
 *  Created: 3/28/2016 11:26:45 PM
 *   Author: siavash
 */ 

.def A = r16
.def B = r17
.def ROW_HOLDER = r18
.def COL_HOLDER = r19
.def NUM_HOLDER = r20

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

	call column_set
	call pullup_pd2

	ldi A, (1 << INT0)
	out GICR, A
	ldi A, 0xFF
	out DDRA, A
	ldi A, 0x00
	out PORTA, A

	sei
	jmp start

interrupt0_isr:
	cli
	call column_finder

	call row_set
	nop
	nop
	nop
	nop
	call row_finder

	or ROW_HOLDER, COL_HOLDER
	mov NUM_HOLDER, ROW_HOLDER
	call key_finder

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

key_finder:
zero:
	cpi NUM_HOLDER, 0x11
	brne one
	ldi A, 0x40
	out PORTA, A
	rjmp key_finder_end
one:
	cpi NUM_HOLDER, 0x12
	brne two
	ldi A, 0x79
	out PORTA, A
	rjmp key_finder_end
two:
	cpi NUM_HOLDER, 0x14
	brne three
	ldi A, 0x24
	out PORTA, A
	rjmp key_finder_end
three:
	cpi NUM_HOLDER, 0x18
	brne four
	ldi A, 0x30
	out PORTA, A
	rjmp key_finder_end
four:
	cpi NUM_HOLDER, 0x21
	brne five
	ldi A, 0x19
	out PORTA, A
	rjmp key_finder_end
five:
	cpi NUM_HOLDER, 0x22
	brne six
	ldi A, 0x12
	out PORTA, A
	rjmp key_finder_end
six:
	cpi NUM_HOLDER, 0x24
	brne seven
	ldi A, 0x2
	out PORTA, A
	rjmp key_finder_end
seven:
	cpi NUM_HOLDER, 0x28
	brne eight
	ldi A, 0x78
	out PORTA, A
	rjmp key_finder_end
eight:
	cpi NUM_HOLDER, 0x41
	brne nine
	ldi A, 0x00
	out PORTA, A
	rjmp key_finder_end
nine:
	cpi NUM_HOLDER, 0x42
	brne AA
	ldi A, 0x18
	out PORTA, A
	rjmp key_finder_end
AA:
	cpi NUM_HOLDER, 0x44
	brne BB
	ldi A, 0x8
	out PORTA, A
	rjmp key_finder_end
BB:
	cpi NUM_HOLDER, 0x48
	brne CC
	ldi A, 0x00
	out PORTA, A
	rjmp key_finder_end
CC:
	cpi NUM_HOLDER, 0x81
	brne DD
	ldi A, 0x46
	out PORTA, A
	rjmp key_finder_end
DD:
	cpi NUM_HOLDER, 0x82
	brne EE
	ldi A, 0x40
	out PORTA, A
	rjmp key_finder_end
EE:
	cpi NUM_HOLDER, 0x84
	brne FF
	ldi A, 0x6
	out PORTA, A
	rjmp key_finder_end
FF:
	ldi A, 0xE
	out PORTA, A
key_finder_end:
	call column_set
	call pullup_pd2
	ret