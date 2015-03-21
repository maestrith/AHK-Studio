varbrowser(){
	static treeview
	if !WinExist(hwnd([97])){
		setup(97)
		Gui,Add,TreeView,w300 h400 gvalue AltSubmit hwndtreeview
		Gui,Add,Button,greloadvar,Reload Variables
		Gui,Show,,Variable Browser
	}
	return
	97GuiEscape:
	97GuiClose:
	hwnd({rem:97})
	return
	value:
	if A_GuiEvent!=Normal
		return
	if value:=v.variablelist[A_EventInfo]{
		ei:=A_EventInfo
		newvalue:=InputBox(TreeView,"Current value for " value.variable,"Change value for " value.variable,value.value)
		if ErrorLevel
			return
		debug.send("property_set -n " value.variable " -- " debug.encode(newvalue))
		TV_Modify(ei,"",value.variable " = " newvalue)
	}
	return
	reloadvar:
	listvars()
	return
}