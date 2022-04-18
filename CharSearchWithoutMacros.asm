;Author: https://github.com/Zylence

.386
.model flat,stdcall
option casemap:none

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
include \masm32\include\masm32rt.inc


.data
    msg0 db "Input your base string: ", 0   ; StdOut needs to know where to stop, hence: ", 0"
    msg1 db "Input a char to search: ", 0   
    msg2 db "Character found at: ", 0
    string db 99 dup(?), 0                  ; word or phrase we are searching for a character in (max 100 chars)
    character db 1 dup(?), 0                ; character we look after in string
    index1 db 0, 0                          ; tens digit (StdOut)
    index0 db 0, ", ", 0                    ; units digit (StdOut)
.code
    

find_chars proc
    mov ecx, 0                              ; the index in string char is compared to

    main_:

        mov eax, 0                          ; set registers 0 to be able to compare ascii --
        mov ebx, 0                          ; without leftover artifacts from previous values
        mov al, character                   ; move character to al
        mov bl, string[ecx]                 ; move the character from string at index ecx in bl

        dec bl                              ; check for character, if this sets a zero flag: --
        js end_                             ; the string-end has been reached and the process is done
        inc bl                              ; revert changes if no zero flag was set

        cmp al, bl                          ; compare the two characters
        push ecx                            ; push ecx to stack to avoid trashing
        jz print_                           ; if they are equal, jump to print_ label
        jmp repeat_                         ; else repeat

    repeat_:
        pop ecx                             ; retrieve ecx from stack
        inc ecx                             ; increment ecx (index) by one
        jmp main_                           ; start 'next round'

    print_:       
        mov edx, 0                          ; set edx to 0 for upcoming division
        mov al, cl                          ; prepare for division (index / 10) in al
        mov cx, 10
        div cx                              ; divide index by 10
        mov index1, al                      ; move quotient (tens digit) to index1
        mov index0, dl                      ; remainder (ones digit) to index0
        add index1, 30h                     ; add 30h to make number properly displayable in ascii
        add index0, 30h            
        invoke StdOut, addr index1          ; output the index 
        invoke StdOut, addr index0
        jmp repeat_

    end_:                                   ; end the procedure
        ret

find_chars endp


start:
    invoke StdOut, addr msg0        
    invoke StdIn, addr string, 100

    invoke StdOut, addr msg1
    invoke StdIn, addr character, 1

    invoke StdOut, addr msg2
    call find_chars

    invoke ExitProcess, 0    
end start