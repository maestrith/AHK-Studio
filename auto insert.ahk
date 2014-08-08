Auto_Insert(){
	static
	setup(20)
	Gui,Add,ListView,w200 h200 AltSubmit gchange,Entered Key|Added Key
	Gui,Add,Text,,Entered Key:
	Gui,Add,Edit,venter x+10 w50
	Gui,Add,Text,xm,Added Key:
	Gui,Add,Edit,vadd x+10 w50
	Gui,Add,Button,xm gaddkey Default,Add Keys
	Gui,Add,Button,x+10 gremkey,Remove Selected
	autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1)
		ea:=xml.ea(aa),LV_Add("",Chr(ea.trigger),Chr(ea.add))
	Gui,Show,,Auto Insert
	return
	change:
	if A_GuiEvent not in Normal,i
		return
	if !LV_GetNext()
		return
	LV_GetText(in,LV_GetNext()),LV_GetText(out,LV_GetNext(),2)
	ControlSetText,Edit1,%in%,% hwnd([20])
	ControlSetText,Edit2,%out%,% hwnd([20])
	return
	addkey:
	Gui,Submit,Nohide
	if !(enter&&add)
		return m("Both values need to be filled in")
	if StrLen(enter)!=1||StrLen(add)!=1
		return m("Both values must be a single character")
	dup:=1
	if settings.ssn("//autoadd/key[@trigger='" Asc(enter) "']")
		LV_Delete(LV_GetNext()),dup:=0
	settings.add({path:"autoadd/key",att:{trigger:Asc(enter),add:Asc(add)},dup:dup})
	LV_Add("",enter,add)
	Loop,2
		ControlSetText,Edit%A_Index%,,% hwnd([20])
	ControlFocus,Edit1,% hwnd([20])
	bracesetup()
	return
	remkey:
	while,LV_GetNext(){
		LV_GetText(trigger,LV_GetNext())
		Hotkey,IfWinActive,% hwnd([1])
		Hotkey,%trigger%,Off
		rem:=settings.ssn("//autoadd/key[@trigger='" Asc(trigger) "']")
		rem.ParentNode.RemoveChild(rem)
		LV_Delete(LV_GetNext())
	}
	Loop,2
		ControlSetText,Edit%A_Index%,,% hwnd([20])
	return
	20GuiClose:
	20GuiEscape:
	hwnd({rem:20})
	return
}