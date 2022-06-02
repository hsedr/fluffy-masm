;Program that searches chars in string
;Using SCAS
;
.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.data
    text db 400 dup(?), 0           ;text with maximal length 400
    searched db ?, 0                ;char that we will search
.code

main proc
    printf("Type your text. To submit type ENTER\n")
    invoke StdIn, addr text, 400

    printf("What you gonna search? Enter 1 symbol: ")
    invoke StdIn, addr searched, 1
   
   lea edi, text                    ;for SCAS the data item to be searched should be in AL and text where we will search in edi
   
   mov ebx, 0                       ;index of symbol
   mov al, searched                 ;moving element that will be searched in AL
   
   _searchLoop: 
        
        push ebx                    ;saving EBX, because we will put char of text in bl

        mov bl, [edi]               ;IF found end of string => exit
        cmp bl, 0                   ;end of string is just a char to 0 comparison
        je ex

        pop ebx                     ;restore EBX

        scas  text                  ;compare char at AL, with char at pointer EDI. If it will found AL will be cleared.
        je printIndex               ;If found then print index

        inc ebx                     ;If NOT found then increment index
        jne _searchLoop             ;repeat _searchloop

        printIndex:
           printf("Found at index: %d\n", ebx)      ;print index 
           mov al, searched         ;IF SCACS finds then AL will be cleared => we have to add in AL searched char
           jmp _searchLoop          ;repeat _searchloop

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