runfile(file){
	SplitPath,file,,dir
	run,%file%,%dir%
	return 1
}