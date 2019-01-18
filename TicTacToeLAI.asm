;; Simple and hard to beat logic based AI, Human vs CPU, Tic Tac Toe 

%macro border1 0
	times 80 db "="
	db 10
%endmacro

%macro border2 0
	db "="
	times 78 db " "
	db "="
	db 10
%endmacro

section .data
	nL db 10
	nl_size equ $-nL
	board db "__|__|__",10
	      db "__|__|__",10
	      db "  |  |  ",10,0

	bo_size equ $-board

	borders:
		border1

		%rep 25
		border2
		%endrep

		border1

	b_size equ $-borders
	
	win db 0
	player db "0",0
	p_size equ $-player
	
	gameOverMsg db "Game,Over!",10
	gom_size equ $-gameOverMsg

	gameBeginMsg db "Let, the Game Begin, Press any key to continue",10
	gbm_size equ $-gameBeginMsg

	chanceMsg db "Your Turn Player, ",10
	cm_size equ $-chanceMsg

	winMsg db "Great play! player "
	wm_size equ $-winMsg

	typeMsg db "Type your number for the box"
	tm_size equ $-typeMsg

	clr_scr db 27,"[H",27,"2J"                ; source is x86assembly.org and others :P
	cs_size equ $-clr_scr

section .bss
	key resb 1
	nothing resb 1

section .text
	global _start

_start:
	;call _clrscr

	;mov rax,1
	;mov rdi,1
	;mov rsi,borders
;	mov rdx,b_size
;	syscall
;
;	mov rax,1
;	mov rdi,1
;	mov rsi,gameBeginMsg
;	mov rdx,gbm_size
;	syscall

_mainLoop:

	call _clrscr
	
	mov rax,1
	mov rdi,1
	mov rsi,chanceMsg
	mov rdx,cm_size
	syscall
	
	mov rax,1
	mov rdi,1
	mov rsi,board
	mov rdx,bo_size
	syscall
	
	mov rax,1
	mov rdi,1
	mov rsi,typeMsg
	mov rdx,tm_size
	syscall
	
	_repeatInput:
		call _getInput

	cmp rax,0
	je _repeatInput

	mov al,[key]
	sub al,48                              ; 48 in ASCII corresponds to zero

	call _updateBoard
	call _inspect

	cmp byte[win],1
	je _gameOver

	call _playerChange

	jmp _mainLoop

_playerChange:
	xor byte[player],1
	ret

_getInput:
	mov rax,0
	mov rdi,0
	mov rsi,key
	mov rdx,1
	syscall

	cmp byte[key],0x0A
	jz _readLast

	mov rdi,0
	mov rsi,nothing
	mov rdx,1

	_drain:
		mov rax,0
		syscall
	
		cmp byte[nothing],0x0A
		jz _readLast
		jmp _drain

	_readLast:
		ret

_updateBoard:
	cmp rax,1
	je _1P

	cmp rax,2
	je _2P

	cmp rax,3
	je _3P

	cmp rax,4
	je _4P

	cmp rax,5
	je _5P

	cmp rax,6
	je _6P

	cmp rax,7
	je _7P

	cmp rax,8
	je _8P

	cmp rax,9
	je _9P

	jmp _updateLast

	_1P:
		mov rax,0
		jmp _continue
	_2P:
		mov rax,2
		jmp _continue
	_3P:
		mov rax,4
		jmp _continue
	_4P:
		mov rax,6
		jmp _continue
	_5P:
		mov rax,8
		jmp _continue
	_6P:
		mov rax,10
		jmp _continue
	_7P:
		mov rax,12
		jmp _continue
	_8P:
		mov rax,14
		jmp _continue
	_9P:
		mov rax,16
		jmp _continue

	_continue:
		lea rbx,[board+rax]
		mov rsi,player
		
		cmp byte[rsi], "0"         ; this took 2 hours to spot " Damn!!! "
		je _X

		cmp byte[rsi], "1"
		je _o

		_X:
			mov cl, "x"
			jmp _update
		_o:
			mov cl, "o"
			jmp _update

		_update:
			mov [rbx],cl

	_updateLast:
		ret

_inspect:		
	call _inspectLine
	ret

_inspectLine:
	mov rcx,0
	
	_inspectLineLoop:
		cmp rcx,0
		je _1L

		cmp rcx,1
		je _2L

		cmp rcx,2
		je _3L

		call _inspectColumn
		ret

		_1L:
			mov rsi,0
			inc rcx
			lea rbx,[board+rsi]
			mov al,[ebx]
			cmp al, " "
			je _inspectLineLoop

			add rsi,2
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectLineLoop

			add rsi,2
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectLineLoop

			mov byte[win],1

		_2L:
			mov rsi,6
			inc rcx
			lea rbx,[board+rsi]
			mov al,[ebx]
			cmp al, " "
			je _inspectLineLoop

			add rsi,2
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectLineLoop

			add rsi,2
			lea rbx,[board+rsi]

			cmp  al,[rbx]
			jne _inspectLineLoop

			mov byte[win],1

		_3L:
			mov rsi,12
			inc rcx
			lea rbx,[board+rsi]
			mov al,[ebx]
			cmp al," "
			je _inspectLineLoop

			add rsi,2
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectLineLoop

			add rsi,2
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectLineLoop

			mov byte[win],1

_inspectColumn:
	mov rcx,0

	_inspectColumnLoop:
		cmp rcx,0
		je _1C

		cmp rcx,1
		je _2C

		cmp rcx,2
		je _3C

		call _inspectDiagonal
		ret

		_1C:
			mov rsi,0
			inc rcx
			lea rbx,[board+rsi]
			mov al,[rbx]
			cmp al," "
			je _inspectColumnLoop

			add rsi,6
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectColumnLoop

			add rsi,6
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectColumnLoop

			mov byte[win],1
		_2C:
			mov rsi,2
			inc rcx
			lea rbx,[board+rsi]
			mov al,[rbx]
			cmp al," "
			je _inspectColumnLoop

			add rsi,6
			lea rbx,[board+rsi] 

			cmp al,[rbx]
			jne _inspectColumnLoop

			add rsi,6
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectColumnLoop

			mov byte[win],1

		_3C:
			mov rsi,4
			inc rcx
			lea rbx,[board+rsi]
			mov al,[rbx]
			cmp al," "
			je _inspectColumnLoop

			add rsi,6
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectColumnLoop

			add rsi,6
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectColumnLoop

			mov byte[win],1

_inspectDiagonal:
	mov rcx,0
	_inspectDiagonalLoop:
		cmp rcx,0
		je _1D

		cmp rcx,1
		je _2D

		ret

		_1D:
			mov rsi,0
			mov rdx,8         ;this is how much is needed to jump to the next diagonal
			inc rcx
			lea rbx,[board+rsi]
			mov al,[rbx]
			cmp al," "
			je _inspectDiagonalLoop

			add rsi,rdx
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectDiagonalLoop

			add rsi,rdx
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectDiagonalLoop

			mov byte[win],1

		_2D:
			mov rsi,4
			mov rdx,4
			inc rcx
			lea rbx,[board+rsi]
			mov al,[rbx]
			cmp al," "
			je _inspectDiagonalLoop

			add rsi,rdx
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectDiagonalLoop

			add rsi,rdx
			lea rbx,[board+rsi]

			cmp al,[rbx]
			jne _inspectDiagonalLoop

			mov byte[win],1

_clrscr:
	mov rax,1
	mov rdi,1
	mov rsi,clr_scr
	mov rdx,cs_size
	syscall
	ret

_gameOver:
	call _clrscr
	
	mov rax,1
	mov rdi,1
	mov rsi,gameOverMsg
	mov rdx,gom_size
	syscall

	mov rax,1
	mov rdi,1
	mov rsi,winMsg
	mov rdx,wm_size
	syscall

	jmp _exit

_exit:
	mov rax,60
	mov rdi,0
	syscall
	
