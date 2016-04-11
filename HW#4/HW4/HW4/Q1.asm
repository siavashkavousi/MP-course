;
; Q2.asm
;
; Created: 3/28/2016 3:02:18 PM
; Author : siavash
;


watchdog_rst:
	cli

	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	sei
	jmp start

start:
	rjmp start
