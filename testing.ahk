testing(){
	m("testing")
}
test_plugin(){
	save(),Exit(1,1)
}
plugins:
FileRead,plugins,plugins\plugins.ahk
if !FileExist("plugins")
	FileCreateDir,Plugins
Loop,plugins\*.ahk
{
	if (A_LoopFileName!="plugins.ahk"){
		if !RegExMatch(plugins,"i)\bplugins\\" A_LoopFileName){
			enter:=plugins?"`r`n":""
			FileAppend,% Enter Chr(35) "Include *i plugins\" A_LoopFileName,plugins\plugins.ahk
			Reload:=1
		}
	}
}
if (Reload){
	Reload
	ExitApp
}
#Include *i plugins\plugins.ahk
return
addmenu(menu,notify=""){
	static init
	Menu,Plugins,Add,%menu%,menuhandler
	if !(init){
		Menu,main,Add,Plugins,:Plugins
		init:=1
	}
	if notify
		plugin(menu)
	menuhandler:
	menu:=clean(A_ThisMenuItem)
	if IsFunc(menu)
		%menu%()
	return
}