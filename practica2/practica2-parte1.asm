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
**		Codificar en ensamblador del ARM el siguiente código C, encargado de buscar el valor
**		máximo de un vector de enteros positivos A de longitud N y almacenarlo en la variable
**		max.
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
max:	.space 4

.text
start:
		MOV R0, #0
		LDR R1, =max // Leo la dirección de máx.
		STR R0, [r1] // Escribo 0 en máx.
		LDR R2, =A // Guardamos la dirección donde comienza el array
		MOV R3, #0 // Inicializamos i a 0
for: 	CMP R3, #N
		BGE fin_for
		/* Leemos el i-ésimo elemento del array
		y lo almacenamos en R4 */
		LDR R4, [R2, R3, LSL #2]
		LDR R0, [R1] // Guardamos el valor de máx.
		ADD R3, R3, #1 // Actualizamos i
		CMP R4, R0
		BLE for
		STR R4, [R1] // Actualizamos máx.
		B for
fin_for:
FIN:	B .
		.end
		