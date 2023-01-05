        .ORIG   x1000
        ; *** Begin interrupt service routine code here ***

        ST	    R0, SAVER0
        ST	    R1, SAVER1
        ST	    R2, SAVER2
        ST	    R3, SAVER0
        ST	    R4, SAVER4
        ST	    R5, SAVER5
        ST	    R6, SAVER6
        LD      R3, BREAK
        LD      R4, FLAG
        LD	    R5, SAVE
            
LOOP	LDI	    R1, KBSR	            ;CHECK KEYBOARD STATUS
        BRzp	LOOP
        LDI	    R0, KBDR
        LD      R2, NEG_ASCII_9     	;CHECK IF INPUT ASCII CODE IS LARGER THAN 9
        ADD     R1, R2, R0
        BRp     LOOP1
        LD	    R2, NEG_ASCII_0	        ;CHECK IF INPUT ASCII CODE IS SMALLER THAN 0
        ADD	    R1, R2, R0
        BRn	    LOOP1

        ;	STI	R0, SAVE	        ;SAVE THE INPUT ASCII CODE
        NOT     R4, R4       	    ;FLAG <- 0
		
LOOP1	LDI	    R1, DSR		 ;CHECK DISPLAY STATUS  
        BRzp	LOOP1
        STI	    R3, DDR		 ;NEW LINE	
		
LOOP2   LDI	    R1, DSR		 ;CHECK DISPLAY STATUS
        BRzp	LOOP2
        STI	    R0, DDR		 ;<the input character> 
        ADD     R4, R4, #0
        BRn     INVALID      ;FLAG = 0, INVALID INPUT
        
        ST      R3, SAVER3
        ST      R2, SAVER2
        ST      R0, SAVER0
        LEA     R0, STRING2	    ;OUTPUT "PLEASE INPUT THE NUMBER OF DISKS:"
LOOPS1  LDR     R3, R0, #0
        BRz     OVER1
L01     LDI     R2, DSR
        BRzp    L01
        STI     R3, DDR
        ADD     R0, R0, #1
        BRnzp   LOOPS1
OVER1   LD      R3, SAVER3
        LD      R2, SAVER2
        LD      R0, SAVER0
        ADD	R1, R0, R2	        ;R1 <- N
        BRnzp	HANOI

INVALID LEA     R0, STRING1
        BRnzp   PUTSTR

DONE    LD	    R0, SAVER0
        LD	    R1, SAVER1
        LD	    R2, SAVER2
        LD	    R3, SAVER3
        LD	    R4, SAVER4
        LD	    R5, SAVER5
        LD	    R6, SAVER6
        RTI			 

PUTSTR  LDR     R3, R0, #0
        BRz     DONE
L0      LDI     R2, DSR
        BRzp    L0
        STI     R3, DDR
        ADD     R0, R0, #1
        BRnzp   PUTSTR

	
HANOI	AND	    R3, R3, #0	    ;counter
        AND	    R2, R2, #0	    ;H(N)
        NOT	    R1, R1
        ADD	    R1, R1, #1	    ;R1 <- -N
LOOP3	ADD	    R6, R3, R1  
        BRn	    CONTINUE

;OUTPUT THE NUMBER OF MOVES
        AND	    R4, R4, #0
        LD	    R6, NEG_HUNDRED
DIVIDE1	ADD	    R5, R2, R6	    ;GET THE NEG_HUNDRED DIGIT
        BRn	    OUT1
        ADD	    R4, R4, #1
        ADD	    R2, R2, R6
        BRnzp	DIVIDE1

OUT1    ADD	    R4, R4, #0
        BRz	    TENS
        LD	    R6, ASCII	    ;OUTPUT NEG_HUNDRED DIGIT
        ADD	    R4, R4, R6

LOOP4	LDI	    R0, DSR         
        STI	    R4, DDR	

TENS	LD	    R6, NEG_TEN
        AND	    R4, R4, #0
DIVIDE2	ADD	    R5, R2, R6	    ;GET THE TEN DIGIT
        BRn	    OUT2
        ADD	    R4, R4, #1
        ADD	    R2, R2, R6
        BRnzp	DIVIDE2

OUT2    ADD	    R4, R4, #0
        BRz	    OUT3
        LD	    R6, ASCII	    ;OUTPUT TEN DIGIT
        ADD	    R4, R4, R6

LOOP5	LDI	    R0, DSR		 
        BRzp	LOOP5
        STI	    R4, DDR	

OUT3    LD	    R6, ASCII
        ADD	    R4, R2, R6	    ;OUTPUT THE UNIT DIGIT
LOOP6	LDI	    R0, DSR		 
        BRzp	LOOP6
        STI	    R4, DDR	
        BRnzp	OVER

CONTINUE	ADD	    R2, R2, R2
            ADD	    R2, R2, #1	    ;H(N) = 2*H(N-1) + 1
            ADD	    R3, R3, #1	    ;COUNTER++
            BRnzp	LOOP3

OVER	LEA     R0, STRING3
        BRnzp   PUTSTR

SAVER2	        .BLKW	    1
SAVER1	        .BLKW	    1
SAVER0	        .BLKW	    1
SAVER3	        .BLKW	    1
SAVER4	        .BLKW	    1
SAVER5	        .BLKW	    1
SAVER6	        .BLKW	    1
FLAG            .FILL       xFFFF
KBSR	        .FILL	    xFE00
KBDR	        .FILL	    xFE02
DSR	            .FILL	    xFE04
DDR	            .FILL	    xFE06
NEG_ASCII_0     .FILL       xFFD0                                   ; -X30
NEG_ASCII_9     .FILL       xFFC7                                   ; -X39
BREAK	        .FILL	    x000A				
SAVE	        .FILL	    x3FFF				
STRING1         .STRINGZ    "  is not a decimal digit.\n"
STRING2         .STRINGZ    "  is a decimal digit.\n"
STRING3         .STRINGZ    " moves is needed for Hanoi Tower.\n"
NEG_HUNDRED     .FILL	    xFF9C		                            ;-100
NEG_TEN	        .FILL	    xFFF6		                            ;-10
ASCII	        .FILL	    x30
        ; *** End interrupt service routine code here ***
        .END