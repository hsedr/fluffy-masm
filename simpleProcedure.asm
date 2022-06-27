;   Simple program how to work with procedures
;   Here you can see how to work with parametes and return values in procedure
;   Author: cube-bit(denis-seredenko@ukr.net)
.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.data
   ziffer dw 0
   rulesAcception dw 3 dup(?)
.code

countSum proc
    push ebp
    mov ebp, esp

    mov eax, 0

    mov ebx, 0
    .while ebx < 8
        mov ecx, [ebp+ebx*4+8]
        add eax, ecx
        inc ebx
    .endw
    
    mov [ebp+ebx*4+8], eax ;save in last return parameter. ebp + 8*4 + 8. 8*4 - means 8 params. +8 first return value. +4 first value
    mov esp, ebp
    pop ebp
    ret 8 * 4 ;8 parameters with size eax => 8*4
countSum endp

main proc
    
    mov ebx, 0 

    push 0   ;reserve place for returned value
    
    .while ebx < 8
        invoke StdIn, addr ziffer, 1

        mov ecx, 0
        mov cx, [ziffer]
        sub ecx, 30h
        
        mov al, cl
        mov ecx, 0
        mov cl, al
        push ecx

        invoke StdIn, addr ziffer, 2
        inc ebx
    .endw


    call countSum

    pop ecx;here you become result(return value) from procedure
    
    printf("Result of sum is: %d", ecx)
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