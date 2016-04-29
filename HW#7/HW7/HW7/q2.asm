/*
 * q2.asm
 *
 *  Created: 4/28/2016 1:21:59 PM
 *   Author: siavash
 */ 

.include "m8_lcd_4bit.inc"

.def number = r20

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

	in temp, ADMUX
	ori temp, (1 <<REFS1) | (1 << REFS0)
	out ADMUX, temp

	in temp, ADCSRA
	ori temp, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0) | (1 << ADSC) | (1 << ADIE) | (1 << ADATE)
	out ADCSRA, temp

	ldi temp, (0 << ADTS2) | (0 << ADTS1) | (0 << ADTS0)
	out SFIOR, temp

	rcall LCD_init

	sei
	jmp start

adc_conversion_complete_isr:
	cli

	in temp, ADCL
	mov zl, temp
	in temp, ADCH
	mov zh, temp
	// divide z by two
	rcall divide_by_4

	// clear display, cursor -> home
	rcall	LCD_wait
	ldi	argument, 0x01
	rcall	LCD_command
	// print on lcd
	mov argument, zl
	rcall convert_hex2ascii_display

	// mast mali :D
	sbi ADCSRA, ADSC

	sei
	reti

divide_by_4:
	asr zh
	ror zl
	asr zh
	ror zl
	ret

start:
	rjmp start

convert_hex2ascii_display:
	mov number, argument
	clr local_var
third_digit:
	subi number, 100
	brlo next_step0
	inc local_var
	rjmp third_digit
next_step0:
	ldi temp, 48
	add local_var, temp
	mov argument, local_var
	rcall display
	ldi temp, 100
	add number, temp
	clr local_var
two_digit:
	subi number, 10
	brlo next_step1
	inc local_var
	rjmp two_digit
next_step1:
	ldi temp, 48
	add local_var, temp
	mov argument, local_var
	rcall display
	ldi temp, 10
	add number, temp
	clr local_var
one_digit:
	ldi temp, 48
	add number, temp
	mov argument, number
	rcall display
	ret

display:
	rcall LCD_wait
	rcall LCD_putchar
	ret