module CodeDuplication

import IO;
import List;
import String;

tuple[int,str] checkCodeDuplication(list[str] files, num LOC){
	list[str] clean_files = [];
	for(f <- files)
		clean_files += removeWhitespace(f);
	clean_files_str = intercalate("", clean_files);

	// If the size of clean_files is smaller than 5, you can't pop 6 lines, so the result is ++ by default
	if(size(clean_files) > 5){
		num duplicateLines = 0;
		// Pop first 6 lines
		list[str] block = [];
		for(i <- [1..7]){
			<ln, clean_files> = pop(clean_files);
			block += ln;
		}
		// If the size of clean_files is smaller than 11, there can't be a duplicate block of 6 lines
		while(size(clean_files) > 5){
			result = checkBlock(block, clean_files_str);
			// If block recurred in clean_files, add the amount of LOC to the counter
			if(result > 0){
				duplicateLines += result * 6;
				// Check if further lines match and add them to the counter
				while(result > 0 && size(clean_files) > size(block) + 1){
					<ln, clean_files> = pop(clean_files);
					block += ln;
					result = checkBlock(block, clean_files_str);
					duplicateLines += result;
				}
				clean_files_str = replaceAll(clean_files_str, intercalate("", prefix(block)), "");
				// Reduce the block to 5 again
				for(i <- [0..size(block) - 5])
					<_, block> = pop(block);
				// Pop extra line
				if(size(clean_files) > 5){
					<ln, clean_files> = pop(clean_files);
					block += ln;
				}
			}
			else{
				<_, block> = pop(block);
				<ln, clean_files> = pop(clean_files);
				block += ln;
			}
		}
		percentage = duplicateLines / LOC;
		println("\nPercentage duplicated lines: <percentage * 100.0>");
		return if(percentage <= 0.03) <5,"++">;
			else if(percentage <= 0.05) <4,"+">;
			else if(percentage <= 0.1) <3,"o">;
			else if(percentage <= 0.2) <2,"-">;
			else <1,"--">;
	}
	else{
		println("\nPercentage duplicated lines: 0%");
		return <5,"++">;
	}
}

// Checks if a block recurs in files by comparing sizes
int checkBlock(list[str] block, str files){
	orig_size = size(files);
	block_str = intercalate("", block);
	new_files = replaceAll(files, block_str, "");
	return (orig_size - size(new_files)) / size(block_str) - 1;
}

// Split file in a list of non-empty lines, stripped of leading whitespace
list[str] removeWhitespace(str file) =
	[ln | /<ln:[^\s].*\r?(\n|\Z)>/ := file];
