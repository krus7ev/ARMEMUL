; ***************************************
; *** COMS12600 Bubblesort Assignment ***
; *** (C) Simon Hollis, 2011-13       ***
; *** simon@cs.bris.ac.uk             ***
; ***************************************
	
	THUMB
	
Start
       MOVI r0, #1 
       LSLI r0, r0, #12 ; load largest memory address
       MOVRSP sp, r0 ; set stack pointer to largest value
       
       BU StartSort  ; start the work


; *** The data values to be sorted
; *** DCD is an assembler directive to insert the given constant in memory
DataStart
	DCD -4
	DCD 2
	DCD 5
	DCD 910
	DCD 10
	DCD -12
	DCD 91
	DCD 11
DataEnd

StartSort
	MOVI r1, #DataStart     ; load start address for the data values
	MOVI r2, #0             ; array index being sorted
	MOVI r7, #DataEnd       ; contains the value of the last unsorted element
	MOVI r3, #0             ; unfinished = 0

	BU FetchCompare 		;

FetchCompare
	
	LDRR r4, [r1, r2]      ; get first data item
	ADDI r2, #4 									
	LDRR r5, [r1, r2]      ; get second data item

	SUBR r6, r5, r4	       ; get the difference between the items values
	BGT  Swap              ; jump to swap if r4 > r5
	
	ADDR r7, r2, r1
	SUBI r7, #DataEnd      ; check if second element matches the value of the last
	BEQ ArrayEnd           ; go to EndSort if second

	BU   FetchCompare      ; compare second item with the next one								

Swap

	MOVI r3, #1

	STRR r4, [r1, r2]											
	SUBI r2, #4
	STRR r5, [r1, r2]
	ADDI r2, #4

	ADDR r7, r2, r1
	SUBI r7, #DataEnd
	BEQ ArrayEnd
	
	BU FetchCompare 

ArrayEnd
	
	SUBI r3, #1
	BNE EndSort

	MOVI r2, #0
	BU StartSort
	
EndSort
	BU Stop

	; **** One way to use the SVCs 
	; **** (as sub-routine calls to the SVCs)
	
DumpRegs 
    PUSH {lr} ; save return address onto stack
    SVC 16 ; debug command to dump all registers
    POP {pc} ; return to calling sub-routine
	
PrintR0
    PUSH {lr} ; save return address onto stack
    SVC 0 ; debug command to printR0
    POP {pc} ; return to calling sub-routine
	
Stop
	BL DumpRegs ; print all the registers
	SVC 100 ; stop the emulator
	
	END
