module Report
import IO;
import DuplicationAnalyzer;

public void generateReport(loc projectLocation, map[int, list[loc]] duplications, map[loc, int] locPerFile){
	loc reportFile = projectLocation + "report.txt";
	findReportProbs(duplications, locPerFile);
	writeFile(reportFile, "Report\n\n");
	appendToFile(reportFile, "Percentage of duplicated lines: <getPercentageTotalDuplication()>\n");
	appendToFile(reportFile, "Amount of clone classes: <getAmountCloneClasses()>\n");
	appendToFile(reportFile, "Total amount of clones: <getTotalAmountClones()>\n");
	appendToFile(reportFile, "Biggest Clone: <readFile(getBiggestClone())>\n");
	appendToFile(reportFile, "Example Clone: <readFile(getExampleClone())>\n");
}
