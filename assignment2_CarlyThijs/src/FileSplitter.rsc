
module FileSplitter
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import IO;
import String;

map[loc, list[loc]] getUnits(loc projectLocation){
	map[loc, list[loc] ] cums = ();
	M3 model = createM3FromEclipseProject(projectLocation);
	map[loc,str] cufls = getCompilationUnits(model);
	println(cufls);
	
	return cums;
}


map[loc, str] getCompilationUnits(M3 model) {
	map[loc, str] cuFiles = ();
	list[loc] cus = [cu | <cu,_> <- model@containment, cu.scheme == "java+compilationUnit"];
	for(cu <- cus){
		file = readFile(cu);
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
		cuFiles = cuFiles + (cu:file);
	}
	return cuFiles;
	
}