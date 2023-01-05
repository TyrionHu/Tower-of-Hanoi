        .ORIG   x3000
        ; *** Begin user program code here ***
START   ST      R0, SAVE_R0     ; save R0
        ST      R1, Save_R1     ; save R1
        ST      R2, Save_R2     ; save R2
        ST      R3, Save_R3     ; save R3
    
        LD      R2, NEWLINE     ; load newline character
L1      LDI     R3, DSR
        BRZP    L1              ; wait for DSR to be 0, LOOP UNTIL DISPLAY IS READY
        STI     R2, DDR         ; send newline to display

L2      LEA     R1, ID              ; STARTING ADDRESS OF PROMPT STRING
L21     LDR     R0, R1, #0          ; load character from ID string
        BRNP    L211                ; if IT'S NOT THE END, go to L211
        JMP     DELAY               ; if IT'S THE END, go to delay
        BRNZP   L2                  ; go back to L2

L211    LDI     R3, DSR
        BRZP    L211                ; wait for DSR to be 0, LOOP UNTIL DISPLAY IS READY
        STI     R0, DDR             ; send character to display
        ADD     R1, R1, #1          ; increment string pointer
        BRNZP   L21                 ; go back to L21

        ; code of delay
DELAY   ST      R1, Save_R1
        LD      R1, COUNT
REP     ADD     R1, R1, #-1
        BRp     REP
        LD      R1, Save_R1
        RET


        ; *** End user program code here ***
SAVE_R0         .BLKW           1
SAVE_R1         .BLKW           1
SAVE_R2         .BLKW           1
SAVE_R3         .BLKW           1
DSR             .FILL           xFE04
DDR             .FILL           xFE06
COUNT           .FILL           x0A00
NEWLINE         .FILL           x000A
ID              .STRINGZ        "PB21111629 "
        .END 

