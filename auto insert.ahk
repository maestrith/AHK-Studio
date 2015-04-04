Auto_Insert(){
	static
	wname:="Auto_Insert",newwin:=new windowtracker(wname)
	newwin.Add(["ListView,w200 h200 AltSubmit gchange,Entered Key|Added Key,wh","Text,,Entered Key:,y","Edit,venter x+10 w50,,yw","Text,xm,Added Key:,y","Edit,vadd x+10 w50,,yw","Button,xm gaddkey Default,Add Keys,y","Button,x+10 gremkey,Remove Selected,y"])
	newwin.Show("Auto Insert"),autoadd:=settings.sn("//autoadd/*")
	while,aa:=autoadd.item(a_index-1){
		insert:=[]
		ea:=xml.ea(aa)
		for c,d in {trigger:ea.trigger,add:ea.add}
			for e,f in StrSplit(d,",")
				Insert[c].=Chr(f)
		LV_Add("",insert.trigger,insert.add)
	}
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
	trigger:=replace:=""
	for a,b in StrSplit(enter)
		trigger.=Asc(b) ","
	trigger:=Trim(trigger,",")
	for a,b in StrSplit(add,",")
		replace.=Asc(b) ","
	replace:=Trim(replace,",")
	dup:=1
	if settings.ssn("//autoadd/key[@trigger='" trigger "']")
		LV_Delete(LV_GetNext()),dup:=0
	if !settings.ssn("//autoadd/key[@trigger='" trigger "']")
		settings.add2("autoadd/key",{trigger:trigger,add:replace},"",1),LV_Add("",enter,add)
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