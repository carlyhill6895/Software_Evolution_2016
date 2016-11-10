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
	for(/\s*[^\s]+\s*(\n|\Z)/ := src){
		amountLines += 1;
	}
	for(/(\n|\A)<prefix:.*>\\\*<comment:(.|\n)*>\*\\<postfix:.*>(\n|\Z)/ := src){
		//newlines = for(/\s*[^\s]+\s*\n/ := comment){ newlines++; }
		//if(newlines == 0 && (/^\s*$/ := prefix && /^\s*$/ := postfix))
		if(/^\s*$/ := prefix){
			amountLines -= 1;
		}
		for(/\s*[^\s]+\s*\n/ := comment){
			amountLines -= 1;
		}
		if(/^(\s|\/\/.*|\\\*.*)+$/ := postfix){
			amountLines -= 1;
		}
	}
	for(/(\n|\A)\s*\/\// := src) {
		amountLines -= 1;
	}
	return amountLines;
}
