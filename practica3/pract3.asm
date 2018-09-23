/*----------------------------------------------------------------
Int FactorialCorte(int N,int M){
	if (N>M)
		return N*FactorialCorte(N-1,M);
	else
		return M;
}

Codificar una de estas dos versiones de la subrutina, a ser posible la segunda:
1. Haciendo una copia de los parámetros en registros no volátiles, pues se
debe llamar a una subrutina antes de utilizar esta información.
2. Creando una variable local en pila por cada parámetro, como lo haría un
compilador de C.
Implementar un programa que prepare la pila y llame a FactorialCorte(4,2).
-----------------------------------------------------------------*/

.extern _stack
.global start

.data
N:	.word 4
M:	.word 2

.bss
//vacio
.text
start:
	ldr sp, =_stack	//stack pointer (SP)
	mov fp, #0		//frame pointer = 0 (FP)
	ldr r0, =N
	ldr r0, [r0]
	ldr r1, =M
	ldr r1, [r1]
	mov r2, r0
	mov r3, r1
	mov r4, #1

	bl factorial

	str r0, [r1]

fin:	b .

//INICIO SUBRUTINA FACTORIAL
factorial:
	//EPILOGO SUBRUTINA
	mov r4, r0 //N
	mov r1, r5 //M
	push {fp, lr}
	add fp, sp, #4 @ 4*2-4=4

	if: //if (N>M)
		cmp r0, r1
		ble else
		mul r4, r0, r4
		sub r0, r0, #1
		bl factorial


	return1: //return N*FactorialCorte(N-1,M);
		pop {r5}
		mov pc, lr

	else:
		b return2

	return2:
		pop {r4, fp}
		mov pc, lr
	end_if:
//FIN SUBRUTINA FACTORIAL


.end






/*-----------------------------------------------------------------
**
**  Fichero:
**    pract3.asm  10/6/2014
**
**    Fundamentos de Computadores
**    Dpto. de Arquitectura de Computadores y Automática
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Ordena de mayor a menor un vector de enteros positivos
**
**  Notas de diseño:
**    Utiliza una subrutina que devuelve la posición del valor
**    máximo de un vector de enteros positivos
**

Codificar en ensamblador del ARM un algoritmo de ordenación basado en el código
del apartado anterior. Supongamos un vector A de N enteros mayores de 0, queremos
rellenar un vector B con los valores de A ordenados de mayor a menor. Para ello nos
podemos basar en el siguiente código de alto nivel:

#define N 8
int A[N]={7,3,25,4,75,2,1,1};
int B[N];
int j;

void main(){
	for(j=0; j<N; j++){
		ind=max(A,N)
		B[j]=A[ind];
		A[ind]=0;
	}
}

**---------------------------------------------------------------*/

.extern _stack
.global start

.equ N, 8

.data
A:	.word 7,3,25,4,75,2,1,1

.bss
B:		.space N*4

max: 	.space 4
ind:	.space 4

.text
start:
	ldr sp, =_stack	//stack pointer (SP)
	mov fp, #0		//frame pointer = 0 (FP)
	mov r1, #N		//longitud del array A[] y B[]
	mov r4, #0		//j=0

for:
	ldr r0, =A					//puntero al comienzo del array A[]
	cmp r4, #N
	bge end_for
	bl int_max					//int max(A, N) -> Subrutina devuelve posición máximo
	mov r5, r0					//ind = max(A, N)
	ldr r6, =A					//carga la direccion del array B
	ldr r7, [r6, r5, LSL #2]	//A[ind]
	ldr r8, =B					//carga la direccion del array B
	str r7, [r8, r4, LSL #2]	//B[j] = A[ind] guarda el valor mayor en el indice j del array B
	mov r9, #0
	str r9, [r6, r5, LSL #2]	//A[ind] = 0
	add r4, r4, #1				//j++
	b for
end_for:

fin:	b .

//----SUBRUTINA----
int_max: 				//es una subrutina hoja(no tiene subrutinas anidadas)
	push {r4-r9,fp}		//prologo de la subrutina (push --> ldrm)
	add fp, sp, #24		//24 = 4 * 7 - 4
	mov r4, r0			//punto de inicio del array A
	mov r5, #0			//i = 0
	ldr r6, =max
	mov r7, #0			//inicilalizar max
	str r7, [r6]		//max = 0
	ldr r8, =ind		//inicialziar minimo
	str r7, [r8]		//ind = 0

for_subr:
	cmp r5, r1
	bge end_for_subr
	ldr r7, [r4, r5, LSL #2]	//A[i]
	ldr r9, [r6]				//llevamos a r9 el max

	if:
		cmp r7, r9				//condicion --> if (A[i] > max)
		ble end_if
		str r7, [r6]			//max = A[i]
		str r5, [r8]			//ind = i
		add r5, r5, #1			//i++
		b for_subr
	end_if:

	add r5, r5, #1		//i++
	b for_subr
end_for_subr:

	ldr r0, [r8]
	mov r0, r4			//return(ind)
	b Return

Return:
	pop {r4-r9,fp}		//epilogo de la subrutina (pop --> strm)
	mov pc, lr			//salta a la linea 68 (continuacion despues de la subrutina)
//----FIN SUBRUTINA----

.end


/*-----------------------------------------
#define N 4
int A[N]={7,3,25,4};
int B[N];

void Recorre();
int Mayor();

void main(){
	Recorre (A, B, N);
}

void Recorre (int A[], int B[], int M){
	for(int j=0; j<M-1; j++){
		B[j] = Mayor(A[j],A[j+1]);
	}
}
int Mayor(int X, int Y){
	if(X>Y)
		return X;
	else
		return Y;
}
-----------------------------------------*/

.extern _stack
.global start

.equ N, 4

.data
A: .word 7,3,25,4

.bss
B: .space N*4

.text
start:
	ldr sp, =_stack
	mov fp, #0
	ldr r0, =A
	ldr r1, =B
	mov r2, #N
	bl Recorre

	b .

Recorre:
	push {r4-r8,fp,lr}
	add fp, sp, #24 @ 24=4*7-4
	mov r4, r0 @ R4, A
	mov r5, r1 @ R5, B
	sub r6, r2, #1 @ R6, M-1
	mov r7, #0 @ R7, j
for:
	cmp r7, r6
	bge Ret1
	ldr r0, [r4, r7, lsl #2]
	add r8, r7, #1
	ldr r1, [r4, r8, lsl #2]
	bl Mayor
	str r0, [r5, r7, lsl #2]
	add r7, r7, #1
	b for
Ret1:
	pop {r4-r8,fp,lr}
	mov pc, lr

Mayor:
	push {fp}
	mov fp, sp @ SP - 0
	cmp r0, r1
	bgt Ret2
	mov r0, r1
Ret2:
	pop {fp}
	mov pc, lr

.end

