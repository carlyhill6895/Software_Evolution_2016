module DuplicationFinder
import IO;
import Report;
import Visualization;
import FileSplitter;

public void main(loc projectLocation, loc srcLocation, int duplicationType){
	println("Generating report, will be visible in project folder under report.txt");
	tuple[map[int, list[loc]] dupGroups, map[loc,int] locPerFile, int totalLoc] dups = findDuplications(projectLocation, duplicationType);
	generateReport(projectLocation, dups.dupGroups, dups.locPerFile, dups.totalLoc);
	println("Finished generating report.");
	println("making visualization. On hover over a file you can see the duplication locations, on click they will be printed to the console");
	showProjectTree(projectLocation, srcLocation);
	println("finised.");
}