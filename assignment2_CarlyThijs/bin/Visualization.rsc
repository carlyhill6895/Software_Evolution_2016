module Visualization
import DuplicationAnalyzer;
import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Resources;
import IO;
import Set;
import List;

data ResourceDuplicationTree = rdFolder(loc id, num dup, set[ResourceDuplicationTree] folders, set[ResourceDuplicationTree] files) 
| rdFile(loc id, num dup, list[loc] duplications)
;

void showProjectTree(loc projectLocation, loc srcLoc){
	Resource projectResource = getProject(projectLocation);
	Resource sourceCode = project(projectLocation, {});
	loc locSrc  = srcLoc;
	visit(projectResource){
		case folder(id, contents): {
										if(locSrc.path == id.path ) sourceCode = folder(id, contents);
									}
	}
	set[Resource] filteredResources = {};
	filteredSourceCode = top-down visit(sourceCode){
		case folder(id, contents)=>folder(id, getJavaContents(contents))
	}

	ResourceDuplicationTree projectTree = mapRDTree(filteredSourceCode);

	projectVis = mapVisDuplicationTreeFolders( {projectTree} );
	render(space(hvcat(projectVis, gap(10))));
	
}


private ResourceDuplicationTree mapRDTree(folder(id, contents)) = rdFolder(id, 0.1, getRDTFolders(contents), getRDTFiles(contents));
private ResourceDuplicationTree mapRDTree(file(id)) {
	tuple[num pcdup, list[loc] dups] probs =  findVisualizationProbs(id);
 	return rdFile(id, probs.pcdup, probs.dups);
}

private Figure getVisDuplicationLeaf(rdFile(id, dup, duplicatedLines)) { 
	locationFigures = for(duploc <- duplicatedLines){
		append(text("(<duploc.begin.line>, <duploc.begin.column>) - (<duploc.end.line>, <duploc.end.column>)", fontSize(12), fontColor("black"), gap(1)));
	}
	return box(text(id.path), fillColor(interpolateColor(color("Green"), color("Red"), dup)), mouseOver(box(vcat(locationFigures), onMouseDown(
		bool(int butnr, map[KeyModifier, bool] modifiers) {
		if(butnr == 1){
			iprintln(duplicatedLines);
			return true;
		}
		else return false;
	}),gap(5))));
}

private list[Figure] mapVisDuplicationTreeOnlyFolders(set[ResourceDuplicationTree] folders){
	list[Figure] visFolders = [];
	for (f <- folders) {
	  if(rdFolder(id, dup, {}, _) := f)
	 	visFolders += box(text(id.path), fillColor("white"));
	 else if (rdFolder(id, dup, fs, _) := f) 
	 	visFolders += tree(box(text(id.path), fillColor("white")), mapVisDuplicationTreeOnlyFolders(fs), std(gap(20)), hcenter());
	 }

	return visFolders;
}

private list[Figure] mapVisDuplicationTreeFolders(set[ResourceDuplicationTree] folders) {
	list[Figure] visFolders = [];
	for (f <- folders) {
		 if(rdFolder(id, dup, {}, {}) := f)
		 	visFolders = visFolders + box(text(id.path), fillColor("white"));
		 else if( rdFolder(id, dup, fs, {}):= f) 
		 	visFolders += tree(box(text(id.path), fillColor("white")), mapVisDuplicationTreeFolders(fs), std(gap(20)));
		 else if( rdFolder(id, dup, {}, fs):=f){
		 		list[Figure] files = mapVisDuplicationTreeFiles(fs);
		 		files = [vcat(files, gap(5))];
		 		visFolders += tree(box(text(id.path), fillColor("white")), files, std(gap(20)));
		 	}
		 else if( rdFolder(id, dup, fos, fis):= f){
		 	list[Figure] files = mapVisDuplicationTreeFiles(fis);
		 	files = [vcat(files, gap(5))];
		 	visFolders += tree(box(text(id.path), fillColor("white")), (mapVisDuplicationTreeFolders(fos) + files), std(gap(20)));
		 }
	 }

	return visFolders;
}

private list[Figure] mapVisDuplicationTreeFiles(set[ResourceDuplicationTree] files) = toList(mapper(files, getVisDuplicationLeaf));

private set[ResourceDuplicationTree] getRDTFolders (contents){
	newContents = {};
	for(rc <- contents){
		if (folder(_, _) := rc) newContents += mapRDTree(rc);
	}
	return newContents;
}

private set[ResourceDuplicationTree] getRDTFiles (contents){
	newContents = {};
	for( rc <- contents){
		if(file(_) := rc ) newContents+= mapRDTree(rc);
	}
	return newContents;
}

private set[Resource] getJavaContents(contents) {
	for (rc <- contents){
		if( file(L) := rc) {
			if (/java/ !:= L.path) {
				contents = contents - {file(L)};
				//iprintln(contents);
			}
		}
	}
	return contents;
}
