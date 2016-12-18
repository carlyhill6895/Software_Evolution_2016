module DuplicationAnalyzer
import IO;
import List;
import Map;
import Set;
import util::Math;

private map[int, list[loc]] duplications = ();
private map[loc, int] locPerFile = ();
private real percentageTotalDuplication = 0.0;
private int amountClones = 0;
private loc biggestClone;
//seems to be a good line length: since duplications are also only colums parts of lines need to be estimated
private real AVERAGE_LINE_LENGTH = 60.0;

//get probs for report
public void findReportProbs(map[int, list[loc]] allDuplications, map[loc, int] allLocPerFile, int totalLoc){
	duplications = allDuplications;
	locPerFile = allLocPerFile;
	if(duplications == ()) throw "No duplications were found so no probs can be found...";
	num duplicatedLines = 0;
	num biggestCloneLength = 0;
	amountClones = 0;
	for(list[loc] dupGroup <- range(duplications)){
		amountClones += size(dupGroup);
		for(loc dup <- dupGroup){
			int length = dup.length;
			duplicatedLines += length;
			if(length > biggestCloneLength) {
				biggestCloneLength = length;
				biggestClone = dup;
			}
		}
	}
	duplicatedLines = duplicatedLines/AVERAGE_LINE_LENGTH;
	percentageTotalDuplication = duplicatedLines/toReal(totalLoc);
}

//get probs for visualization
public tuple[num, list[loc]] findVisualizationProbs(loc fileLoc){
	list[loc] duplicatesInFile = [];
	num duplicatedLinesInFile = 0;
	amountClones = 0;
	for(list[loc] dupGroup <- range(duplications)){
		amountClones += size(dupGroup);
		for(loc dup <- dupGroup){
			if(dup.file == fileLoc.file) {
				duplicatesInFile += dup;
				duplicatedLinesInFile +=dup.length;
			}
		}
	}
	int locFile  = 1;
	for(key <- domain(locPerFile)){
		if(fileLoc.file == key.file){
			locFile = locPerFile[key];
		}
	}
	duplicatedLinesInFile = duplicatedLinesInFile/AVERAGE_LINE_LENGTH;
	num percentageDuplicationInFile = duplicatedLinesInFile/toReal(locFile);
	return <percentageDuplicationInFile, duplicatesInFile>;
}

//get methods for probs
public real getPercentageTotalDuplication() = percentageTotalDuplication;
public int getAmountCloneClasses() = size(duplications);
public int getTotalAmountClones() = amountClones;
public loc getBiggestClone() = biggestClone;
public loc getExampleClone() {
	list[loc] dupGroup = getOneFrom(range(duplications));
	return getOneFrom(dupGroup);
}
