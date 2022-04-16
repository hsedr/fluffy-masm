;-------------------------------------------------------------------------
; This programm takes a text and char from the console and prints the 
; the positions the char is found at.
; If the text does not contain the char nothing is written to the console.
; Max text length accepted is 98.
; Note that spaces are seen as characters too. Therefore, enter the char 
; without spaces.
;-------------------------------------------------------------------------

.386                                       ; Use the 386 instruction set
                                           
.model flat, stdcall                       ; Memory model - flat for Windows programs

option casemap :none                       ; Labels are case sensitive
include \masm32\include\windows.inc        ; Included files are required
include \masm32\include\kernel32.inc          
include \masm32\include\masm32.inc         
include \masm32\include\masm32rt.inc
include \masm32\macros\macros.asm
includelib \masm32\lib\kernel32.lib        
includelib \masm32\lib\masm32.lib          

.data                                       ; Variables go here
    msg1 db "Enter text: ", 0              
    msg2 db "Enter a character to search for:", 0 
    text_buffer db 100 dup(0)               ; buffer for entered text
    char_buffer db 1 dup(?)                 ; buffer for char to search for
    result dd 100 dup(0)                    ; array for indexes 
    index dd 0                              ; offset used for storing values in var result
   
.code                                           
start:                                      ; Starting point for the main code
    call main

    invoke ExitProcess, 0      
  
main proc
    invoke StdOut, addr msg1                ; Calls the StdOut, passing addr of msg1
    invoke StdIn, addr text_buffer, 100     ; entered text is stored in text_buffer
    invoke StdOut, addr msg2                ; Calls the StdOut, passing addr of msg2
    invoke StdIn, addr char_buffer, 1       ; entered char is stored in char_buffer
    call search                             ; procedure search is called
    ret
main endp

search proc
    
    lea esi, char_buffer                ; esi is assumed to be the source operand
    mov ecx, sizeof char_buffer         ; ecx is assumed to be length of the String 
    cld                                 ; direction flag 0
    lodsb                               ; char_buffer is loaded into eax
    mov bl, al                          ; value is saved in ebx
    
    lea esi, text_buffer                ; see above
    mov ecx, sizeof text_buffer
    cld
        
loop_:
    lodsb                               ; character is loaded into al
    cmp al, 0                           ; base case is char 0, indicates end of the array
    je print_                           ; if true result is printed
    dec ecx                             ; else ecx is decremented
    jcxz print_                         ; in case ecx is 0 the result is printed
    cmp al, bl                          ; the char_buffer and loaded char from text_buffer are compared
    je equal_found                      ; if equal equal_found is jumped to
    jne loop_                           

equal_found:                            # note that the variable index here is used as an offset
    push eax                            ; eax is saved
    mov eax, index                      ; index is loaded to eax
    mov [result + eax], ecx             ; current value of ecx is moved to address of result + offset
    call incIndex                       ; index/offset is increased
    pop eax                             ; eax popped back
    jmp loop_

print_:
    printf("Character found at following positions: ")
    mov ebx, sizeof text_buffer         ; eax stores size of the text
    ;mov ecx, sizeof result             ; ecx stores size of the result array
    xor ecx, ecx                        ; offset

repeat_:
    mov ebx, sizeof text_buffer         ; size of array is loaded again bc it is used for a calculation later
    mov eax, [result + ecx]             ; index stored in result is loaded into eax, ecx is the offset, see equal_found
    cmp eax, 0                          ; base case is index of zero
                                        ; note that result is declared with 100 dup(0)
                                        ; 0 therefore indicates that no other indexes are left for us to read
    je end_                             ; if true we jump to the end 
    push ecx                            ; otherwise we save ecx
    sub ebx, eax                        ; difference between array length and the index gives us actual position
    printf("%d ", ebx)                  ; print position
    pop ecx                             
    add ecx, 4                          ; offset is increased
    jmp repeat_                 
end_:   
    ret
search endp

incIndex proc
    push eax                             ; eax is saved to the stack
    mov eax, index                       ; index is loaded
    add eax, 4                           ; and increased
    mov [index], eax                     ; moving index back to memory address
    pop eax                              ; popping back eax
    ret
incIndex endp


end start               
