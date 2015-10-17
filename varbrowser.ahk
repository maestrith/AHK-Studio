varbrowser(){
	static newwin,treeview
	if(!WinExist(hwnd([97])))
		newwin:=new windowtracker(97),newwin.add(["TreeView,w300 h400 gvalue vtreeview AltSubmit hwndtreeview,,wh","Button,greloadvar,Reload Variables,y"]),newwin.show("Variable Browser")
	return
	97GuiEscape:
	97GuiClose:
	hwnd({rem:97})
	return
	value:
	if A_GuiEvent!=Normal
		return
	if value:=v.variablelist[A_EventInfo]{
		ei:=A_EventInfo,newvalue:=InputBox(newwin.TreeView,"Current value for " value.variable,"Change value for " value.variable,value.value)
		if ErrorLevel
			return
		debug.send("property_set -n " value.variable " -- " debug.encode(newvalue)),TV_Modify(ei,"",value.variable " = " newvalue)
	}
	return
	reloadvar:
	Gui,97:Default
	TV_Delete(),listvars()
	return
}