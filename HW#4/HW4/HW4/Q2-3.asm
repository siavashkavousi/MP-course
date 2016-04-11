/*
 * Q2_3.asm
 *
 *  Created: 3/28/2016 4:30:36 PM
 *   Author: siavash
 */ 
 
.def A = r16
.def B = r17

.org 0x00
reset:
	jmp reset_isr

.org 0x04
interrupt1:
	jmp interrupt1_isr

reset_isr:
	cli
	// change DDRB0 direction to output
	ldi A, (1 << PB0)
	out DDRB, A
	// pull-up PORTD3
	ldi A, (1 << PD3)
	out PORTD, A
	// enable INT1 
	ldi A, (1 << INT1)
	out GICR, A
	// set INT1 request to falling edge
	ldi A, (1 << ISC11) | (0 << ISC10)
	out MCUCR, A
	sei
	jmp start

interrupt1_isr:
	cli
	// skip if bit PB0 is 1 else make it 1
	sbis PORTB, PB0
	rjmp set_pb0
	// skip if bit PB0 is 0 else make it 0
	sbic PORTB, PB0
	rjmp clear_pb0
set_pb0:
	sbi PORTB, PB0
	rjmp interrupt1_end
clear_pb0:
	cbi PORTB, PB0
	rjmp interrupt1_end
interrupt1_end:
	sei
	reti

start:
	rjmp start
	
