module Metrics

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;
import UnitComplexity;
import CodeDuplication;

void getMetrics(loc projectLocation){
	list[tuple[int,str]] ranks = [];
	println("Start building M3 model...");
	M3 model = createM3FromEclipseProject(projectLocation);
	println("M3 Model built\n--------------------------");
	list[str] files = [];
	<linesOfCode, files> = getLinesOfCode(model);
	println("Lines Of Code (LOC): <linesOfCode>");
	ranks += getRankLinesOfCode(linesOfCode);
	ranks += getComplexityUnitSizeRanks(model);
	ranks += checkCodeDuplication(files, linesOfCode);
	println("\nResults\n--------------------------");
	int i = 0;
	for(r <- ["Volume:\t\t\t", "Unit Size:\t\t", "Unit Complexity:\t", "Code Duplication:\t"]){
		println("<r><ranks[i][1]>");
		i += 1;
	}
	real analysability = (ranks[0][0] + ranks[1][0] + ranks[3][0]) / 3.0;
	println("\nAnalysability:\t<getRank(analysability)>");
	real changeability = (ranks[2][0] + ranks[3][0]) / 2.0;
	println("Changeability:\t<getRank(changeability)>");
	real testability = (ranks[1][0] + ranks[2][0]) / 2.0;
	println("Testability:\t<getRank(testability)>");
	real maintenance = (analysability + changeability + testability) / 3.0;
	println("\nOverall maintainability: <getRank(maintenance)>");
}

private str getRank(real rank) = "--" when rank < 1.5;
private str getRank(real rank) = "-" when rank < 2.5;
private str getRank(real rank) = "o" when rank < 3.5;
private str getRank(real rank) = "+" when rank < 4.5;
private str getRank(real rank) = "++";
