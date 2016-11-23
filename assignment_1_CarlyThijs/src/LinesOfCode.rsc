module LinesOfCode

import IO;
import String;
import lang::java::m3::Core;

/*
 get the lines of code from a specific source code
*/
tuple[int, list[str]] getLinesOfCode(M3 model){
	int linesOfCode= 0;
	list[str] files = [];
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"]){
		file = readFile(l);
		<lines, file> = getLinesOfUnit(file, l, model);
		linesOfCode += lines;
		files += file;
	}
	return <linesOfCode,files>;
}

tuple[int, str] getLinesOfUnit(str file, loc cu, M3 model){
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
	for(/[^\s].*\r?(\n|\Z)/ := file)
		linesOfCode += 1;
	// return the LOC and file stripped of comments
	return <linesOfCode,file>;
}

/*
	give back the rank based on the Sig maintainability model (as defined on
	http://docs.sonarqube.org/display/SONARQUBE45/SIG+Maintainability+Model+Plugin)
*/
tuple[int,str] getRankLinesOfCode(int linesOfCode) = <5,"++"> when linesOfCode < 66000;
tuple[int,str] getRankLinesOfCode(int linesOfCode) = <4,"+"> when linesOfCode < 246000;
tuple[int,str] getRankLinesOfCode(int linesOfCode) = <3,"o"> when linesOfCode < 665000;
tuple[int,str] getRankLinesOfCode(int linesOfCode) = <2,"-"> when linesOfCode < 1310000;
tuple[int,str] getRankLinesOfCode(int linesOfCode) = <1,"--">;
