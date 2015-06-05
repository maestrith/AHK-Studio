Custom_Commands(){
	static
	setup(31)
	Gui,Add,TreeView,w300 h200 gcctv AltSubmit
	for a,b in ["Text,,Command:","Edit,w300 vcommand","Text,,Syntax:","Edit,w300 r3 vsyntax"]{
		info:=StrSplit(b,",")
		Gui,Add,% info.1,% info.2,% info.3
	}
	Gui,Add,Button,gccadd,Add/Update Custom Command
	Gui,Add,Button,gccdel,Delete Custom Command
	Gosub,ccpop
	Gui,Show,% center(31),Custom Commands
	return
	31GuiClose:
	31GuiEscape:
	hwnd({rem:31})
	cmds:=settings.sn("//commands/*")
	while,cc:=cmds.item[A_Index-1]
		cc.RemoveAttribute("tv")
	keywords()
	return
	ccadd:
	Gui,31:Submit,Nohide
	if !(command&&syntax)
		return m("A command and syntax are required")
	if(node:=settings.ssn("//commands/commands[text()='" command "']"))
		return node.SetAttribute("syntax",syntax),m("here")
	new:=settings.add2("commands/commands",{syntax:syntax},command,1)
	goto,ccpop
	return
	ccdel:
	Gui,31:Default
	if(!TV_GetSelection())
		return m("Select something to delete")
	next:=TV_GetNext(TV_GetSelection())
	rem:=settings.ssn("//commands/commands[@tv='" TV_GetSelection() "']")
	rem.ParentNode.RemoveChild(rem)
	TV_Modify(next?next:TV_GetNext(0),"Select Vis Focus")
	ccpop:
	Gui,31:Default
	TV_Delete(),cmds:=settings.sn("//commands/*")
	while,cc:=cmds.item[A_Index-1]
		cc.SetAttribute("tv",TV_Add(cc.text))
	return
	cctv:
	if node:=settings.ssn("//commands/commands[@tv='" A_EventInfo "']"),ea:=xml.ea(node){
		ControlSetText,Edit1,% node.text,% hwnd([31])
		ControlSetText,Edit2,% ea.syntax,% hwnd([31])
	}
	return
}