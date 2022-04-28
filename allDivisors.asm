;--------------------------------------------
;This programms finds all divisors for number
;
;Input: 1 Number
;Output: all divisiors
;--------------------------------------------
.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.code
main proc
    mov eax, sval(input("Enter first number: "))

    ;push our number because printf will change register
    push eax

    printf("We will find divisors for number: %d\n", eax)

    ;restore number
    pop eax
    
    ;ecx is our itterator
    mov ecx, 1

    .while ecx <= eax

        ;make push in order to save number and itterator
        push eax
        push ecx
        
        div ecx

        cmp edx, 0

        ;if eax mod ecx != 0 then we have to skip our print
        jne skip_

        ;I will call this procedure if eax mod ecx = 0
        call teilbarcycle
        
        skip_:
        mov edx, 0 ;set edx to 0, because we can have some problems during division
        pop ecx ;restore itterator
        pop eax ;restore number
        inc ecx ;increment itterator
    .endw


    ;function to end programm
    ex:
      inkey "Press key to end"
      push 0
      push 0
      push 0
      call ExitProcess

main endp

;Procedure for printing divisior
;Will be called only when eax mod ecx = 0
teilbarcycle proc
    
    ;in procedure we use ebp for stack pointer.
    push ebp
    mov ebp, esp

    mov ecx, [ebp + 8] ;because offset is +8 in ebp and first number in stack is old EBP
    mov eax, [ebp + 12]

    printf("%d durch %d teilbar\n", eax, ecx)
    
    ;restore everything
    mov esp, ebp
    pop ebp
    ret
teilbarcycle endp


start:
    call main
    call ExitProcess
end start