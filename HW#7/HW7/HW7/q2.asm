/*
 * q2.asm
 *
 *  Created: 4/28/2016 1:21:59 PM
 *   Author: siavash
 */ 

.def temp = r16
.def argument = r17
.def return = r18
.def global_var = r19

.org 0x00
reset:
	jmp reset_isr

.org 0x1C
adc_conversion_complete:
	jmp adc_conversion_complete_isr

reset_isr:
	cli
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	sbi ADMUX, REFS0

	in temp, ADCSRA
	ori temp, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0) | (1 << ADATE) | (1 << ADSC) | (1 << ADIE)
	out ADCSRA, temp

	ldi temp, (0 << ADTS2) | (0 << ADTS1) | (0 << ADTS0)
	out SFIOR, temp

	sei
	jmp start

adc_conversion_complete_isr:
	cli

	in temp, ADCL
	in temp, ADCH

	sei
	reti

start:
	rjmp start

