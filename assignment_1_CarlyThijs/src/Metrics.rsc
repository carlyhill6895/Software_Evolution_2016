module Metrics

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;

list[str] getMetrics(loc projectLocation){
	list[str] ranks = [];
	M3 model = createM3FromEclipseProject(projectLocation);
	int linesOfCode = getLinesOfCode(model);
	println("Lines Of Code (LOC) : <linesOfCode>");
	ranks += getRankLinesOfCode(linesOfCode);
	return ranks;
}

