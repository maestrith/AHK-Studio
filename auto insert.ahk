Auto_Insert(){
	static
	wname:="Auto_Insert",newwin:=new windowtracker(wname),newwin.Add(["ListView,w200 h200 AltSubmit gchange,Entered Key|Added Key,wh","Text,,Entered Key:,y","Edit,venter x+10 w100,,yw","Text,xm,Added Key:,y","Edit,vadd x+10 w100 Limit1,,yw","Button,xm gaddkey Default,Add Keys,y","Button,x+10 gremkey,Remove Selected,y"]),newwin.Show("Auto Insert")
	goto,popai
	return
	change:
	if A_GuiEvent not in Normal,i
		return
	if !LV_GetNext()
		return
	LV_GetText(in,LV_GetNext()),LV_GetText(out,LV_GetNext(),2)
	ControlSetText,Edit1,%in%,% hwnd([wname])
	ControlSetText,Edit2,%out%,% hwnd([wname])
	return
	addkey:
	value:=newwin[],enter:=value.enter,add:=value.add
	if !(enter&&add)
		return m("Both values need to be filled in")
	if(ff:=settings.ff("//autoadd/key/@trigger",enter))
		ff.SetAttribute("add",add)
	else
		if !settings.ssn("//autoadd/key[@trigger='" enter "']")
			settings.add2("autoadd/key",{trigger:enter,add:add},"",1)
	Gosub,popai
	Loop,2
		ControlSetText,Edit%A_Index%,,% hwnd([wname])
	ControlFocus,Edit1,% hwnd([wname])
	bracesetup()
	return
	remkey:
	while,LV_GetNext()
		LV_GetText(trigger,LV_GetNext()),trig:="",hk:=[],hk[trigger]:="brace",hotkeys([1],hk,"Off"),rem:=settings.ff("//autoadd/key/@trigger",trigger),rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
	Loop,2
		ControlSetText,Edit%A_Index%,,% hwnd([wname])
	return
	Auto_InsertGuiClose:
	Auto_InsertGuiEscape:
	hwnd({rem:wname}),SetMatch()
	return
	popai:
	LV_Delete(),autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1),ea:=xml.ea(aa)
		LV_Add("",ea.trigger,ea.add)
	return
}