# Primpl-Assembler
This assembler was done as an assignment question of CS 146, W23 offering, instructed by Brad Lushman, at the University of Waterloo. Relevant assignment is [Q8:Assembler](https://github.com/hg2006/Primpl-Assembler-W23-CS-146/issues/1#issue-1687729289).
## PRIMPL: A primitive imperative language for teaching use
PRIMPL is a virtual machine language designed by the CS 146 instructor team at the University of Waterloo for teaching use, with PRIMPL stands for _"primitive imperative language"_. The instructor also designed a corresponding assembly language for PRIMPL, namely A-PRIMPL. PRIMPL is an intermediate step in the course after the thorough discussion of C, and an instructor-designed imperative language: SIMPL (given that the grammar of language is very simple and it supports very little features). This will lead to the next language introduced in the course, MMIX.
<br> <br>
Modern computers put both programs and data into memory. To approach this situation, a vector ("array" in Racket) will be used as the main data structure of PRIMPL, to hold both the program and its data. We will call this vector "PRIMPL memory" (or just "memory" at times). The program will be able to change the data in PRIMPL memory through mutation, it can also potentially change itself (this will not happen in the assignment though). As above, it's convenient enough to make a simulator using Racket vector, with each slot of the vector holding one instruction or data.
<br> <br>
Note there are still some remaining "higher-level" features of PRIMPL that makes it "unrealistic" as it's supposed to be a machine language. For one thing, locations have fixed size (32 or 64 bits) but PRIMPL pretends they do not. Also, PRIMPL still supports unbounded integers for teaching convenience. Another element of PRIMPL that's not usually seen among low-level languages is that printing is given free as an instruction, again, for the convenience.
<br> <br>
This project is about writing an assembler from A-PRIMPL to PRIMPL, completed as an assignment question of CS 146, W23 offering. No starter code has been given except for the [PRIMPL simulator](PRIMPL.rkt), which was for the use of helping understand the core of PRIMIPL as well as facilitating debugging process. Considering its difficulty, the instructor team has allowed this assignment to be completed in pairs.

## Grammar and other details of Primpl (Grammar Provided In Haskell)

1. PC (Program Counter) <br>
PC is a variable that holds the location of the next instruction to be executed. It is assumed to be a separate variable outside of the RAM (This corresponds to the fact that the role of PC is played by a special register). 

2. Operands <br>
For operands, we need to distinguish between 12 and fetch (12). <br>
We will define 12 as referring to number 12, and (12) as fetching the value at location 12.  <br>

3. Operations <br>
Regular op: add sub mul div mod equal not-equal gt ge lt le land lor lnot <br>
e.g. (add (15) (11) (12)) => "M\[15] (value at memory location 15) <- M\[11] + M\[12]" <br>
&emsp; (add (15) (11) 1) => "M\[15] <- M\[11] + 1" <br>

4. Move <br>
(move (10) (12)) => "M\[10] <- M\[12]" <br>

5. Jump & Branch <br>
(jump 12) => "PC <- 12"
(branch (20) 12) "if M\[20]then PC <- 12"

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
