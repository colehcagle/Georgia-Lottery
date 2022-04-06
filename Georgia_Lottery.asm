title	Georgia Lottery Simulation				(Lab10.asm)
;
; Cole Cagle
; CPEN 3710
; April 4, 2022
;
; This is an assembly language program that will simulate the drawing of the Georgia Lottery. The program will be executed through a structure that will
; take 6 balls that are numbered 1-47. The user will enter their 6 numbers to see if they were a winner or not. The entered values will be stored in another
; structure of the same type. 
;

include Irvine32.inc					; include Irvine's routines

mOutput MACRO text					; macro for displaying strings throughout execution of code
mov EDX, OFFSET text
call WriteString                                        ; replace call WriteString with mOutput
ENDM							; end of macro

.data
Lottery STRUCT
array1 DWORD 0, 0, 0, 0, 0, 0				; defining the structure with an array of 6 values
Lottery ENDS

random Lottery <>
user Lottery <>
											
PROMPT BYTE "Jumbo Bucks drawing results: ", 0		; defining the prompts of the program

PROMPT1 BYTE "Please enter your first number: ", 0
PROMPT2 BYTE "Please enter your second number: ", 0
PROMPT3 BYTE "Please enter your third number: ", 0
PROMPT4 BYTE "Please enter your fourth number: ", 0
PROMPT5 BYTE "Please enter your fifth number: ", 0
PROMPT6 BYTE "Please enter your sixth number: ", 0

PROMPTW1 BYTE "You have matched 3 of the 6 lottery balls. Your ticket wins $5!", 0
PROMPTW2 BYTE "You have matched 4 of the 6 lottery balls. Your ticket wins $50!", 0
PROMPTW3 BYTE "You have matched 5 of the 6 lottery balls. Your ticket wins $500!", 0
PROMPTW4 BYTE "You have matched 6 of the 6 lottery balls. Your ticket wins jackpot!", 0

PROMPTL1 BYTE "You have matched 0 of the 6 lottery balls. Your ticket wins $0.", 0
PROMPTL2 BYTE "You have matched 1 of the 6 lottery balls. Your ticket wins $0.", 0
PROMPTL3 BYTE "You have matched 2 of the 6 lottery balls. Your ticket wins $0.", 0

PROMPTE BYTE "Please enter a value between 1 and 47 inclusive.", 0

.code							; beginning of code
main proc						; beginning of main procedure

call Randomize						; calls Randomize to generate random values
mov ESI, OFFSET random					; saves the random values
call GenerateDraw                                       ; calls for GenerateDraw sub-proc
mOutput PROMPT					    	; displays PROMPT
mov ESI, OFFSET random.array1				; point to array1 
mov ECX, 6						; loop 6 times for the 6 values

LOOP1:							; beginning of LOOP1
mov EAX, [ESI]						; move number from structure into EAX
call WriteInt						; displays number
mov AL, ' '						; creates a space between numbers when displayed
call WriteChar						; displays the created space
add ESI, 4						; point to next value in structure
loop LOOP1						; loop back to beginning of LOOP1

call Crlf						; blank line

NUM1:							; beginning of NUM1 for first value
mOutput PROMPT1						; displays PROMPT1
call ReadInt						; reads the value the user entered
mov [user.array1], EAX					; saves the value in the structure
mov ECX, 0                                              ; moves 0 into ECX (do not check duplicate; not possible to have one)
call valid                                              ; calls for valid sub-proc
cmp EAX, 1                                              ; compares 1 to value in EAX
je NUM2                                                 ; if equal, jump to NUM2 for second number
mOutput PROMPTE 	                                  ; prints error message if jump is not made
jmp NUM1                                                ; jump back to beginning of NUM1 if error

NUM2:                                                   ; beginning of NUM2 for second value
mOutput PROMPT2                                         ; displays PROMPT2
call ReadInt                                            ; reads the value the user entered
mov [user.array1 + 4], EAX                              ; saves the value in the structure
mov ECX, 1                                              ; moves 1 into ECX (check duplicate)
call valid                                              ; calls for valid sub-proc
cmp EAX, 1                                              ; compares 1 to value in EAX
je NUM3                                                 ; if equal, jump to NUM3 for third number
mOutput PROMPTE                                         ; prints error message if jump is not made
jmp NUM2                                                ; jump back to beginning of NUM2 if error

NUM3:                                                   ; beginning of NUM3 for third value
mOutput PROMPT3                                         ; displays PROMPT3
call ReadInt                                            ; reads the value the user entered
mov [user.array1 + 8], EAX                              ; saves the value in the structure
mov ECX, 2                                              ; moves 2 into ECX (checks for duplicate with first two numbers)
call valid                                              ; calls for valid sub-proc
cmp EAX, 1                                              ; compares 1 to value in EAX
je NUM4                                                 ; if equal, jump to NUM4 for fourth number
mOutput PROMPTE                                         ; prints error message if jump is not made
jmp NUM3                                                ; jump back to beginning of NUM3 if error

NUM4:                                                   ; beginning of NUM4 for fourth value
mOutput PROMPT4                                         ; displays PROMPT4
call ReadInt                                            ; reads the value the user entered
mov [user.array1 + 12], EAX                              ; saves the value in the structure
mov ECX, 3                                              ; moves 3 into ECX (checks for duplicate with first three numbers)
call valid                                              ; calls for valid sub-proc
cmp EAX, 1                                              ; compares 1 to value in EAX
je NUM5                                                 ; if equal, jump to NUM5 for fifth number
mOutput PROMPTE                                         ; prints error message if jump is not made
jmp NUM4                                                ; jump back to beginning of NUM4 if error

NUM5:                                                   ; beginning of NUM5 for fifth value
mOutput PROMPT5                                         ; displays PROMPT5
call ReadInt                                            ; reads the value the user entered 
mov [user.array1 + 16], EAX                             ; saves the value in the structure
mov ECX, 4                                              ; moves 4 into ECX (checks for duplicate with first four numbers)
call valid                                              ; calls for valid sub-proc
cmp EAX, 1                                              ; compares 1 to value in EAX
je NUM6                                                 ; if equal, jump to NUM6 for sixth number
mOutput PROMPTE                                         ; prints error message if jump is not made
jmp NUM5                                                ; jump back to beginning of NUM5 if error

NUM6:                                                   ; beginning of NUM6 for sixth value
mOutput PROMPT6                                         ; displays PROMPT6
call ReadInt                                            ; reads the value the user entered 
mov [user.array1 + 20], EAX                             ; saves the value in the structure
mov ECX, 5                                              ; moves 5 into ECX (checks for duplicates with first five numbers)
call valid                                              ; calls for valid sub-proc
cmp EAX, 1                                              ; compares 1 to value in EAX
je JUMP1                                                ; if equal, jump to JUMP1
mOutput PROMPTE                                         ; prints error message if jump is not made
jmp NUM6                                                ; jump back to beginning of NUM6 if error

call Crlf                                               ; blank line

JUMP1:                                                  ; beginning of JUMP1
push EBX                                                ; places EBX on stack
mov EAX, 0                                              ; clears EAX
mov ECX, 6                                              ; moves 6 into ECX for 6 values to be compared
mov EDI, OFFSET user.array1                             ; directs pointer to the user entered values

LOOP2:                                                  ; beginning of LOOP2
mov EBX, [EDI]                                          ; takes value from the structure
mov ESI, OFFSET random.array1                           ; directs pointer to the random generated values
mov EDX, 6                                              ; moves 6 into EDX because there are 6 values to be checked

JUMP2:                                                  ; beginning of JUMP2
cmp EBX, [ESI]                                          ; comparison for user value and random value in structure
je JUMP3                                                ; if equal, jump to JUMP3
add ESI, 4                                              ; moves to next random value to be compared
dec EDX                                                 ; decrements EDX for every value checked
jne JUMP2                                               ; if not equal, jump back to beginning of JUMP2
jmp JUMP4                                               ; jump to JUMP4

JUMP3:                                                  ; beginning of JUMP3
inc EAX                                                 ; increment EAX for matches 

JUMP4:                                                  ; beginning of JUMP4
add EDI, 4                                              ; moves to next value from user to be compared
loop LOOP2                                              ; loop back to beginning of LOOP2
pop EBX                                                 ; takes EBX off of stack

cmp EAX, 0                                              ; compares 0 to EAX for matching values
je JUMP5                                                ; if equal, jump to JUMP5
cmp EAX, 1                                              ; compares 1 to EAX for matching values
je JUMP6                                                ; if equal, jump to JUMP6
cmp EAX, 2                                              ; compares 2 to EAX for matching values
je JUMP7                                                ; if equal, jump to JUMP7
cmp EAX, 3                                              ; compares 3 to EAX for matching values
je JUMP8                                                ; if equal, jump to JUMP8
cmp EAX, 4                                              ; compares 4 to EAX for matching values
je JUMP9                                                ; if equal, jump to JUMP9
cmp EAX, 5                                              ; compares 5 to EAX for matching values
je JUMP10                                               ; if equal, jump to JUMP10
cmp EAX, 6                                              ; compares 6 to EAX for matching values
je JUMP11                                               ; if equal, jump to JUMP11

JUMP5:                                                  ; beginning of JUMP5
mOutput PROMPTL1                                        ; displays PROMPTL1
jmp JUMP12						; jump to JUMP12

JUMP6:                                                  ; beginning of JUMP6
mOutput PROMPTL2                                        ; displays PROMPTL2
jmp JUMP12						; jump to JUMP12

JUMP7:                                                  ; beginning of JUMP7
mOutput PROMPTL3                                        ; displays PROMPTL3
jmp JUMP12						; jump to JUMP12

JUMP8:                                                  ; beginning of JUMP8
mOutput PROMPTW1                                        ; displays PROMPTW1
jmp JUMP12						; jump to JUMP12

JUMP9:                                                  ; beginning of JUMP9
mOutput PROMPTW2                                        ; displays PROMPTW2
jmp JUMP12						; jump to JUMP12

JUMP10:                                                 ; beginning of JUMP10
mOutput PROMPTW3                                        ; displays PROMPTW3
jmp JUMP12						; jump to JUMP12

JUMP11:                                                 ; beginning of JUMP11
mOutput PROMPTW4                                        ; displays PROMPTW4
jmp JUMP12						; jump to JUMP12

JUMP12:							; beginning of JUMP12
exit                                                    ; terminates execution of main proc
main ENDP                                               ; end of main proc

;
; This is the GenerateDraw sub-proc that will generate 6 random values for the lottery with no duplicates.
;

GenerateDraw proc                                       ; beginning of GenerateDraw sub-proc

mov EBX, 0                                              ; clears EBX
push EBX                                                ; places EBX on stack
mov EDI, ESI                                            ; directs pointer to structure
add EDI, OFFSET Lottery.array1                          ; point at array1 for the random 6 values
mov ECX, 6                                              ; moves 6 into ECX for 6 values

LOOP1:                                                  ; beginning of LOOP1
mov EAX, 47                                             ; moves 47 into EAX (max value)
call RandomRange                                        ; creates a specified range (0-46)
inc EAX                                                 ; range is now 1-47 in EAX
mov EBX, ESI                                            ; point to structure
add EBX, OFFSET Lottery.array1                          ; points to the beginning of the 6 values to generate
mov EDX, 6                                              ; 6 values for generating
sub EDX, ECX                                            ; subtracts ECX from EDX
jz JUMP1                                                ; if zero, jump to JUMP1

LOOP2:                                                  ; beginning of LOOP2
cmp EAX, [EBX]                                          ; compare to see if generated values are equal
je LOOP1                                                ; if equal, jump to LOOP1 for another value
add EBX, 4                                              ; next number to be generated
dec EDX                                                 ; decrement values to be checked
jne LOOP2                                               ; if not equal, jump to beginning of LOOP2 to be compared again

JUMP1:                                                  ; beginning of JUMP1
mov [EDI], EAX                                          ; saves acceptable generated value to structure
add EDI, 4                                              ; next number
loop LOOP1                                              ; end of LOOP1, loops until 6 acceptable values generated
pop EBX							; takes EBX off the stack
ret                                                     ; return to main proc

GenerateDraw ENDP                                       ; end of GenerateDraw sub-proc

;
; This is the valid sub-proc that will check and see if the values are valid; 1 is acceptable and 0 is not. This comparison is 
; in the main proc in blocks NUM1 through NUM6.
;

valid proc                                              ; beginning of valid sub-proc

cmp EAX, 1                                              ; compares 1 to value stored in EAX
jl JUMP1                                                ; if less than 1, jump to JUMP1
cmp EAX, 47                                             ; compares 47 to value stored in EAX
jg JUMP1                                                ; if greater than 47, jump to JUMP1
cmp ECX, 0                                              ; compares ECX to 0
je JUMP2                                                ; if first value (will be valid), jump to JUMP2
mov ESI, OFFSET user.array1                             ; points to array1 for user values

LOOP1:                                                  ; beginning of LOOP1
cmp EAX, [ESI]                                          ; compares to see if value is already in structure
je JUMP1                                                ; if equal, jump to JUMP1
add ESI, 4                                              ; moves to next value
loop LOOP1                                              ; end of LOOP1

JUMP2:                                                  ; beginning of JUMP2
mov EAX, 1                                              ; moves 1 into EAX for comparison in main proc (valid)
ret                                                     ; return to main proc

JUMP1:                                                  ; beginning of JUMP1
mov EAX, 0                                              ; moves 0 into EAX for comparison in main proc (not valid)
ret                                                     ; returns to main proc

valid ENDP                                              ; end of valid sub-proc
 
END main                                                ; end of program