DATAS SEGMENT
    
    BUF1 	DB	'I am a boy.',0dh,0ah,'$' 
	BUF2		DB	0ah
	num1	DB	0
	num2	DB	0
	num3	DB	0
	num4	DB	0

	STR1	DB	'The number of the letter: ','$'
	STR2	DB	'The number of the alphabet: ','$'
	STR3	DB	'The number of ENTER: ','$'  
	STR4	DB	0dh,0ah,'$'
LEN = $-BUF1
DATAS ENDS

STACKS SEGMENT
    DB 200 dup(0H)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX, DATAS
    MOV DS, AX
    
    LEA DX, BUF1
    MOV AH, 09H
    INT 21H
    ;output the sentence

	MOV AX, STACKS
	MOV SS, AX
	MOV SP, 100
	
	MOV SI, OFFSET BUF1
	MOV CX, LENGTH BUF1
	
	again:
		;CMP AL, 0dh
		;JZ printSTR
		CMP BYTE PTR[SI], '&'
		JE exit

		CMP BYTE PTR[SI], 41H
		JB L1
		CMP BYTE PTR[SI], 5AH
		JBE L3
		
		CMP BYTE PTR[SI], 61H
		JB L1
		CMP BYTE PTR[SI], 7AH
		JBE L4

	L1:
		inc num4
		JMP L5
	L3:
		inc num1
		JMP L5
	L4:
		inc num2
		JMP L5
	L5:
		ADD SI, 1
		LOOP again
	
	LEA DX, STR1
	MOV AH, 09H
	INT 21H
	MOV BL, num1
	call disp
	LEA DX, STR4
	MOV AH, 09H
	INT 21H

	LEA DX, STR2
	MOV AH, 09H
	INT 21H
	MOV BL, num2
	call disp
	LEA DX, STR4
	MOV AH, 09H
	INT 21H

	LEA DX, STR3
	MOV AH, 09H
	INT 21H
	MOV BL, num4
	call disp
	LEA DX, STR4
	MOV AH, 09H
	INT 21H

	exit:
		MOV AH, 4CH
		INT 21H

	disp PROC
	MOV CH, 4

		roll:
			MOV CL, 4
			ROL BX, CL
			MOV DL, BL
			AND DL, 0FH
			CMP DL, 09H
			JBE next1
			ADD DL, 07H
		
		next1:
			ADD DL, 30H
			MOV AH, 02H
			INT 21H
			DEC CH
			JNZ roll

		ret
	disp ENDP
		
CODES ENDS
END START
