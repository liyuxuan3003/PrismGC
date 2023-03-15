Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=4
Stack_Mem       SPACE   Stack_Size
__initial_sp
	
Heap_Size       EQU     0x00000400

                AREA    HEAP, NOINIT, READWRITE, ALIGN=4
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors     DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     0			              ; NMI Handler
                DCD     0				          ; Hard Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0			              ; SVCall Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0            			  ; PendSV Handler
                DCD     0          				  ; SysTick Handler
                DCD     KEY0_Handler              ; IRQ0 Handler
			  DCD     KEY1_Handler              ; IRQ1 Handler
			  DCD     KEY2_Handler              ; IRQ2 Handler
			  DCD     KEY3_Handler              ; IRQ3 Handler

                AREA    |.text|, CODE, READONLY

; Reset Handler

Reset_Handler   PROC
                GLOBAL  Reset_Handler
			  ENTRY
                IMPORT  __main
                LDR     R0, =__main
			  MOV     R8, R0
                MOV     R9, R8
                BX      R0
                ENDP
 
 ; complete IRQ_Handler function here

KEY0_Handler PROC
             EXPORT KEY0_Handler            [WEAK]
             IMPORT KEY0
             PUSH {R0,R1,R2,LR}
             BL KEY0
             POP {R0,R1,R2,PC}
             ENDP
				 
KEY1_Handler PROC
             EXPORT KEY1_Handler            [WEAK]
             IMPORT KEY1
             PUSH {R0,R1,R2,LR}
             BL KEY1
             POP {R0,R1,R2,PC}
             ENDP
				 
KEY2_Handler PROC
             EXPORT KEY2_Handler            [WEAK]
             IMPORT KEY2
             PUSH {R0,R1,R2,LR}
             BL KEY2
             POP {R0,R1,R2,PC}
             ENDP
				 
KEY3_Handler PROC
             EXPORT KEY3_Handler            [WEAK]
             IMPORT KEY3
             PUSH {R0,R1,R2,LR}
             BL KEY3
             POP {R0,R1,R2,PC}
             ENDP
	 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                ALIGN 4

				IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap

__user_initial_stackheap 

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR
     
                ALIGN 

				ENDIF
					
                END