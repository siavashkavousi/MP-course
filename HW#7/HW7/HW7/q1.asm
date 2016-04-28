;
; HW7.asm
;
; Created: 4/28/2016 3:26:12 AM
; Author : siavash
;

.def temp = r16
.def argument = r17
.def return = r18
.def global_var = r19

.org 0x00
reset:
	jmp reset_isr

reset_isr:
	cli
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	sbi DDRD, PD5

	sei
	jmp start

start:
	sbis ACSR, ACO
	sbi PORTD, PD5
	sbic ACSR, ACO
	cbi PORTD, PD5
	rjmp start

