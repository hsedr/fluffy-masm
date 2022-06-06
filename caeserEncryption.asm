.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.data
    text db 400 dup(0), 0           ;allocate 400 chars for text and at the end 0, for StdOut
    encrypted db 400 dup(0), 0      ;allocate 400 chars for encrypted text
    sz dd ?                         ;variable where I store size of my input text     
    off db ?                     ;variable offset that will be used for encryption
.code

main proc
   
    printf("Type your encryption text.\nIn order to submit type ENTER: \n")
    invoke StdIn, addr text, 400    ;try to read 400 symbols or up to ENTER and save it in text variable

    printf("Specify offset:")

    invoke StdIn, addr off, 100

    sub off, 30h                    ;cause it is number

    lea esi, text                   ;add to esi(source string) pointer at begin of the string(variable text)
    lea edi, encrypted              ;add to edi(destination string) pointer at begin of the string(variable encryption)

    mov ebx, 0                      ;counter variable

    _countloop:
        lods text                  ;load char from text and store it AL(because db)
        
        cmp al, 0                  ;If AL is null => end of string => print result
        je _endOfLine              
          
        inc ebx                    ;Increment size of text
        add al, off                ;Add offset to al(encrypt)

        stos encrypted             ;Add encrypted char in string
        jmp _countloop

    _endOfLine:
        printf("You encrypted text: ")
        invoke StdOut, addr encrypted ;print encrypted text
        printf("\n")

    ;invoke StdOut, addr secured
   
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