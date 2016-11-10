module UnitComplexity
import LinesOfCode;
import IO;
import List;
import util::Math;
import lang::java::m3::Core;

str getComplexityRank(M3 model){

	return "";
}

// count the lines of code in each method and rank based on the percentage of methods that have a certain amount of LOC
str getUnitSizeRank(M3 model){
 	list[loc] methods = getMethods(model);
	int amountMethods = size(methods);
	list[int] unitSizeRanks = getUnitSizeRanks(methods);
	
	return "";
}

list[int] getUnitSizeRanks(list[loc] methods) {
	list[int] unitSizeRanks = [];
	int unitSizeVeryHigh = 0;
	int unitSizeHigh = 0;
	int unitSizeMedium = 0;
	int unitSizeLow = 0;
	
	for(m <- methods){
		int linesOfCode = getLinesOfSrc(readFile(m));
		if (linesOfCode > 100) unitSizeVeryHigh += 1;
		else if (linesOfCode > 50) unitSizeHigh += 1;
		else if (linesOfCode > 10) unitSizeMedium += 1;
		else unitSizeLow += 1;
	}
	
	unitSizeRanks = unitSizeRanks + unitSizeVeryHigh + unitSizeHigh + unitSizeMedium + unitSizeLow;
	return unitSizeRanks;
}

list[loc] getMethods(M3 model){
	return [m | <_,m> <- model@containment, isMethod(m)];
}

