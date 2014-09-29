debug_settings(){
	static
	setup(26),feature:=settings.ssn("//features"),ea:=settings.ea(feature)
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