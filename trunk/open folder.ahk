open_folder(){
	sc:=csc()
	file:=files.ssn("//*[@sc='" sc.2357 "']/@file").Text
	SplitPath,file,,dir
	Run,%dir%
}