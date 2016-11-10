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
		linesOfCode += getLinesOfSrc(classSrc);
	}
	return linesOfCode;
}

/*
	give back the rank based on the Sig maintainability model (as defined on http://docs.sonarqube.org/display/SONARQUBE45/SIG+Maintainability+Model+Plugin)
*/
str getRankLinesOfCode(int linesOfCode){
	str rank = "";
	
	if(linesOfCode < 66000) rank = "++";
	else if (linesOfCode < 246000) rank = "+";
	else if (linesOfCode < 665000) rank = "o";
	else if (linesOfCode < 1310000) rank = "-";
	else rank = "--";
	
	return rank;
}

//get the lines of a strin piece of java source code
int getLinesOfSrc(str src){
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