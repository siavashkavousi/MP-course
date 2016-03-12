/*
 * LED.asm
 *
 *  Created: 3/11/2016 9:58:15 PM
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
	// pull-up PORTD2
	ldi r16, (1 << PD2)
	out PORTD, r16
	sei
	jmp start

start:
	in r16, PIND
	cpi r16, 0x04
	breq start_led_off
start_led_on:
	ldi r16, (1 << PB0)
	out PORTB, r16
	rjmp start
start_led_off:
	ldi r16, (0 << PB0)
	out PORTB, r16
	rjmp start