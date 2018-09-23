/*--------------------------------------------------------------
**
**      EJERCICIO OPCIONAL DE CLASE PARA SUBIR NOTA
**      PRÁCTICA 3 - FUNDAMENTOS DE COMPUTADORES
**      DESARROLLADO POR DAVID ARROYO
**
**--------------------------------------------------------------/

.extern _stack
.global start
.equ N, 8
.data
A:	.word 7,3,5,4,6,2,1,1
.bss
B:		.space N*4
F:		.space N*4
max: 	.space 4
ind:	.space 4

.text
start:
			ldr sp, =_stack		@ Stack Pointer
			mov fp, #0		@ Frame Pointer = 0
			mov r1, #N		@ Longitud del array A[] y B[]
			mov r4, #0		@ j = 0

for_ext:
			ldr r0, =A		@ Puntero al comienzo del array A[]
			cmp r4, #N
			bge fin_for_ext
			bl int_max		@ int max(A, N) -> Subrutina devuelve posición máximo
			mov r5, r0		@ ind = max(A, N)
			ldr r6, =A
			ldr r7, [r6, r5, LSL #2]		@ A[ind]
			ldr r8, =B
			str r7, [r8, r4, LSL #2]		@ B[j] = A[ind]
			/* CALCULAMOS EL FACTORIAL DE B[j] */
			ldr r7, =F
			ldr r9, [r8, r4, LSL #2]		@ Nos traemos B[j]
			mov r0, r9			@ Parámetro de factorial(num)
			bl factorial		@ r0 = factorial(num)
			str r0, [r7, r4, LSL #2]		@ F[j] = factorial(num)
			/* FIN de CALCULAR FACTORIAL */
			mov r9, #0
			str r9, [r6, r5, LSL #2]		@ A[ind] = 0
			add r4, r4, #1
			b for_ext
fin_for_ext:
			b .

int_max:
			push {r4-r9,fp}		@ PRÓLOGO DE LA SUBRUTINA
			add fp, sp, #24		@ 24 = 4 * 7 - 4
			mov r4, r0			@ Punto de inicio del array A[]
			mov r5, #0			@ i = 0
			ldr r6, =max
			mov r7, #0
			str r7, [r6]		@ max = 0
			ldr r8, =ind
			str r7, [r8]		@ ind = 0
for:
			cmp r5, r1
			bge fin_for
			ldr r7, [r4, r5, LSL #2]		@ A[i]
			ldr r9, [r6]		@ Llevamos a r9 el max
			cmp r7, r9		@ if (A[i] > max)
			ble fin_if
			str r7, [r6]		@ max = A[i]
			str r5, [r8]		@ ind = i
			add r5, r5, #1		@ i++
			b for
fin_if:
			add r5, r5, #1		@ i++
			b for
fin_for:
			ldr r4, [r8]
			mov r0, r4		@ return(ind)
			b Return
Return:
			pop {r4-r9,fp}		@ EPÍLOGO DE LA SUBRUTINA
			mov pc, lr

factorial:
			push {r4-r7,fp}
			add fp, sp, #8		@ 16 = 4 * 5 - 4
			mov r4, r0		@ num
			mov r5, #1		@ factorial = 1
			mov r6, #1		@ i = 1
for_fact:
			cmp r6, r4
			bgt fin_for_fact
			mov r7, r5		@ mul = factorial
			mul r5, r6, r7		@ factorial = i * mul
			add r6, r6, #1		@ i++
			b for_fact
fin_for_fact:
			mov r0, r5
			b ReturnF
ReturnF:
			pop {r4-r7,fp}
			mov pc, lr

			.end
