.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.data
.code
main proc

    ;set all registers to 0
    mov eax, 0 
    mov ecx, 0 
    mov ebx, 0 
    mov edx, 0
    
    push sval(input("How many nums:")) ; I read first data. And also push it to stack.

    readlp:
        CMP ebx, [esp+4*ebx] ;Take a note that ebx is how many elements we read. And in stack bottom there is size of array
        JE setter  ;if amount of element, that we have read, = to size then we stop cycle
        mov eax, sval(input("Number: ")) ;get number
        push eax ;push it to stack
        
        inc ebx     ;increment counter
        jmp readlp    ;repeat

    setter:
        mov ecx, ebx ;ebx - size of array
        push ebx     ; we also push it to stack, so at top there is size then elements and at bottom size
        mov edx, ecx

    dec ecx ; counter for outer loop

    OUTERLOOP:
        mov ebx, 0 ;ebx is a counter of innerloop
        mov edx, ecx ;edx is a end point for innerloop (size-1) or ecx - 1. We will make it in function carry

    INNERLOOP:
        ;unfortunately I had to do it in order to save data there
        push eax
        push ecx

        mov eax, [esp+12+ebx*4] ;Remember that before two pushs there were size on top. That's why offset is 4*3(numbers before real elements of array)
        mov ecx, [esp+16+ebx*4] ;We wanna get a[i+1], that's why we make offset +16. AND ebx stores current index
        cmp eax, ecx ;simple compare
        JC CARRY                ;if eax > ecx THEN jump to carry
        mov [esp+12+ebx*4], ecx ;Here we just swap two elements
        mov [esp+16+ebx*4], eax

    CARRY:
        INC ebx  ;we increment index
        DEC edx  

        ;restore data from stack
        pop ecx
        pop eax
        
        JNZ INNERLOOP
        LOOP OUTERLOOP

    ;we will enter here if LOOP OUTERLOOP won't work => we know that buble sort is ready 
    mov eax, 0

    ;restore a size of array
    pop ecx
    
    ;jump to function that prints our array from stack
    jmp printer
    
    
    ;simple function that will stop programm
    ex:
      inkey "Press key to end"
      push 0
      push 0
      push 0
      call ExitProcess

    ;function that will show all elements of array
    printer:
       mov ebx, 0

       ;save counter. We need this, because printf uses eax, ecx
       push eax
       
       ;remember in ecx we store size of array. EAX is our counter. And we check if it's equals
       CMP eax, ecx
       JE ex

       mov ebx, [esp+4+4*eax] ;remember that we pushed eax in stack before that's why I add extra 4
       
       ;save size due to printf
       push ecx

       printf("Index: %d; Data: %d\n", eax, ebx)

       ;restore data from stack
       pop ecx
       pop eax

       ;increment counter
       inc eax

       jmp printer

main endp
end main