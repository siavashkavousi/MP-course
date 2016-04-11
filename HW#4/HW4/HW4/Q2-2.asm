/*
 * Q2_2.asm
 *
 *  Created: 3/28/2016 3:40:24 PM
 *   Author: siavash
 */ 

.def A = r16
.def B = r17

.equ four = 0x04

.org 0x00
reset:
	jmp reset_isr

reset_isr:
	cli
	// change DDRB0 direction to output
	ldi A, (1 << PB0)
	out DDRB, A
	// pull-up PORTD2 and PORTA2
	ldi A, (1 << PD2)
	out PORTD, A
	ldi A, (1 << PA2)
	out PORTA, A
	// reset wdt
	wdr
	// turn on wdt and set it to 2.1s timeout
	in A, WDTCR
	ori A, (0 << WDTOE) | (1 << WDE) | (1 << WDP0) | (1 << WDP1) | (1 << WDP2)
	out WDTCR, A
	// turn off led
	call led_off
	sei
	jmp start

start:
	in A, PIND
	cpi A, four
	brne start_led_on
	rjmp start
start_led_on:
	ldi A, (1 << PB0)
	out PORTB, A
check_push_sw2:
	in A, PINA
	cpi A, four
	brne reset_wdt
	rjmp check_push_sw2
reset_wdt:
	wdr
	rjmp check_push_sw2

led_off:
	in A, (0 << PB0)
	out PORTB, A
	ret