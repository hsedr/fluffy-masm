;Author: https://github.com/Zylence

.386
.model flat,stdcall
option casemap:none


includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

include \masm32\include\masm32rt.inc
include \masm32\macros\macros.asm

.data
    list dd 2, 31, 1, 5, 434, 2, 7, 5, 64, 23, 2345, 23, 652
    list_offset equ 4   ;offset: 1 for db, 2 for dw, 4 for dd
    len_list equ $ - list_offset - list ;determine length of list dynamicly
    change dd 1

.code
start:
    ;bubblesort loop
    .while change == 1  ;runs while values were swapped
        mov ecx, 0      ;current list position
        mov change, 0
        .while ecx < len_list
            mov ebx, list[ecx]                  ;a
            mov edx, list[ecx + list_offset]    ;b
            cmp edx, ebx
            .if CARRY? ;swap values if a > b
                mov list[ecx], edx
                mov list[ecx + list_offset], ebx
                mov change, 1
            .endif
            add ecx, list_offset
        .endw
    .endw

    ;print list
    mov esi, 0
    .while esi <= len_list
        printf("%d, ", list[esi])
        add esi, list_offset
    .endw

    exit    
end start