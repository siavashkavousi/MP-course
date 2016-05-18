/*
 * q1.asm
 *
 *  Created: 5/6/2016 12:44:13 AM
 *   Author: siavash
 */ 

.def temp = r16
.def argument= r17
.def return	= r18
.def local_var = r19

 .org 0x00
 reset:
	jmp reset_isr

reset_isr:
	cli
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r17, HIGH(RAMEND)
	out SPH, r17

	// Sets buad-rate to 9600 for 1 MHz frequency
	ldi temp, 0x06
	out UBRRL, temp
	// Enables receiver and transmitter
	in temp, UCSRB
	ori temp, (1 << TXEN) | (1 << RXEN)
	out UCSRB, temp
	// Sets 8 bit data format (NOTE: UCRSEL must be one when writing to UCSRC
	in temp, UCSRC
	ori temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1)
	out UCSRC, temp
	// Sets odd parity and 2-bit stop bit
	ldi temp, (1 << UPM0) | (1 << UPM1) | (1 << USBS)
	out UCSRC, temp

	// Test
	ldi argument, '0'
	rcall uart_transmit

	sei
	jmp start

start:
	rjmp start

uart_transmit:
	sbic UCSRA, UDRE
	out UDR, argument
	ret

uart_receive:
	sbic UCSRA, RXC
	in return, UDR
	ret