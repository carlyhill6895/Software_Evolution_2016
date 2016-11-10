module Metrics

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;

int getMetrics(loc projectLocation){
	M3 model = createM3FromEclipseProject(projectLocation);
	return getLinesOfCode(model);
}