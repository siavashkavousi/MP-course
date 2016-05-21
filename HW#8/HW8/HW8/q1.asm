/*
 * q1.asm
 *
 *  Created: 20/6/2016 12:44:13 AM
 *   Author: siavash
 */ 

.def temp = r16
.def argument= r17
.def return	= r18
.def local_var = r19
.def ROW_HOLDER = r20
.def COL_HOLDER = r21
.def NUM_HOLDER = r22

 .org 0x00
 reset:
	jmp reset_isr

.org 0x02
interrupt0:
	jmp interrupt0_isr

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

	call column_set
	call pullup_pd2

	ldi temp, (1 << INT0)
	out GICR, temp
	ldi temp, 0xFF
	out DDRA, temp
	ldi temp, 0x00
	out PORTA, temp

	sei
	jmp start

interrupt0_isr:
	cli
	call column_finder

	call row_set
	nop
	nop
	nop
	nop
	call row_finder

	or ROW_HOLDER, COL_HOLDER
	mov NUM_HOLDER, ROW_HOLDER
	call key_finder

	sei
	reti

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

pullup_pd2:
	ldi temp, (1 << PD2)
	out PORTD, temp
	ret

column_set:
	ldi temp, (1 << PC4) | (1 << PC5) | (1 << PC6) | (1 << PC7)
	out DDRC, temp
	ldi temp, (1 << PC0) | (1 << PC1) | (1 << PC2) | (1 << PC3)
	out PORTC, temp
	ret

column_finder:
	in COL_HOLDER, PINC
	com COL_HOLDER
	andi COL_HOLDER, 0x0F
	ret

row_set:
	ldi temp, (1 << PC0) | (1 << PC1) | (1 << PC2) | (1 << PC3)
	out DDRC, temp
	ldi temp, (1 << PC4) | (1 << PC5) | (1 << PC6) | (1 << PC7)
	out PORTC, temp
	ret

row_finder:
	in ROW_HOLDER, PINC
	com ROW_HOLDER
	andi ROW_HOLDER, 0xF0
	ret

key_finder:
zero:
	cpi NUM_HOLDER, 0x11
	brne one
	ldi argument, 'p'
	rjmp key_finder_end
one:
	cpi NUM_HOLDER, 0x12
	brne two
	ldi argument, '1'
	rjmp key_finder_end
two:
	cpi NUM_HOLDER, 0x14
	//brne three
	ldi temp, 0x24
	out PORTA, temp
	rjmp key_finder_end
key_finder_end:
	call uart_transmit
	call column_set
	call pullup_pd2
	ret