module UnitComplexity

import IO;
import List;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;
import LinesOfCode;

list[tuple[int,str]] getComplexityUnitSizeRanks(M3 model){
	list[tuple[int,str]] ranks = [];
	risks = getRisks(model);
	ranks += getRank(head(risks), model, "Unit Size");
	ranks += getRank(last(risks), model, "Unit Complexity");
	return ranks;
}

tuple[int,str] getRank(list[int] catLOCs, M3 model, str label){
	<totalLOC,_> = getLinesOfCode(model);
	list[real] percentages = [];
	for(int s <-catLOCs)
		percentages += getPercentageLoc(s, totalLOC);
	println("\nPercentages of LOC per risk category for <label>:");

	<pcVeryHigh, percentages> = pop(percentages);
	println("Percentage very high:\t<pcVeryHigh>");
	<pcHigh, percentages> = pop(percentages);
	println("Percentage high:\t<pcHigh>");
	<pcMedium, percentages> = pop(percentages);
	println("Percentage medium:\t<pcMedium>");
	println("Percentage low:\t\t<head(percentages)>");
	println("Percentage LOC outside methods: <100 - pcVeryHigh - pcHigh - pcMedium - head(percentages)>");

	return if(pcMedium < 25 && pcHigh <=0 && pcVeryHigh <=0) <5,"++">;
		else if(pcMedium <30 && pcHigh < 5 && pcVeryHigh <=0) <4,"+">;
		else if(pcMedium < 40 && pcHigh < 10 && pcVeryHigh <=0) <3,"o">;
		else if(pcMedium < 50 && pcHigh < 15 && pcVeryHigh < 5) <2,"-">;
		else <1,"--">;
}

list[list[int]] getRisks(M3 model){
	list[int] cclocs = [];
	list[list[int]] risks = [];
	lrel[loc,loc] methods = getMethods(model);
	list[loc] bigMethods = [];
	list[loc] complexMethods = [];
	int ccVeryHigh = 0;
	int ccHigh = 0;
	int ccMedium = 0;
	int ccLow = 0;

	list[int] unitSizeRanks = [];
	int unitSizeVeryHigh = 0;
	int unitSizeHigh = 0;
	int unitSizeMedium = 0;
	int unitSizeLow = 0;

	for(<c,m> <- methods){
		<linesOfCode,_> = getLinesOfUnit(readFile(m), head(getCompilationUnit(c, model)), model);
		if (linesOfCode > 100) {
			bigMethods += m;
			unitSizeVeryHigh += linesOfCode;
		}
		else if (linesOfCode > 50) unitSizeHigh += linesOfCode;
		else if (linesOfCode > 10) unitSizeMedium += linesOfCode;
		else unitSizeLow += linesOfCode;

		methodAST = getMethodASTEclipse(m, model = model);
		int cc = getMethodComplexity(methodAST);
		if (cc > 50) {
			complexMethods += m;
			ccVeryHigh += linesOfCode;
		}
		else if (cc > 20) ccHigh += linesOfCode;
		else if (cc > 10) ccMedium += linesOfCode;
		else ccLow += linesOfCode;
	}

	unitSizeRanks = unitSizeRanks + unitSizeVeryHigh + unitSizeHigh + unitSizeMedium + unitSizeLow;
	cclocs = cclocs + ccVeryHigh + ccHigh + ccMedium + ccLow;
	risks = risks + [unitSizeRanks] + [cclocs];
	println("\nBig methods:");
	printLocations(bigMethods);
	println("\nComplex methods:");
	printLocations(complexMethods);
	return risks;
}

//implementation following: http://onlinelibrary.wiley.com/doi/10.1002/smr.1760/full
int getMethodComplexity(methodAST){
	int cc = 1;
	visit(methodAST){
		case \if(_,_) : cc += 1;
        case \if(_,_,_) : cc += 1;
        case \case(_) : cc += 1;
        case \do(_,_) : cc += 1;
        case \while(_,_) : cc += 1;
        case \for(_,_,_) : cc += 1;
        case \for(_,_,_,_) : cc += 1;
        case foreach(_,_,_) : cc += 1;
        case \catch(_,_): cc += 1;
        case \conditional(_,_,_): cc += 1;
        case infix(_,"&&",_) : cc += 1;
        case infix(_,"||",_) : cc += 1;
	};
	return cc;
}

real getPercentageLoc(num riskLOC, num totalLOC) =
	riskLOC / totalLOC * 100.0;

lrel[loc,loc] getMethods(M3 model) =
	[<c,m> | <c,m> <- model@containment, isMethod(m)];

list[loc] getCompilationUnit(loc class, M3 model) =
	[cu | <cu,class> <- model@containment];

void printLocations(list[loc] locations){
	for(l <- locations)
		println("    <l>");
}

test bool testGetMethods(){
	lrel[loc,loc] methods = getMethods(createM3FromEclipseProject(|project://test_project|));
	return size(methods) == 2;
}
test bool testGetUnitLinesOfCode(){
	M3 model = createM3FromEclipseProject(|project://test_project|);
	lrel[loc,loc] methods = getMethods(model);
	tuple[loc cu, loc method] firstMethod = head(methods);
	tuple[loc cu, loc method] secondMethod = last(methods);
	<linesOfCodeFirst,_> = getLinesOfUnit(readFile(firstMethod.method), head(getCompilationUnit(firstMethod.cu, model)), model);
	<linesOfCodeSecond,_> = getLinesOfUnit(readFile(secondMethod.method), head(getCompilationUnit(secondMethod.cu, model)), model);
	return linesOfCodeFirst == 5 && linesOfCodeSecond == 15;
}
test bool testGetMethodComplexity(){
	M3 model = createM3FromEclipseProject(|project://test_project|);
	lrel[loc,loc] methods = getMethods(model);
	tuple[loc cu, loc method] firstMethod = head(methods);
	tuple[loc cu, loc method] secondMethod = last(methods);
	int complexityFirst = getMethodComplexity(getMethodASTEclipse(firstMethod.method, model = model));
	int complexitySecond = getMethodComplexity(getMethodASTEclipse(secondMethod.method, model = model));
	return complexityFirst == 1 && complexitySecond == 3;
}