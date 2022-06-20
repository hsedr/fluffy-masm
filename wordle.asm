;   Wordle game
;   Idea: User 1 inputs word to be guessed. User2 tryies to guess
;   Author: Cube Bit(denis-seredenko@ukr.net)
.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.data
   acceptionOfRules db ?   ;variable that stores 1 - if user accepted rules, 0 - if not
   tries dd 6              ;variable that counts how many tries of guessing left
   inputWord dw 5 dup(?), 0 ;input word from user1 
   guessedWord db 5 dup(63), 0 ;variable where stored data like ? ? ? ? r, where ? - means not guessed symbol and r - guessed
   inputChar dw ?, 0           ;char that user tryes guessing
   winStatus dd 0             ;when setted to 1 - means user won, 0 - lost or unknown
.code


;Macros for cleaning console
Cls MACRO c$:=<32>
  push esi
  push ecx
  invoke GetStdHandle, STD_OUTPUT_HANDLE
  xchg eax, esi
  sub esp, CONSOLE_SCREEN_BUFFER_INFO
  invoke GetConsoleScreenBufferInfo, esi, esp
  if 0
	pop ax	; one byte longer
	pop dx
	cwde
	mul dx
  else
	pop eax
	cwde
	mul word ptr [esp-2]
  endif
  invoke FillConsoleOutputCharacter, esi, c$, eax, 0, esp
  invoke SetConsoleCursorPosition, esi, 0
  pop edx
  add esp, CONSOLE_SCREEN_BUFFER_INFO-8
  pop ecx
  pop esi
ENDM


;Procedure that checks if user wins
;Set's variable winStatus to 1 if user wins
checkWIN proc 

    mov ebx, 0        ;counter variable
    .while ebx < 5    ;loop from 0 to 5
        
        mov ecx, 0
        mov cl, [guessedWord + ebx] ;read symbol from guessed word

        .IF cl == 63   ;if symbol from guessed word == '?', that means that user haven't guessed all symbols
            ret
        .ENDIF
        
        inc ebx        ;increment counter variable
    .endw

    mov winStatus, 1   ;here means that all symbols in guessed word != '?' => we can say that user gussed everything
    ret

checkWIN endp


;Procedure that will find inputted symbol from user in word
openChar proc

    mov ebx, 0                            ;counter variable
    .while ebx < 5                        ;count from 0 to 5
        mov ax, [inputWord + ebx]         ;read symbol from word to be guessed at position ebx => inputWord[ebx]
        
        mov ecx, 0                          
        mov cx, inputChar                 ;save inputted symbol to register

        .IF cl == al                      ;if inputted symbol = symbol from word
            mov [guessedWord + ebx], 114  ;then set that we guessed symbol at position ebx. There we set r - means that found
        .ENDIF

        inc ebx                           ;increase counter variable
    .endw

    dec tries                             ;decrement amount of tries

    ret 
openChar endp


;Procedure that will write rules of the game
welcomeRules proc

    printf("--------- Welcome to the game Wordle ---------\n\n")
    printf("Rules are pretty simple\n")
    printf("1. There are 2 players\n")
    printf("2. Player 1 types a word to be guessed by Player 2. NOTE!: length of word is 5 maximum\n")
    printf("3. Then Player 2 starts gessing characters in word\n")
    printf("4. If player guessed all charachters in word he wons\n")
    printf("5. Player 2 has only 6 tries to guess all characters\n")
    printf("\nIf you understand the rules and ready to play then please type Y: ")

    ret
welcomeRules endp

main proc
    
    call welcomeRules

    invoke StdIn, addr acceptionOfRules, 1

    .IF acceptionOfRules == 89 ;If user entered 'Y'. Means that user accepted all rules.
        printf("Cool! Let's the battle begin!\n")
        Cls                    ;clear screen
        jmp readWord           ;jump to read word from Player1
     .ELSE
        printf("You won't play until you ACCEPT all rules!!!!!\nFor now bye\n")  ;If not accepted, then user is not allowed to play a game:)
        jmp ex
    .ENDIF


    ;here we read word from user1
    readWord:
        printf("Player 1 please input word - maximum 5 length\n")
        printf("Please note that if you input bigger, then we will read only 5 first characters\n")
        
        invoke StdIn, addr inputWord, 2 ;it ignores this line. I DON'T KNOW WHY. please delete masm or contact me:)
        invoke StdIn, addr inputWord, 5  
        
        Cls

        jmp gameStart


    ;Main cycle of the game, where player2 inputs symbols and tries to guess a word 
    gameStart:
        .while tries != 0
             printf("Player 2 please input only 1 charachter(if you input bigger then we read only first char)!\n")

            invoke StdIn, addr inputChar, 6 ;it ignores this line
            invoke StdIn, addr inputChar, 1 
            
            call openChar
            call checkWIN

            .IF winStatus == 1              ;If user wins then write message and exit
                Cls
                printf("Congrats you made it\n")
                jmp ex
            .ENDIF

            Cls

            printf("Tries left: %d\n", tries)
            printf("Guessed word: ")
            invoke StdOut, addr guessedWord
            printf("\n? - means not found yet. r - found\n\n")
        .endw

        Cls
        printf("-----LOSER-----\n")

    ex:
      inkey "Press key to end"
      push 0
      push 0
      push 0
      call ExitProcess

main endp

start:
    call main
    call ExitProcess
end start