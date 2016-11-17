module UnitComplexity

import LinesOfCode;
import IO;
import List;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;



list[str] getComplexityUnitSizeRanks(M3 model){
	list[str] ranks =  [];
	risks = getRisks(model);
	for(risklocs <- risks ){
		ranks += getRank(risklocs, model);
	}
	return ranks;
}

str getRank(list[int] catLOCs, M3 model){
	int totalLOC = getLinesOfCode(model);
	list[real] percentages = [];
	for(int s <-catLOCs){
		percentages += getPercentageLoc(s, totalLOC);
	}
	println("percentages of loc per risk category:  <percentages>");
	
	str rank = "";
	num pcVeryHigh = head(percentages);
	println("percentage very high: <pcVeryHigh>");
	percentages = tail(percentages);
	num pcHigh = head(percentages);
	println("percentage high: <pcHigh>");
	percentages = tail(percentages);
	num pcMedium = head(percentages);
	println("percentage medium: <pcMedium>");
	
	if(pcMedium < 25 && pcHigh <=0 && pcVeryHigh <=0) rank = "++";
	else if(pcMedium <30 && pcHigh < 5 && pcVeryHigh <=0) rank = "+";
	else if(pcMedium < 40 && pcHigh < 10 && pcVeryHigh <=0) rank = "o";
	else if(pcMedium < 50 && pcHigh < 15 && pcVeryHigh < 5) rank = "-";
	else rank = "--";
	 
	return rank;
}
list[list[int]] getRisks(M3 model){
	list[int] cclocs = [];
	list[list[int]] risks = [];
	list[loc] methods = getMethods(model);
	int ccVeryHigh = 0;
	int ccHigh = 0;
	int ccMedium = 0;
	int ccLow = 0;	
	
	list[int] unitSizeRanks = [];
	int unitSizeVeryHigh = 0;
	int unitSizeHigh = 0;
	int unitSizeMedium = 0;
	int unitSizeLow = 0;
	
	for(m <- methods){
		int linesOfCode = getLinesOfSrc(readFile(m));
		if (linesOfCode > 100) {print(readFile(m));unitSizeVeryHigh += linesOfCode;}
		else if (linesOfCode > 50) unitSizeHigh += linesOfCode;
		else if (linesOfCode > 10) unitSizeMedium += linesOfCode;
		else unitSizeLow += linesOfCode;
		
		methodAST = getMethodASTEclipse(m, model = model);
		int cc = getMethodComplexity(methodAST);
		if (cc > 50) {print(readFile(m)); ccVeryHigh += linesOfCode;}
		else if (cc > 20) ccHigh += linesOfCode;
		else if (cc > 10) ccMedium += linesOfCode;
		else ccLow += linesOfCode;
	}
	
	unitSizeRanks = unitSizeRanks + unitSizeVeryHigh + unitSizeHigh + unitSizeMedium + unitSizeLow;
	cclocs = cclocs + ccVeryHigh + ccHigh + ccMedium + ccLow;
	risks = risks + [unitSizeRanks] + [cclocs];
	println(risks);
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



real getPercentageLoc(num riskLOC, num totalLOC){
	return riskLOC / totalLOC * 100.0;
}

list[loc] getMethods(M3 model){
	return [m | <_,m> <- model@containment, isMethod(m)];
}
