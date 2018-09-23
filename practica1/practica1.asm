/*-----------------------------------------------------------------
**
**  Fichero:
**    pract1a.asm  08/03/2016
**
**    Fundamentos de Computadores
**    Dpto. de Arquitectura de Computadores y Automática
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Desarrollar un programa en código ensamblador del ARM que divida dos números
**    tamaño palabra A y B y escriba el resultado en el número C mediante restas parciales
**    utilizando el algoritmo del cuadro 4.
**
**  Notas de diseño:
**
**---------------------------------------------------------------*/

.global start
.data
A: 		.word 0x08
B: 		.word 0x02

.bss
C: 	.space 4

.text
start:
		MOV R0, #0
		LDR R1, =C
		LDR R2, =A
		LDR R3, =B
		LDR R4, [R2]
		LDR R5, [R3]
while:	CMP R4, R5
		BLT fin_w
		SUB R4, R4, R5
		ADD R0, R0, #1
		B while
fin_w:	STR R0, [R1]
FIN:	B .

		.end
