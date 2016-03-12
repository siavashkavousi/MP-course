/*
 * WinkerLED.asm
 *
 *  Created: 3/11/2016 11:07:55 PM
 *   Author: siavash
 */ 

.org 0x00
reset:
	jmp reset_isr

reset_isr:
	cli
	// change DDRB0 direction to output
	ldi r16, (1 << PB0)
	out DDRB, r16
	// pull-up PORTD6
	ldi r16, (1 << PD6)
	out PORTD, r16
	sei
	jmp start

start:
	in r16, PIND
	cpi r16, 0x40
	brne start_push
	rjmp start
start_push:
	ldi r17, 0x0A
start_push_loop:
	ldi r16, (1 << PB0)
	out PORTB, r16
	call delay
	ldi r16, (0 << PB0)
	out PORTB, r16
	call delay
	dec r17
	cpi r17, 0x00
	brne start_push_loop
	rjmp start

delay:
	ldi r18, 0xFF
delay_loop1:
	ldi r19, 0xFF
delay_loop2:
	nop
	nop
	nop
	dec r19
	brne delay_loop2
	nop
	nop
	nop
	dec r18
	brne delay_loop1
	ret