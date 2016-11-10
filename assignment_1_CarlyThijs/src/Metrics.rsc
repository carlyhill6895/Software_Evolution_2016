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

str getRankLinesOfCode(int linesOfCode){
	str rank = "";
	
	if(linesOfCode < 66000) rank = "++";
	else if (linesOfCode < 246000) rank = "+";
	else if (linesOfCode < 665000) rank = "o";
	else if (linesOfCode < 1310000) rank = "-";
	else rank = "--";
	
	return rank;
}