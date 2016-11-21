module Metrics

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;
import UnitComplexity;
import CodeDuplication;

void getMetrics(loc projectLocation){
	list[str] ranks = [];
	println("Start building M3 model...");
	M3 model = createM3FromEclipseProject(projectLocation);
	println("M3 Model built\n--------------------------");
	list[str] files = [];
	<linesOfCode, files> = getLinesOfCode(model);
	println("Lines Of Code (LOC): <linesOfCode>");
	ranks += "Volume:\t\t\t<getRankLinesOfCode(linesOfCode)>";
	ranks += getComplexityUnitSizeRanks(model);
	ranks += "Code Duplication:\t<checkCodeDuplication(files, linesOfCode)>";
	println("\nResults\n--------------------------");
	for(r <- ranks)
		println(r);
}
