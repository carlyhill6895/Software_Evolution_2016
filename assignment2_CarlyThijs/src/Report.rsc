module Report
import IO;
import DuplicationAnalyzer;

public void generateReport(loc projectLocation){
	loc reportFile = projectLocation + "report.txt";
	set[list[loc]] duplications = {[|project://CaesarCipher/src/CaesarCipher.java|(640,14,<27,23>,<27,37>),|project://CaesarCipher/src/CaesarCipher.java|(600,15,<26,3>,<26,18>)]};
	findReportProbs(duplications);
	writeFile(reportFile, "Report\n\n");
	appendToFile(reportFile, "Percentage of duplicated lines: <getPercentageTotalDuplication()>\n");
	appendToFile(reportFile, "Amount of clone classes: <getAmountCloneClasses()>\n");
	appendToFile(reportFile, "Total amount of clones: <getTotalAmountClones()>\n");
	appendToFile(reportFile, "Biggest Clone: <readFile(getBiggestClone())>\n");
	appendToFile(reportFile, "Example Clone: <readFile(getExampleClone())>\n");
}
