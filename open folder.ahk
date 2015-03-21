open_folder(){
	sc:=csc()
	file:=current(3).file
	SplitPath,file,,dir
	if !(dir){
		file:=current(2).file
		SplitPath,file,,dir
	}
	Run,%dir%
}