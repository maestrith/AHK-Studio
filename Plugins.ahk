test_plugin(){
	save(),Exit(1,1)
	return
}
plugins(){
	plugins:
	if !FileExist("plugins")
		FileCreateDir,Plugins
	pin:=menus.sn("//*[@clean='Plugin']/descendant::menu")
	while,pp:=pin.item[A_Index-1],ea:=xml.ea(pp)
		if !FileExist(ea.plugin)
			pp.ParentNode.RemoveChild(pp)
	if !menus.sn("//*[@clean='Plugin']/descendant::menu").length
		rem:=menus.ssn("//*[@clean='Plugin']"),rem.ParentNode.RemoveChild(rem)
	Loop,plugins\*.ahk
	{
		if !plugin:=menus.ssn("//menu[@clean='Plugin']")
			plugin:=menus.Add({path:"menu",att:{clean:"Plugin",name:"P&lugin"},dup:1})
		FileRead,plg,%A_LoopFileFullPath%
		pos:=1
		while,pos:=RegExMatch(plg,"Oi)\;menu\s*(.*)",found,pos){
			item:=StrSplit(found.1,",")
			if !ssn(plugin,"menu[@name='" item.1 "']")
				menus.under(plugin,"menu",{name:item.1,clean:clean(item.1),plugin:A_LoopFileFullPath,option:item.2})
			pos:=found.Pos(1)+1
		}
	}
	SetTimer,refreshmenu,-300
	return
	refreshmenu:
	Gui,1:Menu,% Menu("main")
	return
}