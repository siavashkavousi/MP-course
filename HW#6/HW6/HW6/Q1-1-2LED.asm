/*
 * Q1_1_2LED.asm
 *
 *  Created: 4/14/2016 2:32:38 PM
 *   Author: siavash
 */ 
 
.def temp = r16
.def argument = r17
.def return = r18
.def global_var = r19
.def local_var = r20

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

	ldi temp, (1 << PC5) | (1 << PC6)
	out DDRC, temp

	in temp, TIMSK
	ori temp, (1 << TOIE0)
	out TIMSK, temp

	in temp, TCCR0
	ori temp, (1 << CS02) | (0 << CS01) | (1 << CS00)
	out TCCR0, temp

	ldi global_var, 0x00

	sei
	jmp start

timer0_ovf_isr:
	cli

	inc global_var
	cpi global_var, 0x04
	brne timer0_ovf_isr_end
	
	call wink_led
	ldi global_var, 0x00

timer0_ovf_isr_end:
	sei
	reti

wink_led:
	in temp, PORTC
	mov local_var, temp
	andi temp, 0x60
	// if PC5 and PC6 are zero, set them
	cpi temp, 0x00
	breq wink_led_set_pc56
	// else clear them
	cpi temp, 0x60
	breq wink_led_clear_pc56
wink_led_set_pc56:
	ori local_var, 0x60
	out PORTC, local_var
	rjmp wink_led_end
wink_led_clear_pc56:
	andi local_var, 0x9F
	out PORTC, local_var
wink_led_end:
	ret

start:
	rjmp start
