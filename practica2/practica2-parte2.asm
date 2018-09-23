/*-----------------------------------------------------------------
**
**  Fichero:
**    pract2a.asm  06/04/2016
**
**    Fundamentos de Computadores
**    Dpto. de Arquitectura de Computadores y Automática
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**		Codificar en ensamblador del ARM un algoritmo de ordenación basado en el código
**		del apartado anterior. Supongamos un vector A de N enteros mayores de 0, queremos
**		rellenar un vector B con los valores de A ordenados de mayor a menor. Para ello nos
**		podemos basar en el siguiente código de alto nivel.
**
**  Notas de diseño:
**		Desarrollado por David Arroyo
**
**---------------------------------------------------------------*/

.global start

.EQU N, 8

.data
A:	.word 7,3,25,4,75,2,1,1

.bss
B:	.space N*4
max:	.space 4
ind:	.space 4

.text
start:
			MOV R0, #0 // Índice i
			MOV R1, #0 // Índice j
			LDR R2, =A
			LDR R3, =B
			LDR R4, =max
			LDR R5, =ind
for_uno:	CMP R1, #N
			BGE fin_for_uno
			MOV R6, #0
			STR R6, [R4] // Ponemos máx. a 0
for_dos:	CMP R0, #N
			BGE fin_for_dos
			LDR R6, [R2, R0, LSL #2] // Traemos posición array a registro
			LDR R7, [R4] // Traemos max. a registro
			CMP R6, R7
			BLE fin_if
			STR R6, [R4] // Actualizamos máx
			STR R0, [R5] // Actualizamos ind
fin_if:		ADD R0, R0, #1 // i++
			B for_dos
fin_for_dos:MOV R0, #0 // El índice i vuelve a 0
			LDR R6, [R5] // Nos traemos ind
			LDR R7, [R2, R6, LSL #2] // Sacamos A[ind]
			STR R7, [R3, R1, LSL #2] // Llevamos a B[j] el valor de A[ind]
			MOV R7, #0
			STR R7, [R2, R6, LSL #2] // A[ind] vuelve a 0
			ADD R1, R1, #1 // j++
			B for_uno
fin_for_uno:
FIN:		B .
			.end
			