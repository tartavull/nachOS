/*
GOAL: Blink the LED of our Raspberry Pi Zero.

*/
.section .init
.globl _start
_start:

//STEP 1: Set GPIO47 as an output.
ldr r0,=0x20200010
ldr r1,=0x1
lsl r1,#21
str r1,[r0]

loop$:
/* 
Creating an infinite loop is really easy.
The last instruction ("b loop$") will make 
the execution branch back to here 
identation is just to improve redability*/
    

    //Turn On LED
    ldr r0,=0x2020002C
    ldr r1,=0x1
    lsl r1,#15
    str r1,[r0]

    /*
    Wait
    To create a delay, we busy the processor on a pointless quest to 
    decrement the number 0xFF0000 to 0. Which takes around a second.
    We fist substract 1 from register 2.
    We later compare r2 with 0, which result is placed in an special register.
    We branch if the special register holds false.
    */
    mov r2,#0xFF0000
    wait1$:
      sub r2,#1
      cmp r2,#0
      bne wait1$


    //Turn Off LED
    ldr r0,=0x20200020
    ldr r1,=0x1
    lsl r1,#15
    str r1,[r0]


    // Wait one more time
    mov r2,#0xFF0000
    wait2$:
      sub r2,#1
      cmp r2,#0
      bne wait2$

b loop$
