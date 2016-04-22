/*
 * Q2_2.asm
 *
 *  Created: 4/22/2016 4:52:41 PM
 *   Author: siavash
 */ 

.def temp = r16
.def argument = r17
.def return = r18
.def global_var = r19

.org 0x00
reset:
	jmp reset_isr

.org 0x26
	jmp timer_compare_match_isr

reset_isr:
	cli
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	in temp, TIMSK
	ori temp, (1 << OCIE0)
	out TIMSK, temp

	in temp, TCCR0
	ori temp, (1 << CS02) | (0 << CS01) | (1 << CS00) | (0 << WGM01) | (1 << WGM00) | (1 << COM01) | (1 << COM00)
	out TCCR0, temp

	ldi temp, (1 << PD6) | (1 << PD7)
	out PORTD, temp

	ldi temp, (1 << PB3)
	out DDRB, temp

	ldi temp, 0xFF
	out OCR0, temp

	sei
	jmp start

timer_compare_match_isr:
	cli
	sei
	reti

start:
	sbis PIND, PD6
	call full_rotation
	sbis PIND, PD7
	call half_rotation
	rjmp start

full_rotation:
	ldi temp, 0x7F
	out OCR0, temp
	ret

half_rotation:
	ldi temp, 0xBD
	out OCR0, temp
	ret
