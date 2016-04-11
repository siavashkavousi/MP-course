;
; Q2.asm
;
; Created: 3/28/2016 3:02:18 PM
; Author : siavash
;


watchdog_rst:
	cli
	; reset wdt
	wdr
	; turn on wdt and set it to 2.1s timeout
	in r16, WDTCR
	ori r16, (0<<WDTOE) | (1<<WDE) | (1<<WDP0) | (1<<WDP1) | (1<<WDP2)
	out WDTCR, r16
	sei
	jmp start

start:
	rjmp start
