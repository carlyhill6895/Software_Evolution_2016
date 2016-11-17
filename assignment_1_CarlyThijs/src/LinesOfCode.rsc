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
		//println(file);
		// get all relevant comments
		for(c <- [c2 | <_,c2> <- model@documentation, c2.path == l.path]){
			// remove the comments
			//println(readFile(c));
			file = replaceAll(file, readFile(c), "");
		}
		println(file);
		// count the lines that contain not only whitespace
		for(/<x:.*[^\s].*(\n|\Z)>/ := file){
			//println(x);
			linesOfCode += 1;
		}
	}
	return linesOfCode;
}