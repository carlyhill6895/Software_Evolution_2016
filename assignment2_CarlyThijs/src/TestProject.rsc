module TestProject
import DuplicationAnalyzer;
import FileSplitter;
import Report;
import Visualization;
import lang::java::m3::AST;
import IO;

public void main(){
	Declaration ast = createAstFromFile(|project://CaesarCipher/src/CaesarCipher.java|,true);
	iprintln(ast);
	tuple[map[int, list[loc]] dupGroups, map[loc,int] locPerFile, int totalLoc] dups = findDuplications(|project://CaesarCipher|,1);
	findReportProbs(dups.dupGroups, dups.locPerFile, dups.totalLoc);
	println("percentage duplications: <getPercentageTotalDuplication()>");
	println("amount clone classes: <getAmountCloneClasses()>");
	println("amount clones: <getTotalAmountClones()>");
	println("biggest Clone: <getBiggestClone()>");
	println("example Clone: <getExampleClone()>");
	showProjectTree(|project://CaesarCipher|, |project://CaesarCipher/src|);

	generateReport(|project://CaesarCipher|, dups.dupGroups, dups.locPerFile, dups.totalLoc);
}

test bool testPercentageDuplication() = getPercentageTotalDuplication() == 0.002;
test bool testAmountCloneClasses() = getAmountCloneClasses() == 1;
test bool testAmountClones() = getTotalAmountClones() == 2;
test bool testBiggestClone() = getBiggestClone() == |project://CaesarCipher/src/CaesarCipher.java|(600,15,<26,3>,<26,18>);
test bool testDupLines() = getDupLines(|project://CaesarCipher/src/CaesarCipher.java|(640,14,<27,23>,<27,37>)) == 1;
