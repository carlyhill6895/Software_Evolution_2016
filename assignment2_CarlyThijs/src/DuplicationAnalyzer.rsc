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

public void findReportProbs(map[int, list[loc]] allDuplications, map[loc, int] allLocPerFile, int totalLoc){
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
			int length = dup.length;
			duplicatedLines += length;
			if(length > biggestCloneLength) biggestClone = dup;
		}
	}
	duplicatedLines = duplicatedLines/100.0;
	println("gevonden duplicated lines: <duplicatedLines>");
	percentageTotalDuplication = duplicatedLines/totalLinesOfCode;
}

public tuple[num, list[loc]] findVisualizationProbs(loc fileLoc){
	list[loc] duplicatesInFile = [];
	num duplicatedLinesInFile = 0;
	amountClones = 0;
	for(list[loc] dupGroup <- range(duplications)){
		amountClones += size(dupGroup);
		for(loc dup <- dupGroup){
			if(dup.file == fileLoc.file) {
				println("duplicatie <dup> gevonden voor bestand <fileLoc>!");
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
	duplicatedLinesInFile = duplicatedLinesInFile/100.0;
	println("loc voor file <fileLoc>: <locFile>");
	num percentageDuplicationInFile = duplicatedLinesInFile/toReal(locFile); //TODO: get lines of code from file
	println(duplicatedLinesInFile);
	return <percentageDuplicationInFile, duplicatesInFile>;
}


public real getPercentageTotalDuplication() = percentageTotalDuplication;
public int getAmountCloneClasses() = size(duplications);
public int getTotalAmountClones() = amountClones;
public loc getBiggestClone() = biggestClone;
public loc getExampleClone() {
	list[loc] dupGroup = getOneFrom(range(duplications));
	return getOneFrom(dupGroup);
}
