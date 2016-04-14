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

	ldi temp, (1 << PC5)
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
	sbis PORTC, PC5
	rjmp wink_led_set_pc5
	sbic PORTC, PC5
	rjmp wink_led_clear_pc5
wink_led_set_pc5:
	sbi PORTC, PC5
	rjmp wink_led_end
wink_led_clear_pc5:
	cbi PORTC, PC5
wink_led_end:
	ret

start:
	rjmp start
