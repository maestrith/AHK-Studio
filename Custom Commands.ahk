Custom_Commands(){
	static
	setup(31)
	for a,b in ["TreeView,w300 h200 gcctv AltSubmit","Text,,Command:","Edit,w300 vcommand","Text,,Syntax:","Edit,w300 r3 vsyntax","Button,gccadd,Add/Update Custom Command","Button,gccdel,Delete Custom Command"]{
		info:=StrSplit(b,",")
		Gui,Add,% info.1,% info.2,% info.3
	}hotkeys([31],{"delete":"ccdel"})
	Gosub,ccpop
	Gui,Show,% center(31),Custom Commands
	return
	31GuiClose:
	31GuiEscape:
	hwnd({rem:31}),cmds:=settings.sn("//commands/*")
	while,cc:=cmds.item[A_Index-1]
		cc.RemoveAttribute("tv")
	keywords()
	return
	ccadd:
	Gui,31:Submit,Nohide
	if !(command&&syntax)
		return m("A command and syntax are required")
	if(node:=settings.ssn("//commands/commands[text()='" command "']"))
		return node.SetAttribute("syntax",syntax)
	settings.add2("commands/commands",{syntax:syntax},command,1)
	goto,ccpop
	return
	ccdel:
	Gui,31:Default
	if(!TV_GetSelection())
		return m("Select something to delete")
	next:=TV_GetNext(TV_GetSelection()),settings.ssn("//commands/commands[@tv='" next "']").SetAttribute("sel",1),rem:=settings.ssn("//commands/commands[@tv='" TV_GetSelection() "']"),rem.ParentNode.RemoveChild(rem)
	ccpop:
	Gui,31:Default
	TV_Delete(),cmds:=settings.sn("//commands/*")
	while,cc:=cmds.item[A_Index-1],ea:=xml.ea(cc)
		cc.SetAttribute("tv",TV_Add(cc.text,0,ea.sel?"Select Vis Focus":""))
	return
	cctv:
	if node:=settings.ssn("//commands/commands[@tv='" A_EventInfo "']"),ea:=xml.ea(node)
		for a,b in {Edit1:node.text,Edit2:ea.syntax}
			ControlSetText,%a%,%b%,% hwnd([31])
	return
}