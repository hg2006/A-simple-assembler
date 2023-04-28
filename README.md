# Primpl-Assembler
This assembler was done as an assignment question of CS 146, W23 offering, instructed by Brad Lushman, at the University of Waterloo. Relevant assignment is [Q8:Assembler](https://github.com/hg2006/Primpl-Assembler-W23-CS-146/issues/1#issue-1687729289).
## PRIMPL: A primitive imperative language for teaching use
PRIMPL is a virtual machine language designed by the CS 146 instructor team at the University of Waterloo for teaching use, with PRIMPL stands for _"primitive imperative language"_. The instructor also designed a corresponding assembly language for PRIMPL, namely A-PRIMPL. PRIMPL is an intermediate step in the course after the thorough discussion of C, and an instructor-designed imperative language: SIMPL (given that the grammar of language is very simple and it supports very little features). This will lead to the next language introduced in the course, MMIX.
<br> <br>
This project is about writing an assembler from A-PRIMPL to PRIMPL, completed as an assignment question of CS 146, W23 offering. No starter code has been given except for the [PRIMPL simulator](PRIMPL.rkt), which was for the use of helping understand the core of PRIMIPL as well as facilitating debugging process. Considering its difficulty, the instructor team has allowed this assignment to be completed in pairs.

## Grammar of Primpl (In Haskell)
program	 	=	 	stmt-or-value ... <br>
 	 	 	 	 
  stmt	 	=	 	(add dest opd opd) <br>
 	 	|	 	(sub dest opd opd)
 	 	|	 	(mul dest opd opd)
 	 	|	 	(div dest opd opd)
 	 	|	 	(mod dest opd opd)
 	 	|	 	(gt dest opd opd)
 	 	|	 	(ge dest opd opd)
 	 	|	 	(lt dest opd opd)
 	 	|	 	(le dest opd opd)
 	 	|	 	(equal dest opd opd)
 	 	|	 	(not-equal dest opd opd)
 	 	|	 	(land dest opd opd)
 	 	|	 	(lor dest opd opd)
 	 	|	 	(lnot dest opd)
 	 	|	 	(jump opd)
 	 	|	 	(branch opd opd)
 	 	|	 	(move dest opd)
 	 	|	 	(print-val opd)
 	 	|	 	(print-string string)
 	 	 	 	 
  opd	 	=	 	imm
 	 	|	 	ind
 	 	|	 	(imm ind)
 	 	 	 	 
  dest	 	=	 	ind
 	 	|	 	(imm ind)
 	 	 	 	 
  imm	 	=	 	integer
 	 	|	 	boolean
 	 	 	 	 
  ind	 	=	 	(nat)
