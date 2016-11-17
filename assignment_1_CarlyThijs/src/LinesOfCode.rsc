module LinesOfCode

import IO;
import String;
import lang::java::m3::Core;

/*
 get the lines of code from a specific source code
*/
int getLinesOfCode(M3 model){
	int linesOfCode= 0;
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"]){
		file = readFile(l);
		linesOfCode += getLinesOfUnit(file, l, model);
	}
	return linesOfCode;
}

int getLinesOfUnit(str file, loc cu, M3 model){
	// get all relevant comments and remove them
	for(c <- [c2 | <_,c2> <- model@documentation, c2.path == cu.path]){
		// If the comment is multiline, insert extra newline, otherwise the next code
		// snippet will be interpreted as 1 LOC
		//   foo(); /*
		//   */ bar();
		if(c.end.line - c.begin.line == 0)
			file = replaceAll(file, readFile(c), "");
		else
			file = replaceAll(file, readFile(c), "\n");
	}
	int linesOfCode = 0;
	// count the lines that contain not only whitespace
	for(/<x:[^\s].*\r?(\n|\Z)>/ := file)
		linesOfCode += 1;
	return linesOfCode;
}

/*
	give back the rank based on the Sig maintainability model (as defined on
	http://docs.sonarqube.org/display/SONARQUBE45/SIG+Maintainability+Model+Plugin)
*/
str getRankLinesOfCode(int linesOfCode) = "++" when linesOfCode < 66000;
str getRankLinesOfCode(int linesOfCode) = "+" when linesOfCode < 246000;
str getRankLinesOfCode(int linesOfCode) = "o" when linesOfCode < 665000;
str getRankLinesOfCode(int linesOfCode) = "-" when linesOfCode < 1310000;
str getRankLinesOfCode(int linesOfCode) = "--";
