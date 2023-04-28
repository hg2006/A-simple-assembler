# Primpl-Assembler
This assembler was done as an assignment question of CS 146, W23 offering, instructed by Brad Lushman, at the University of Waterloo. Relevant assignment is [Q8:Assembler](https://github.com/hg2006/Primpl-Assembler-W23-CS-146/issues/1#issue-1687729289).
## __Table of Contents__
- [Motivation & Simulation of PRIMIPL](#motivation-and-simulation-of-primpl)
- [Some Lies about PRIMPL](#some-lies)
- [The Project](#the-project)
- [Grammar and Other Details of PRIMPL](#grammar-and-other-details-of-primpl)
- [An Example Program in A-PRIMPL and PRIMPL](#an-example-program-in-a-primpl-and-primpl)

## Motivation and Simulation of PRIMPL
PRIMPL is a virtual machine language designed by the CS 146 instructor team at the University of Waterloo for teaching use, with PRIMPL stands for _"primitive imperative language"_. The instructor also designed a corresponding assembly language for PRIMPL, namely A-PRIMPL. PRIMPL is an intermediate step in the course after the thorough discussion of C, and an instructor-designed imperative language: SIMPL (given that the grammar of language is very simple and it supports very little features). This will lead to the next language introduced in the course, MMIX.
<br> <br>
Modern computers put both programs and data into memory. To approach this situation, a vector ("array" in Racket) will be used as the main data structure of PRIMPL, to hold both the program and its data. We will call this vector "PRIMPL memory" (or just "memory" at times). The program will be able to change the data in PRIMPL memory through mutation, it can also potentially change itself (this will not happen in the assignment though). As above, it's convenient enough to make a simulator using Racket vector, with each slot of the vector holding one instruction or data.
<br> <br>
## Some lies
Note there are still some remaining "higher-level" features of PRIMPL that makes it "unrealistic" as it's supposed to be a machine language. For one thing, locations have fixed size (32 or 64 bits) but PRIMPL pretends they do not. Also, PRIMPL still supports unbounded integers for teaching convenience. Another element of PRIMPL that's not usually seen among low-level languages is that printing is given free as an instruction, again, for the convenience.
<br> <br>
## The Project
This project is about writing an assembler from A-PRIMPL to PRIMPL, completed as an assignment question of CS 146, W23 offering. No starter code has been given except for the [PRIMPL simulator](PRIMPL.rkt), which was for the use of helping understand the core of PRIMIPL as well as facilitating debugging process. Considering its difficulty, the instructor team has allowed this assignment to be completed in pairs.
<br><br>

## Grammar and Other Details of PRIMPL 

1. PC (Program Counter) <br>
PC is a variable that holds the location of the next instruction to be executed. It is assumed to be a separate variable outside of the RAM (This corresponds to the fact that the role of PC is played by a special register). 

2. Operands <br>
For operands, we need to distinguish between 12 and fetch (12). <br>
We will define 12 as referring to number 12, and (12) as fetching the value at location 12.  <br>

3. Operations <br>
Regular op: add sub mul div mod equal not-equal gt ge lt le land lor lnot <br>
e.g. (add (15) (11) (12)) => "M\[15] (value at memory location 15) <- M\[11] + M\[12]" <br>
&emsp; &ensp; (add (15) (11) 1) => "M\[15] <- M\[11] + 1" <br>

4. Move <br>
(move (10) (12)) => "M\[10] <- M\[12]" <br>

5. Jump & Branch <br>
(jump 12) => "PC <- 12" <br>
(branch (20) 12) "if M\[20]then PC <- 12" <br>

6. Print <br>
(print-val 21) <br>
(print (15)) <br>
(print-string "\n") <br> <br>

The following grammar tree of PRIMPL is provided in Haskell <br> <br>
program	 	=	 	stmt-or-value ... <br>
 	 	 	 	 
  stmt	 	=	 	(add dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(sub dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(mul dest opd opd) <br>
 	&emsp;&emsp;	 |	 	(div dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(mod dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(gt dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(ge dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(lt dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(le dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(equal dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(not-equal dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(land dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(lor dest opd opd)<br>
 	&emsp;&emsp; 	|	 	(lnot dest opd)<br>
 	&emsp;&emsp; 	|	 	(jump opd)<br>
 	&emsp;&emsp; 	|	 	(branch opd opd)<br>
 	&emsp;&emsp; 	|	 	(move dest opd)<br>
 	&emsp;&emsp; 	|	 	(print-val opd)<br>
 	&emsp;&emsp; 	|	 	(print-string string)<br>
 	 	 	 	 
  opd	 	=	 	imm <br>
 	&emsp;&emsp; 	|	 	ind<br>
 	&emsp;&emsp; 	|	 	(imm ind) <br>
 	 	 	 	 
  dest	 	=	 	ind<br>
 	&emsp;&emsp; 	|	 	(imm ind)<br>
 	 	 	 	 
  imm	 	=	 	integer<br>
 	&emsp;&emsp; 	|	 	boolean<br>
 	 	 	 	 
  ind	 	=	 	(nat) <br>
  <br>
  
  ## A-PRIMPL: The Assembly Language for PRIMPL
 As the assembly language for PRIMPL, A-PRIMPL supports some high-level features to facilitate coding. These features provided in A-PRIMPL can make the process of compiling even higher level language to A-PRIMPL significantly easier (this compiler is also [available here]), and we can subsequently use this assembler to convert the code into PRIMPL.
 The A-PRIMPL grammar has the above rules, with every occurrence of ```imm``` replaced by ```psymbol-or-imm```, which means that either a PRIMPL ```operand``` or a ```psymbol```  (PRIMPL symbol) can be used. A ```psymbol``` satisfies the same spelling rules as a Racket symbol but has no explicit apostrophe. We do the same thing for ind. <br> <br>
 A-PRIMPL also adds the following grammmar rules for pseudo-instructions: <br> <br>
  stmt	 	=	 	(halt) <br>
  stop the program, just produce 0 in PRIMPL <br> <br>
 		&emsp;&emsp; |	 	(lit psymbol-or-value) <br>
   "literal": E.g. (lit 4) means to insert value 4 here (for readability) <br> <br>
 	 &emsp;&emsp;	|	 	(const psymbol psymbol-or-value) <br>
   creates a psymbol with the given name, and value 6 <br>
   does not generate an entry in PRIMPL Array<br>
   acts like macro #define in C. For example, (const A 6) would replace all occurrenecs of A with 6 <br> <br>
 		&emsp;&emsp; |	 	(data psymbol psymbol-or-value ...) <br>
   E.g. (data A 1 2 3 4), here A has the value of the index of the memory vector location where the first data item (the 1) is stored, and can be used in place of any indirect operand. The following data items (2, 3, and 4) are stored in consecutive memory locations following the first one. 
   If (data A 1 2 3 4) is the fifth instruction in A-PRIMPL, then 1 will be placed on the fifth memory vector location in PRIMPL, 2 on the sixth, and so on. All occurrences of A will be replaced by 5, which is the place for 1. <br> <br>
 	 &emsp;&emsp;	|	 	(data psymbol (nat psymbol-or-value)) <br>
  (data A (5 1)) is equivalent to (data A 1 1 1 1 1) <br> <br>
 	 &emsp;&emsp;	|	 	(label psymbol) <br>
   no entry in PRIMPL array <br>
   E.g. (label A), the psymbol A is bound to the index of the memory vector where the next actual instruction would be loaded, and we can subsequently use psymbols labelled as targets for branch & jump. <br> <br> 
Please refer to [Q8:Assembler](https://github.com/hg2006/Primpl-Assembler-W23-CS-146/issues/1#issue-1687729289) for further details and restrictions on the use of psymbols in A-PRIMPL.

## An Example Program in A-PRIMPL and PRIMPL
This A-PRIMPL program below calculates and prints the powers of 2, from 1 to 10: <br>
```racket 
    '((gt (11) (9) 0)    ; 0: tmp1 <- x > 0
    (branch (11) 3)      ; 1: if tmp1 goto 3
    (jump 8)             ; 2: goto 8
    (mul (10) 2 (10))    ; 3: y <- 2 * y
    (sub (9) (9) 1)      ; 4: x <- x - 1
    (print-val (10))     ; 5: print y
    (print-string "\n")  ; 6: print "\n"
    (jump 0)             ; 7: goto 0
     0                   ; 8: 0 [number, halts program]
     10                  ; 9: x
     1                   ; 10: y
     0)                  ; 11: tmp1 
 ```
 
 The PRIMPL program below is produced by assmbling the A-PRIMPL code above using [our program](...)
 ```racket
  (gt (11) (9) 0)      ; 0: tmp1 <- x > 0
  (branch (11) 3)      ; 1: if tmp1 goto 3
  (jump 8)             ; 2: goto 8
  (mul (10) 2 (10))    ; 3: y <- 2 * y
  (sub (9) (9) 1)      ; 4: x <- x - 1
  (print-val (10))     ; 5: print y
  (print-string "\n")  ; 6: print "\n"
  (jump 0)             ; 7: goto 0
   0                   ; 8: 0 [number, halts program]
   10                  ; 9: x
   1                   ; 10: y
   0                   ; 11: tmp1
 ```
 
 
     

     
     

