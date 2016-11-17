module Metrics

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;
import UnitComplexity;

list[str] getMetrics(loc projectLocation){
	list[str] ranks = [];
	M3 model = createM3FromEclipseProject(projectLocation);
	println("model gemaakt");
	int linesOfCode = getLinesOfCode(model);
	println("Lines Of Code (LOC) : <linesOfCode>");
	ranks += getRankLinesOfCode(linesOfCode);
	ranks += getComplexityUnitSizeRanks(model);
	return ranks;
}
