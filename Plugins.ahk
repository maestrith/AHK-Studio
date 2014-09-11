test_plugin(){
	save(),Exit(1,1)
	Return
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
		code_explorer.plugins:=[]
		init:=omni_search("init")
		v.plugins:=[]
	}
	v.plugins.Insert(menu)
	init.menulist.menu[menu]:={launch:"func",name:menu,text:clean(menu),type:"menu",sort:menu,additional1:hotkey,order:"name,additional1"}
	if notify
		plugin(menu)
	menuhandler:
	menu:=clean(A_ThisMenuItem)
	if IsFunc(menu)
		%menu%()
	return
}