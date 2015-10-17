debug_settings(){
	static
	if(!feature:=settings.ssn("//features"))
		feature:=settings.add2("features")
	setup(26),ea:=settings.ea(feature)
	for a,b in ["max_depth","max_children"]{
		Gui,26:Add,Text,,%b%
		Gui,26:Add,Edit,w200 gdsedit v%b% number,% ea[b]
	}
	Gui,26:Show,,Debug Settings
	return
	dsedit:
	for a,b in ["max_depth","max_children"]{
		ControlGetText,value,Edit%A_Index%,% hwnd([26])
		feature.SetAttribute(b,value)
	}
	return
	26GuiEscape:
	26GuiClose:
	hwnd({rem:26})
	return
}