module LinesOfCode

import IO;
import String;
import lang::java::m3::Core;
import List;

/*
 get the lines of code from a specific source code
*/
int getLinesOfCode(M3 model){
	int linesOfCode= 0;
	list[loc] compilationUnits = [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"];
	for(loc l <- compilationUnits){
		file = readFile(l);
		// get all relevant comments
		for(c <- [c2 | <_,c2> <- model@documentation, c2.path == l.path]){
			// remove the comments
			//println(readFile(c));
			file = replaceAll(file, readFile(c), "");
		}
		// count the lines that contain not only whitespace
		for(/<x:.*[^\s].*\r?(\n|\Z)>/ := file){
			linesOfCode += 1;
		}
		
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
