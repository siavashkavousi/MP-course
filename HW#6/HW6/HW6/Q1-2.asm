/*
 * Q1_2.asm
 *
 *  Created: 4/14/2016 2:48:54 PM
 *   Author: siavash
 */ 

.def temp = r16
.def argument = r17
.def return = r18
.def global_var = r19

.org 0x00
reset:
	jmp reset_isr

.org 0x12
timer0_ovf:
	jmp timer0_ovf_isr

reset_isr:
	cli
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	ldi temp, (1 << PB3)
	out DDRB, temp

	in temp, TIMSK
	ori temp, (1 << TOIE0)
	out TIMSK, temp

	in temp, TCCR0
	ori temp, (1 << CS02) | (0 << CS01) | (1 << CS00) | (1 << WGM01) | (0 << WGM00) | (0 << COM01) | (1 << COM00)
	out TCCR0, temp

	ldi temp, 0xFF
	out OCR0, temp

	sei
	jmp start

timer0_ovf_isr:
	cli
	call wink_led
	sei
	reti

wink_led:
	sbis PORTB, PB3
	rjmp wink_led_set_pb3
	sbic PORTB, PB3
	rjmp wink_led_clear_pb3
wink_led_set_pb3:
	sbi PORTB, PB3
	rjmp wink_led_end
wink_led_clear_pb3:
	cbi PORTB, PB3
wink_led_end:
	ret

start:
	rjmp start
