// Simple but not so simple to beat logic based AI interpretation to result in gambling, Human vs CPU

section .data

start_New: db "Welcome to 21 Movie Effect!\n\0"
_own:      db"_you currently have $\0"
_bet:      db"Enter your _bet: $\0"
_you:      db"_you rolled a: \0"
_comp:     db"_comp rolled a: \0"
_win:      db"_you _win!\n\n\0"
_win1:     db"Victory belongs to the most persevering!\n\n\0"
_win2:
	.ascii"Another _win in the books.\n\n\0"
_lose: 
	.ascii"_you _lose.\n\n\0"
_lose1:
	.ascii"_you messed up :(\n\n\0"
_lose2:
	.ascii"_you need to pick up your game.\n\n\0"
_tie:
	.ascii"_you tied!\n\n\0"
_done:
	.ascii"Looks like _you ran out of money.\nThanks for playing!\n\0"
_invalid:
	.ascii"Put some real money down! Try a positive number:\n\0"
_balance:

	.long 100
_new:
	.ascii"\n\0"

section.text
	global _start

_start:
	mov $6, %eax
	call VTSetForeColor 
	mov $start_New, %eax
        call PrintStringC
	mov $7, %eax
	call VTSetForeColor 

_loop:
	mov $_own, %eax	
	call PrintStringC
	mov _balance, %eax
	call PrintInt
	mov %eax, _balance 

	mov $_new, %eax
	call PrintStringC

	mov $_bet, %eax
	call PrintStringC

	call ScanInt
	cmp $1, %eax
	jge _solid 
	mov $_invalid, %eax
	call PrintStringC
	call ScanInt
	
_solid:
	mov %eax, %edx		#_bet is in EDX

	mov $_you, %eax		#_you roll 
	call PrintStringC	
	mov $6, %eax 
	call Random 		#runs dice1
	mov %eax, %ebx
	mov $6, %eax
	call Random		#runs dice 2
	add %ebx, %eax	 	#adds dice
	call PrintInt
	mov %eax, %ebx  	#I am now EBX
	
	mov $_new, %eax 		#newline
	call PrintStringC	
	
	mov $_comp, %eax		#_comp rolls
	call PrintStringC		
	mov $6, %eax
	call Random		#call dice1
	mov %eax, %ecx
	mov $6, %eax
	call Random		#call dice2
	add %ecx, %eax		#adds dice
	call PrintInt
	mov %eax, %ecx  	#_comp has ECX	

	mov $_new, %eax
	call PrintStringC

	cmp %ecx, %ebx		# ebx(me) > ecx(_comp) jump lower
	jl _Sub 	
	je _Tie
	
	mov $2, %eax		#color green
	call VTSetForeColor 
	mov $5, %eax
	call Random
	cmp $1, %eax
	jl _W1
	jg _W2
	je _W
_W:
	mov $_win, %eax		#winner logic
	call PrintStringC
	jmp _Next
_W1:	
	mov $_win1, %eax
	call PrintStringC
	jmp _Next	
_W2:	
	mov $_win2, %eax
	call PrintStringC
_Next:	
	mov $7, %eax		#color white
	call VTSetForeColor 
	add %edx, _balance 
	cmp $1, _balance
	jge _loop

_Tie:				#TIED
	mov $5, %eax
        call VTSetForeColor 
	mov $_tie, %eax
	call PrintStringC
	mov $7, %eax
        call VTSetForeColor 
	cmp $1, _balance
	jge _loop	
		
_Sub:
	mov $1, %eax		#red
	call VTSetForeColor 
	mov $5, %eax
	call Random
	cmp $2, %eax
	jl _L1
	jg _L2
	je _L
_L:
	mov $_lose, %eax          #winner logic
        call PrintStringC
        jmp _Next1
_L1:
        mov $_lose1, %eax
        call PrintStringC
        jmp _Next1
_L2:
        mov $_lose2, %eax
        call PrintStringC
_Next1:				#loser logic begins
	mov $7, %eax		#white
        call VTSetForeColor 
	sub %edx, _balance
	cmp $0, _balance
	jg _loop
	

_Done:
	mov $6, %eax		#cyan color
        call VTSetForeColor 
	mov $_done, %eax
	call PrintStringC
	mov $7, %eax		#white color
        call VTSetForeColor 	
	call EndProgram

