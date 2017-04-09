/*
GOAL: Turn on the LED of our Raspberry Pi Zero.
 
The LED is postioned next to power USB and is label as ACT.
The board has 54 general-purpose I/O (GPIO) lines the LED is attached to the
line 47.

section is a directive to our assembler telling it to place this code first.
globl is a directive to our assembler, that tells it to export this symbol
to the elf file. Convention dictates that the symbol _start is used for the 
entry point, so this all has the net effect of setting the entry point here.
Ultimately, this is useless as the elf itself is not used in the final 
result, and so the entry point really doesn't matter, but it aids clarity,
allows simulators to run the elf, and also stops us getting a linker warning
about having no entry point. 
*/
.section .init
.globl _start
_start:

/*#STEP 1: Set GPIO47 as an output.

Physical addresses range from 0x20000000 to 0x20FFFFFF for peripherals.
There are  split into two banks.

Most GPIO lines can have many functions (up to 6) like being an input, or an output or
some serial communication like UART.

The first step is to tell the GPIO controller which is the function of the line.
To do so, we need to write a 32bit value to a given address which depdends on the line numbers.
line  0 to 9  writes to 0x20200000(GPFSEL0)
line 10 to 19 writes to 0x20200004(GPFSEL1)
line 20 to 29 writes to 0x20200008(GPFSEL2)
line 30 to 39 writes to 0x2020000C(GPFSEL3)
line 40 to 49 writes to 0x20200010(GPFSEL4)
line 50 to 53 writes to 0x20200014(GPFSEL5)

We are trying to blink the LED which is in on line 47, so let's load that address in the first register.
*/
ldr r0,=0x20200010
/*
Now we need to find a way to tell the controller that then line 47 is an output.
3 bits are used to do that as follows:
  000 = GPIO line is an input
  001 = GPIO line is an output
  100 = GPIO line takes alternate function 0
  101 = GPIO line takes alternate function 1
  110 = GPIO line takes alternate function 2
  111 = GPIO line takes alternate function 3
  011 = GPIO line takes alternate function 4
  010 = GPIO line takes alternate function 5

We will use 001 so will load that in register 1.
*/
ldr r1,=0x1

/* STEP 2: Set Voltage of GPIO47 to High. 
But there is one more thing to do, because this address is used for all 
lines from 40 to 49 we need to specify which line we are refering to, we do
so by shifting are 3 bits.
0 - 2 bits are for line 40
3 - 5 bits are for line 41
6 - 8 bits are for line 42
9 -11 bits are for line 43
12-14 bits are for line 44
15-17 bits are for line 45
18-20 bits are for line 46
21-23 bits are for line 47
24-26 bits are for line 48
27-29 bits are for line 49

We will shift(in-place) the 3 bits we chose before 21 bits to the left */
lsl r1,#21

// We simply write the register r1 to the address stored in r0
str r1,[r0]

/* Turn On LED
To tell the GPIO controller to set a line to High we we need to write another 32bit number
to a given address wich depends on the line number.
line  0 to 31 writes to 0x20200028(GPCLR0)
line 32 to 53 writes to 0x2020002C(GPSET1)

Thereafter, we load the addres of GPCLR0 to register zero */
ldr r0,=0x2020002C

// We need to write a  1 to tell the controller to clean the line.
ldr r1,=0x1

/* Similarly to what we did for setting the function of the line. we
need to shift the value in r1 because we need to specify which line 
we are refering to.
Given that the first bit refers to line 32,
to clear line 47 we need to shift by 15 (47-32) */
lsl r1,#15
// We simply write the register r1 to the address stored in r0
str r1,[r0]


/* If we wanted to turn off the LED we would had to the exactly the same as before
but instead of writting to GPSET0/GPSET1 we need to write to GPCLR0/GPCLR1
line  0 to 31 writes to 0x2020001c(GPCLR0)
line 32 to 53 writes to 0x20200020(GPCLR1)
*/