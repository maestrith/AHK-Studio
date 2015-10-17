test_plugin(){
	save(),Exit(1,1)
	return
}
plugins(refresh:=0){
	plugins:
	if !FileExist("plugins")
		FileCreateDir,Plugins
	plHks:=[]
	if(refresh){
		while pl:=menus.sn("//menu[@clean='Plugin']/menu[@hotkey!='']").item[A_Index-1],ea:=xml.ea(pl)
			plHks[ea.name]:=ea.hotkey
		rem:=menus.ssn("//menu[@clean='Plugin']"),rem.ParentNode.RemoveChild(rem)
	}
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
		while,pos:=RegExMatch(plg,"Oim)\;menu\s*(.*)\R",found,pos){
			item:=StrSplit(found.1,",")
			item.1:=Trim(item.1,"`r|`r`n|`n")
			if !ssn(plugin,"descendant::menu[@name='" Trim(item.1) "']")
				menus.under(plugin,"menu",{name:Trim(item.1),clean:clean(item.1),plugin:A_LoopFileFullPath,option:item.2,hotkey:plHks[item.1]})
			pos:=found.Pos(1)+1
		}
	}
	if refresh
		SetTimer,refreshmenu,-300
	return
	refreshmenu:
	Menu("main"),MenuWipe()
	Gui,1:Menu,% Menu("main")
	return
}