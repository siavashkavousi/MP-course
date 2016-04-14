;
; HW6.asm
;
; Created: 4/14/2016 3:43:53 AM
; Author : siavash
;

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

	in temp, TCCR0
	ori temp, (1 << CS02) | (0 << CS01) | (1 << CS00)
	out TCCR0, temp

	ldi global_var, 0x00

	sei
	jmp start

timer0_ovf_isr:
	cli

	inc global_var
	cpi globar_var, 0x04
	breq wink_led

	sei
	reti

wink_led:
	rjmp wink_led

start:
	rjmp start
