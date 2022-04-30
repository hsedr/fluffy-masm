;----------------------------------------------------------------
; @author: hsedr
; This program executes a OTP Encyription on a given String.
; It first asks for a Text, second for a key the same length,
; and prints the encrypted String.
; NOTE: only upper case values will give the correct output.
;----------------------------------------------------------------
.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\macros\macros.asm

.data
	msg db "Enter Text to encode: ",0
	msg2 db "Enter a Text of same length: ",0
	msg3 db "Encripted Text: ",0
	buffer db 100 dup(0),0
	key_buffer db 100 dup(0),0
	;msg len equ $ - msg

.code

start:
	call main
	invoke ExitProcess, 0

main proc

	invoke StdOut, addr msg			
	invoke StdIn, addr buffer, 100
	invoke StdOut, addr msg2
	invoke StdIn, addr key_buffer, 100

	mov edx, -1						     ; reset offset
	
loadChar_:
	add edx, 1						      ; offset
	lea esi, [buffer + edx]			; load source address			
	mov ecx, 1						      ; length of character
	cld								          ; clear direction flag
	lodsb							          ; load character to eax
	cmp al, 0						        ; if character is zero, end is reached
	jnz encode_						      ; if not, character is encoded
									            ; else, result text is printed
	mov edx, -1						      ; reset offset
	jmp print_						

encode_:	
	mov ebx, eax					      ; save eax to ebx
	lea esi, [key_buffer + edx]	; load address of key
	lodsb							          ; load key to eax
	add al, bl						      ; encrypt: character + key = new letter
	jmp modulo_						      ; compute -> eax mod 26
	
continue_:
	lea edi, [buffer + edx]			; load destination address
	stosb							          ; replace old value at the destination address
	jmp loadChar_					      ; repeat

modulo_:
	push edx						        ; save edx, because it will be altered
	sub eax, 129					      ; subtracting 129 gives the decimal value we need for further computation
	xor edx, edx					      ; edx = 0
	mov ebx, 26						      ; ebx = 26
	div ebx							        ; eax mod 26 -> will be stored in edx
	mov eax, edx					      ; index of the new letter in the alphabet -> stored in eax
	add eax, 65						      ; adding 65 will give the ASCII-Code for the new letter (in upper case)
	pop edx							
	jmp continue_

print_:
	invoke StdOut, addr msg3
	invoke StdOut, addr buffer
	ret
main endp

end main
