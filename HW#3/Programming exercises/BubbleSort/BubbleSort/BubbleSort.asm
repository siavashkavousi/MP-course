/*
 * BubbleSort.asm
 *
 *  Created: 3/12/2016 1:14:18 AM
 *   Author: siavash
 */ 


.equ size = 10
.equ list_h = 0x00
.equ list_l = 0x60
.def A = r16
.def B = r17
.def i = r18
.def j = r19

.org 0x00
reset:
	jmp reset_isr

reset_isr:
	cli
	// nothing!
	sei
	jmp start

start:
	// load the address of list in Z register
	ldi zh, high(2 * list)
	ldi zl, low(2 * list)
	// load the address in which we want to store data in sram
	ldi xh, list_h
	ldi xl, list_l

loadbytes:
	lpm
	// check if we've reached to the end of the list
	tst r0 
	breq loadbytes_quit
	// store to sram (data memory)
	st x+, r0
	adiw zl, 2
	rjmp loadbytes
loadbytes_quit:
	rcall bubble_sort

quit:
	rjmp quit

bubble_sort:
	ldi i, size - 1
bubble_sort_outerloop:
	ldi j, size - 1
	ldi xh, list_h
	ldi xl, list_l
bubble_sort_innerloop:
	ld A, X+
	ld B, X
	cp A, B
	brlo bubble_sort_noswap
	st X, A
	st -X, B
	inc r26
bubble_sort_noswap:
	dec j
	brne bubble_sort_innerloop
	dec i
	brne bubble_sort_outerloop
	ret

list:
	.db 78
	.db 11
	.db 73
	.db 12
	.db 97
	.db 95
	.db 77
	.db 65
	.db 84
	.db 73
	.db 0
