module FileSplitter

import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import IO;
import String;

// Get the lines of code of a project and return the cleaned-up files as well.
tuple[int, map[loc,str]] getUnits(loc projectLocation){
	M3 model = createM3FromEclipseProject(projectLocation);
	int linesOfCode= 0;
	map[loc,str] files = ();
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"]){
		file = readFile(l);
		<lines, file> = getLinesOfUnit(file, l, model);
		linesOfCode += lines;
		files += (l:file);
	}
	return <linesOfCode,files>;
}

// Gets the Lines of code of a compilation unit.
// Also return the file stripped of comments, whitespace lines and leading whitespace.
tuple[int, str] getLinesOfUnit(str file, loc cu, M3 model){
	int linesOfCode = 0;
	str lines = "";
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
	// Count and store the lines that contain not only whitespace.
	for(/<ln:[^\s].*\r?(\n|\Z)>/ := file){
		linesOfCode += 1;
		lines += ln;
	}
	// Return the LOC and file stripped of comments, whitespace lines and leading whitespace.
	return <linesOfCode,lines>;
}
