testing(){
	m("testing")
}
addmenu(menu,notify=""){
	static init
	if !(init){
		Menu,Plugins,Add,Plugins
		Menu,main,Add,Plugins,:Plugins
		init:=1
	}
	Menu,Plugins,Add,%menu%,menuhandler
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