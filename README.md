# Primpl-Assembler
This assembler was done as an assignment question of CS 146, W23 offering, instructed by Brad Lushman, at the University of Waterloo. Relevant assignment is [Q8:Assembler](https://github.com/hg2006/Primpl-Assembler-W23-CS-146/issues/1#issue-1687729289).
## PRIMPL: A primitive imperative language for teaching use
PRIMPL is a virtual machine language designed by the CS 146 instructor team at the University of Waterloo for teaching use, with PRIMPL stands for _"primitive imperative language"_. The instructor also designed a corresponding assembly language for PRIMPL, namely A-PRIMPL. PRIMPL is an intermediate step in the course after the thorough discussion of C, and an instructor-designed imperative language: SIMPL (given that the grammar of language is very simple and it supports very little features). This will lead to the next language introduced in the course, MMIX.
<br> <br>
This project is about writing an assembler from A-PRIMPL to PRIMPL, completed as an assignment question of CS 146, W23 offering. No starter code has been given except for the [PRIMPL simulator](PRIMPL.rkt), which was for the use of helping understand the core of PRIMIPL as well as facilitating debugging process. Considering its difficulty, the instructor team has allowed this assignment to be completed in pairs.

## Grammar of Primpl (In Haskell)
program	 	=	 	stmt-or-value ... <br>
 	 	 	 	 
  stmt	 	=	 	(add dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(sub dest opd opd) <br>
 	&emsp;&emsp; 	|	 	(mul dest opd opd) <br>
 	&emsp;&emsp;	|	 	(div dest opd opd) <br>
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
 	 	 	 	 
  opd	 	=	 	imm<br>
 	&emsp;&emsp; 	|	 	ind<br>
 	&emsp;&emsp; 	|	 	(imm ind)<br>
 	 	 	 	 
  dest	 	=	 	ind<br>
 	&emsp;&emsp; 	|	 	(imm ind)<br>
 	 	 	 	 
  imm	 	=	 	integer<br>
 	&emsp;&emsp; 	|	 	boolean<br>
 	 	 	 	 
  ind	 	=	 	(nat) <br>
  e.g. 12 means 12, and (12) means to fetch the value at memory location 12
