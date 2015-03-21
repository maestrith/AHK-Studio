runit(){
	runit:
	SetTimer,runit,Off
	file:=v.running
	SplitPath,file,,dir
	Run,"%A_AhkPath%" /debug "%file%",%dir%,,pid
	v.pid:=pid
	;SetTimer,checkerror,100 
	return
}