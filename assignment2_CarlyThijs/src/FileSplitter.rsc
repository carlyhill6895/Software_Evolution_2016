module FileSplitter

import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;
import IO;
import String;

tuple[int,value] getDuplication(loc projectLocation, int dupType){
	M3 model = createM3FromEclipseProject(projectLocation);
	LOC = getLoc(model);
	map[loc,value] asts = getAsts(model, dupType);
	return <LOC,asts>;
}

private map[loc, value] getAsts(M3 model, 2){
	map[loc, value] asts = ();
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"])
		asts += (l:createAstFromFile(l,false)[1]);
	return asts;
}
private default map[loc, value] getAsts(M3 model, _){
	map[loc, value] asts = ();
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"])
		asts += (l:createAstFromFile(l,true)[1]);
	return asts;
}

// Get the Source Lines of Code of a project.
int getLoc(M3 model){
	int linesOfCode= 0;
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"])
		linesOfCode += getLinesOfUnit(readFile(l), l, model);
	return linesOfCode;
}

// Gets the Lines of code of a compilation unit.
int getLinesOfUnit(str file, loc cu, M3 model){
	int linesOfCode = 0;
	// Get all comments for the compilation unit and remove them.
	for(c <- [c2 | <_,c2> <- model@documentation, c2.path == cu.path]){
		// If the comment is multiline, insert extra newline, otherwise the next code
		// snippet will be interpreted as 1 LOC:
		//   foo(); /*
		//   */ bar();
		if(c.end.line - c.begin.line == 0)
			file = replaceAll(file, readFile(c), "");
		else
			file = replaceAll(file, readFile(c), "\n");
	}
	// Count the lines that contain not only whitespace.
	for(/[^\s].*\r?(\n|\Z)/ := file)
		linesOfCode += 1;
	return linesOfCode;
}
