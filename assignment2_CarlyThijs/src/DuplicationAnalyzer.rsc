module DuplicationAnalyzer
import IO;
import List;
import Map;
import Set;

private map[int, list[loc]] duplications = ();
private map[loc, int] locPerFile = ();
private real percentageTotalDuplication = 0.0;
private int amountClones = 0;
private loc biggestClone;

public void findReportProbs(map[int, list[loc]] allDuplications, map[loc, int] allLocPerFile){
	duplications = allDuplications;
	locPerFile = allLocPerFile;
	if(duplications == ()) throw "No duplications were found so no probs can be found...";
	real totalLinesOfCode = 1000.0;
	num duplicatedLines = 0;
	num biggestCloneLength = 0;
	amountClones = 0;
	for(list[loc] dupGroup <- range(duplications)){
		amountClones += size(dupGroup);
		for(loc dup <- dupGroup){
			int length = getDupLines(dup);
			duplicatedLines += length;
			if(length > biggestCloneLength) biggestClone = dup;
		}
	}
	println("gevonden duplicated lines: <duplicatedLines>");
	percentageTotalDuplication = duplicatedLines/totalLinesOfCode;
}

public tuple[num, list[loc]] findVisualizationProbs(loc file){
	list[loc] duplicatesInFile = [];
	num duplicatedLinesInFile = 0;
	amountClones = 0;
	for(list[loc] dupGroup <- range(duplications)){
		amountClones += size(dupGroup);
		for(loc dup <- dupGroup){
			if(dup.path == file.path) {
				println("duplicatie <dup> gevonden voor bestand <file>!");
				duplicatesInFile += dup;
				duplicatedLinesInFile +=getDupLines(dup);
			}
		}
	}
	int locFile  = locPerFile[file];
	println("loc voor file <file>: <locFile>");
	num percentageDuplicationInFile = duplicatedLinesInFile/locFile; //TODO: get lines of code from file
	return <percentageDuplicationInFile, duplicatesInFile>;
}

public int getDupLines(loc dup){
	lines = dup.end.line - dup.begin.line;
	if(lines == 0) lines = 1;
	return lines;
}

public real getPercentageTotalDuplication() = percentageTotalDuplication;
public int getAmountCloneClasses() = size(duplications);
public int getTotalAmountClones() = amountClones;
public loc getBiggestClone() = biggestClone;
public loc getExampleClone() {
	list[loc] dupGroup = getOneFrom(range(duplications));
	return getOneFrom(dupGroup);
}
