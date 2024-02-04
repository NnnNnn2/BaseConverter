.686
.model flat
public _baseConv

; this function converts numbers to different bases ranging 2-36
; 36 being as shown below
; 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ

.data
	output db 64 dup(0)
	revOut db 64 dup(0)

.code
_baseConv PROC
	push ebp
	mov ebp, esp
	
	mov esi, [ebp+8]		; inStr
	mov edi, [ebp+12]		; inBase
	mov ebx, [ebp+16]		; outBase

	; check if bases in range
	cmp edi, 2
		jb exit
	cmp ebx, 2
		jb exit
	cmp edi, 36
		ja exit
	cmp ebx, 36
		ja exit
	
	mov ecx, esi			; counter
	mov eax, 0				; sum
	readIn:
		cmp BYTE PTR [ecx], 0
			je endIn		; if the character is '\0' (end of sting)
							; our number is stored in EAX

		cmp BYTE PTR [ecx], '0'
			jb exit			; if the character is below '0'
		cmp BYTE PTR [ecx], 'Z'
			ja exit			; if the character is above 'Z'

			mul edi				; multiplication by base

		cmp BYTE PTR [ecx], '9'
			ja above9		; it the character is above '9'

		; the character is in range '0'-'9'
			mov edx, 0
			mov dl, [ecx]
			add eax, edx
			sub eax, '0'
			inc ecx
			jmp readIn

		; the character is in range ':'-'Z'
		above9:
			cmp BYTE PTR [ecx], 'A'
				jb exit		; the character is in range ':'-'@'

			; the character is in range 'A'-'Z'
			mov edx, 0
			mov dl, [ecx]
			add eax, edx
			sub eax, 55		; A = 10 
			inc ecx
			jmp readIn
		
	endIn:
		mov ecx, OFFSET revOut
	encodeOut:
		mov edx, 0
		div ebx				; leftover in dl
		mov [ecx], dl
		cmp BYTE PTR [ecx], 9
			ja AOrAbove		; leftover above 9
		add BYTE PTR [ecx], '0'
		jmp belowA

		AOrAbove:
			add BYTE PTR [ecx], 55

		belowA:

		inc ecx
		cmp dl, 0
		jne encodeOut

		dec ecx
		mov eax, OFFSET output
		; reversing the output
		reverseLoop:
			dec ecx
			mov dl, [ecx]	
			mov [eax], dl
			inc eax
			cmp ecx, OFFSET revOut
			jne reverseLoop
			mov BYTE PTR [eax], 0



	exit:

		mov eax, OFFSET output
		pop ebp
		ret
_baseConv ENDP
END