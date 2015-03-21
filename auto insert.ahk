Auto_Insert(){
	static
	wname:="Auto_Insert",newwin:=new windowtracker(wname)
	newwin.Add(["ListView,w200 h200 AltSubmit gchange,Entered Key|Added Key,wh","Text,,Entered Key:,y","Edit,venter x+10 w50,,yw","Text,xm,Added Key:,y","Edit,vadd x+10 w50,,yw","Button,xm gaddkey Default,Add Keys,y","Button,x+10 gremkey,Remove Selected,y"])
	newwin.Show("Auto Insert"),autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1)
		ea:=xml.ea(aa),LV_Add("",Chr(ea.trigger),Chr(ea.add))
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
	if StrLen(enter)!=1||StrLen(add)!=1
		return m("Both values must be a single character")
	dup:=1
	
	if settings.ssn("//autoadd/key[@trigger='" Asc(enter) "']")
		LV_Delete(LV_GetNext()),dup:=0
	settings.add2("autoadd/key",{trigger:Asc(enter),add:Asc(add)},dup),LV_Add("",enter,add)
	Loop,2
		ControlSetText,Edit%A_Index%,,% hwnd([wname])
	ControlFocus,Edit1,% hwnd([wname])
	bracesetup()
	return
	remkey:
	while,LV_GetNext(){
		LV_GetText(trigger,LV_GetNext())
		Hotkey,IfWinActive,% hwnd([1])
		Hotkey,%trigger%,Off
		rem:=settings.ssn("//autoadd/key[@trigger='" Asc(trigger) "']"),rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
	}
	Loop,2
		ControlSetText,Edit%A_Index%,,% hwnd([wname])
	return
	Auto_InsertGuiClose:
	Auto_InsertGuiEscape:
	hwnd({rem:wname})
	return
}