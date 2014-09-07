testing(){
	m("testing")
}
plugins:
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
plugin(fn){
	static notify:=[]
	if !IsObject(fn)
		return notify.Insert(clean(fn) "_notify")
	for a,b in notify
		%b%(fn)
}