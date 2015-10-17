togglemenu(Label){
	if !Label
		return
	top:=menus.ssn("//*[@clean='" label "']"),ea:=xml.ea(top)
	Menu,% ssn(top.ParentNode,"@name").text,ToggleCheck,% ea.name
}