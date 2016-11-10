module LinesOfCode

import IO;
import lang::java::m3::Core;

/*
 get the lines of code from a specific source code
*/
int getLinesOfCode(M3 model){
	int linesOfCode= 0;
	for(loc l <- [cl | <cl,_>  <- model@containment, isClass(cl)]){
		str classSrc = readFile(l);
		linesOfCode += getLinesOfClass(classSrc);
	}
	return linesOfCode;
}

int getLinesOfClass(str src){
	int amountLines = 0;
	for(/\n[^\n]/ := src){
		amountLines += 1;
	}
	for(/\*/ := src){
		amountLines -= 1;
	}
	for(/\/\// := src) {
		amountLines -= 1;
	}
	return amountLines;
}