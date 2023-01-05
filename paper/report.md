# Lab05 Tower of Hanoi

## Category

[toc]

## Task & Purpose

The functionof Hanoi Tower problem:
$$
H(n) = \left\{
\begin{aligned} 
0 ,n = 0 \\
2H(n − 1) + 1,n > 0
\end{aligned}
\right.
$$
Mission:

- Write the user program described below.
- Write the keyboard interrupt service routine described below.

### The User Program

The argument of tower of hanoi, recorded as N , will be initialized with xFFFF and stored at X3FFF in memory.

Your user program, which starts at x3000, will continually (i.e. in an infinite loop) print your student id like: PB12345678 PB12345678 PB12345678 PB12345678 PB12345678 PB12345678 ······ and wait for argument N to become a valid value. When N becomes a valid value, the program stops waiting and calls the HANOI subroutine to solve the problem. After HANOI subroutine solve the problem, your result should be displayed on the console in decimal format.

To ensure the output on the screen is not too fast to be seen by the naked eye, the user program should include a piece of code that will count down from 2500 (or any other numbers) after each word is output on the screen. A simple way to do this is with the following subroutine DELAY:

```assembly
        ; code of delay
DELAY   ST R1, SaveR1
        LD R1, COUNT
REP     ADD R1, R1, #-1
        BRp REP
        LD R1, SaveR1
        RET
```

#### The Keyboard Interrupt Service Routine

The keyboard interrupt service routine, which starts at x1000, will examine the key typed to see if it is a decimal digit. If the character typed IS NOT a decimal digit, the interrupt service routine will, starting on a new line on the screen, print

The service routine would then print a line feed (x0A) to the screen, and finally terminate with an RTI.

If the character typed IS a decimal digit, the interrupt service routine will, starting on a new line on the screen, print " is a decimal digit.". Then you should save this decimal number to x3FFF.

For example, if the input key is 'K', the interrupt service routine will print:
 If the input key is ‘4’, the interrupt service routine will print: and

change the value of x3FFF to 4.

The service routine would then print a line feed (x0A) to the screen, and finally terminate with an RTI.

Hint: Don't forget to save and restore any registers that you use in the interrupt service routine.

### The Operating System Enabling Code

Unfortunately, we have not installed Windows or Linux on the LC-3, so we provide you with STARTER CODE (in attachment) that enables interrupts. You MUST use the starter code for this assignment. The locations to write the user program and interrupt service routine are marked with comments.

The starter code does the following:

1. Initializes the interrupt vector table with the starting address of the interrupt service routine. The keyboard interrupt vector is x80 and the interrupt vector table begins at memory location x0100. The keyboard interrupt service routine begins at x1000. Therefore, we must initialize memory location x0180 with the value x1000.
2. Sets bit 14 of the KBSR to enable interrupts.
3. Pushes a PSR and PC to the system stack so that it can jump to the user program at x3000 using an RTI instruction.

## Example

```
PB12345678 PB12345678 PB12345678 PB12345678 PB12345678 PB12345678
h is not a decimal digit. //Input character 'h'
PB12345678 PB12345678 PB12345678 PB12345678 PB12345678 PB12345678
5 is a decimal digit. //Input character '5'
Tower of hanoi needs 31 moves.

--- Halting the LC-3 ---
```

## Requirement

1. Since the interrupt can be triggered at any point, the output of the interrupt service routine may show up anywhere.
2. Since your user program contains an infinite loop, you will have to press the "Pause" button in the simulator if you wish to stop the program.
3. Make sure that the "Ignore privileged mode" switch is ON. (Default configuration is OFF in LC-3 simulator)
4. Please initialize USP by setting R6 to a appropriate value such as xFDFF at the begining of your user program.
5. The report shall contain at least 3 parts: How do you work out the algorithm? How do you write the program? And how do you design your own test cases to ensure the program works fine?

## How did I work out the algorithm?

What algorithm?

With my limited knowledge, I don't think this lab is very algorithm-related. 

If I have to say, apart from the obvious Hanoi algorithm, there is a divide and conquer algorithm-spirit. To get this complex task done, I can divide it into 3 sub-task, and each one is much more effortless to complete. 

## How did I write the program?

With the Operating System code given, the rest is relatively easy. 

Firstly, the user program. It's so easy that It did not need any explanation. In this program, just continuously display my student ID, with some delay between each display. 

About the interrpt service Routine, it is some what difficult. 

To realize the ideal function, first, I need to do callee saving. Than I check whether the input is valid – a digit, and record it with a flag. After that, if it's not a valid input, just display it right away. However, if it is a valid input, call the subroutine HANOI, which will calculate the disks needed to be moved. This part of recursive subroutine is not so difficult. 

The troublesome part is to display the digits with a hundredth digit or tenth digit. 

I have to get each digit and than display it separately. 

## How did I design my own test cases to ensure the program works fine?

I just randomly hit the keyboard, and see if the interrupt service is called properly, and see if the outcome is correct or not. 

Also, I prepared a table of Hanoi tower problem, ranging from 0 to 9. 

| N    | H(N) |
| ---- | ---- |
| 0    | 0    |
| 1    | 1    |
| 2    | 3    |
| 3    | 7    |
| 4    | 15   |
| 5    | 31   |
| 6    | 63   |
| 7    | 127  |
| 8    | 255  |
| 9    | 511  |

## Result

After I loaded the program into the LC-3 simulator, I set PC to x0800, where the Operation System code lies. 

Than I hit the run button, and my student ID were continuously displayed in the terminal. 

When I hit a keyboard, if which is a digit, than the according number of disks needed to be moved will show in the terminal, and if what I hit is not a digit, it would display h is not a decimal digit. //Input character 'h'. 

All in all, the program operates well.  

## code

```assembly
; Unfortunately we have not YET installed Windows or Linux on the LC-3,
; so we are going to have to write some operating system code to enable
; keyboard interrupts. The OS code does three things:
;
;    (1) Initializes the interrupt vector table with the starting
;        address of the interrupt service routine. The keyboard
;        interrupt vector is x80 and the interrupt vector table begins
;        at memory location x0100. The keyboard interrupt service routine
;        begins at x1000. Therefore, we must initialize memory location
;        x0180 with the value x1000.
;    (2) Sets bit 14 of the KBSR to enable interrupts.
;    (3) Pushes a PSR and PC to the system stack so that it can jump
;        to the user program at x3000 using an RTI instruction.

        .ORIG   x0800
        ; (1) Initialize interrupt vector table.
        LD      R0, VEC
        LD      R1, ISR
        STR     R1, R0, #0

        ; (2) Set bit 14 of KBSR.
        LDI     R0, KBSR
        LD      R1, MASK
        NOT     R1, R1
        AND     R0, R0, R1
        NOT     R1, R1
        ADD     R0, R0, R1
        STI     R0, KBSR

        ; (3) Set up system stack to enter user space.
        LD      R0, PSR
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        LD      R0, PC
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ; Enter user space.
        RTI
        HALT

VEC     .FILL   x0180             ; Interrupt vector table. 
ISR     .FILL   x1000             ; Interrupt service routine.
KBSR    .FILL   xFE00             ; Keyboard status register.
MASK    .FILL   x4000             ; Bit mask for enabling interrupts.
PSR     .FILL   x8002             ; PSR for user program.
PC      .FILL   x3000             ; PC for user program.
        .END


.ORIG   x1000
        ; *** Begin interrupt service routine code here ***

        ST      R0, SAVER0
        ST      R1, SAVER1
        ST      R2, SAVER2
        ST      R3, SAVER0
        ST      R4, SAVER4
        ST      R5, SAVER5
        ST      R6, SAVER6
        LD      R3, BREAK
        LD      R4, FLAG
        LD      R5, SAVE
            
LOOP    LDI     R1, KBSR1               ;CHECK KEYBOARD STATUS
        BRzp    LOOP
        LDI     R0, KBDR1
        LD      R2, NEG_ASCII_9         ;CHECK IF INPUT ASCII CODE IS LARGER THAN 9
        ADD     R1, R2, R0
        BRp     LOOP1
        LD      R2, NEG_ASCII_0         ;CHECK IF INPUT ASCII CODE IS SMALLER THAN 0
        ADD     R1, R2, R0
        BRn     LOOP1

        ;   STI R0, SAVE            ;SAVE THE INPUT ASCII CODE
        NOT     R4, R4              ;FLAG <- 0
        
LOOP1   LDI     R1, DSR      ;CHECK DISPLAY STATUS  
        BRzp    LOOP1
        STI     R3, DDR      ;NEW LINE  
        
LOOP2   LDI     R1, DSR      ;CHECK DISPLAY STATUS
        BRzp    LOOP2
        STI     R0, DDR      ;<the input character> 
        ADD     R4, R4, #0
        BRn     INVALID      ;FLAG = 0, INVALID INPUT
        
        ST      R3, SAVER3
        ST      R2, SAVER2
        ST      R0, SAVER0
        LEA     R0, STRING2     ;OUTPUT "PLEASE INPUT THE NUMBER OF DISKS:"
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
        ADD R1, R0, R2          ;R1 <- N
        BRnzp   HANOI

INVALID LEA     R0, STRING1
        BRnzp   PUTSTR

DONE    LD      R0, SAVER0
        LD      R1, SAVER1
        LD      R2, SAVER2
        LD      R3, SAVER3
        LD      R4, SAVER4
        LD      R5, SAVER5
        LD      R6, SAVER6
        RTI          

PUTSTR  LDR     R3, R0, #0
        BRz     DONE
L0      LDI     R2, DSR
        BRzp    L0
        STI     R3, DDR
        ADD     R0, R0, #1
        BRnzp   PUTSTR

    
HANOI   AND     R3, R3, #0      ;counter
        AND     R2, R2, #0      ;H(N)
        NOT     R1, R1
        ADD     R1, R1, #1      ;R1 <- -N
LOOP3   ADD     R6, R3, R1  
        BRn     CONTINUE

;OUTPUT THE NUMBER OF MOVES
        AND     R4, R4, #0
        LD      R6, HUNDRED
DIVIDE1 ADD     R5, R2, R6      ;GET THE HUNDRED DIGIT
        BRn     OUT1
        ADD     R4, R4, #1
        ADD     R2, R2, R6
        BRnzp   DIVIDE1

OUT1    ADD     R4, R4, #0
        BRz     TENS
        LD      R6, ASCII       ;OUTPUT HUNDRED DIGIT
        ADD     R4, R4, R6

LOOP4   LDI     R0, DSR         
        STI     R4, DDR 

TENS    LD      R6, NEG_TEN
        AND     R4, R4, #0
DIVIDE2 ADD     R5, R2, R6      ;GET THE TEN DIGIT
        BRn     OUT2
        ADD     R4, R4, #1
        ADD     R2, R2, R6
        BRnzp   DIVIDE2

OUT2    ADD     R4, R4, #0
        BRz     OUT3
        LD      R6, ASCII       ;OUTPUT TEN DIGIT
        ADD     R4, R4, R6

LOOP5   LDI     R0, DSR      
        BRzp    LOOP5
        STI     R4, DDR 

OUT3    LD      R6, ASCII
        ADD     R4, R2, R6      ;OUTPUT THE UNIT DIGIT
LOOP6   LDI     R0, DSR      
        BRzp    LOOP6
        STI     R4, DDR 
        BRnzp   OVER

CONTINUE    ADD     R2, R2, R2
            ADD     R2, R2, #1      ;H(N) = 2*H(N-1) + 1
            ADD     R3, R3, #1      ;COUNTER++
            BRnzp   LOOP3

OVER    LEA     R0, STRING3
        BRnzp   PUTSTR

SAVER2          .BLKW       1
SAVER1          .BLKW       1
SAVER0          .BLKW       1
SAVER3          .BLKW       1
SAVER4          .BLKW       1
SAVER5          .BLKW       1
SAVER6          .BLKW       1
FLAG            .FILL       xFFFF
KBSR1           .FILL       xFE00
KBDR1           .FILL       xFE02
DSR             .FILL       xFE04
DDR             .FILL       xFE06
NEG_ASCII_0     .FILL       xFFD0                                   ; -X30
NEG_ASCII_9     .FILL       xFFC7                                   ; -X39
BREAK           .FILL       x000A               
SAVE            .FILL       x3FFF               
STRING1         .STRINGZ    "  is not a decimal digit.\n"
STRING2         .STRINGZ    "  is a decimal digit.\n"
STRING3         .STRINGZ    " moves is needed for Hanoi Tower.\n"
HUNDRED         .FILL       xFF9C                                   ;-100
NEG_TEN         .FILL       xFFF6                                   ;-10
ASCII           .FILL       x30
        ; *** End interrupt service routine code here ***
        .END

        .ORIG   x3000
        ; *** Begin user program code here ***
START   ST      R0, SAVE_R0     ; save R0
        ST      R1, Save_R1     ; save R1
        ST      R2, Save_R2     ; save R2
        ST      R3, Save_R3     ; save R3
    
        LD      R2, NEWLINE     ; load newline character
L1      LDI     R3, DSR1
        BRZP    L1              ; wait for DSR1 to be 0, LOOP UNTIL DISPLAY IS READY
        STI     R2, DDR1         ; send newline to display

L2      LEA     R1, ID              ; STARTING ADDR1ESS OF PROMPT STRING
L21     LDR     R0, R1, #0          ; load character from ID string
        BRNP    L211                ; if IT'S NOT THE END, go to L211
        JSR     DELAY               ; if IT'S THE END, go to delay
        BRNZP   L2                  ; go back to L2

L211    LDI     R3, DSR1
        BRZP    L211                ; wait for DSR1 to be 0, LOOP UNTIL DISPLAY IS READY
        STI     R0, DDR1             ; send character to display
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
DSR1             .FILL           xFE04
DDR1             .FILL           xFE06
COUNT           .FILL           x0A00
NEWLINE         .FILL           x000A
ID              .STRINGZ        "PB21111629 "
        .END 
```

