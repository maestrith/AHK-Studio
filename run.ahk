Run(){
	if !current(1).xml
		return
	sc:=csc(),save(),file:=ssn(current(1),"@file").text
	if(file=A_ScriptFullPath)
		exit(1)
	main:=ssn(current(1),"@file").text
	SplitPath,file,,dir
	run:=FileExist(dir "\AutoHotkey.exe")?Chr(34) dir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34):Chr(34) file Chr(34)
	admin:=v.options.run_as_admin?"*RunAs ":""
	Run,%admin%%run%,%dir%,,pid
	if !IsObject(v.runpid)
		v.runpid:=[]
	v.runpid.Insert(pid)
	if(file=A_ScriptFullPath)
		ExitApp
}