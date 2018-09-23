/*--------------------------------------------------------------
**
**      EJERCICIO OPCIONAL DE CLASE PARA SUBIR NOTA
**      ALGORITMO DE ORDENACIÓN - MÉTODO DE LA BURBUJA MEJORADO
**      DESARROLLADO POR DAVID ARROYO
**
**--------------------------------------------------------------/

.global start

.EQU N, 9
.EQU TRUE, 1
.EQU FALSE, 0

.data
V:	.word 7,3,25,4,75,2,1,1

.text
start:
loop:		MOV R0, #FALSE			@Inicializo swapped a false
			MOV R1, #0			@i = 0
			MOV R2, #N			@Llevamos N a un registro
			SUB R3, R2, #2		@N - 2 (Recorrido del for)
for:		CMP R1, R3
			BGT end_for
			LDR R4, =V			@Dirección de comienzo del array
			LDR R5, [R4, R1, LSL #2]			@Llevamos V[i] a registro
			ADD R6, R1, #1			@i + 1
			LDR R7, [R4, R6, LSL #2]			@Llevamos V[i + 1] a registro
			CMP R5, R7
			BLE end_if
			LDR R8, [R4, R6, LSL #2]			@Salvo V[i + 1] para no perderlo
			STR R5, [R4, R6, LSL #2]			@Swap de V[i] a V[i + 1]
			STR R8, [R4, R1, LSL #2]			@Swap de V[i + 1] a V[i]
			MOV R0, #TRUE			@swapped = true
			ADD R1, R1, #1			@i++
			B for
end_if:		ADD R1, R1, #1			@i++
			B for
end_for:	MOV R1, #0			@i = 0 de nuevo
			CMP R0, #TRUE		@while(swapped)
			BEQ loop
			B FIN
FIN:		B .
			.end
