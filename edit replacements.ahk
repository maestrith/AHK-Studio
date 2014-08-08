edit_replacements(){
	static
	er:=setup(7),window({win:7,gui:["ListView,w400 h500 ger AltSubmit,Value|Replacement","Text,,Value:","Edit,x+10 w200 vvalue","Text,xm,Replacement:","Edit,x+10 w200 vreplacement gedrep","Button,xm geradd Default,Add","Button,x+10 gerremove,Remove Selected"]}),sn:=settings.sn("//replacements/*")
	while,val:=sn.item(A_Index-1)
		LV_Add("",ssn(val,"@replace").text,val.text)
	LV_Modify(1,"Select Focus Vis")
	Gui,Show,,Replacements
	return
	edrep:
	info:=[]
	for a,b in {replacement:1,value:2}{
		ControlGetText,value,Edit%b%,% hwnd([7])
		info[a]:=value
	}
	if item:=settings.ssn("//replacements/replacement[@replace='" info.replacement "']")
		item.text:=info.value,LV_Modify(LV_GetNext(),"Col2",info.value)
	return
	eradd:
	rep:=window({get:7})
	if !(rep.replacement&&rep.value)
		return m("both values are required")
	if !settings.ssn("//replacements/*[@replace='" rep.value "']")
		settings.add({path:"replacements/replacement",att:{replace:rep.value},text:rep.replacement,dup:1}),LV_Add("",rep.value,rep.replacement)
	Loop,2
		ControlSetText,Edit%A_Index%
	ControlFocus,Edit1
	return
	er:
	LV_GetText(rep,LV_GetNext()),LV_GetText(rep1,LV_GetNext(),2)
	for a,b in {Edit1:rep,Edit2:rep1}
		ControlSetText,%a%,%b%,% hwnd([7])
	return
	err:
	ControlGetFocus,focus,% hwnd([7])
	if Focus=SysListView321
		goto erremove
	return
	erremove:
	Gui,7:Default
	while,LV_GetNext(),LV_GetText(value,LV_GetNext())
		rem:=settings.ssn("//replacements/*[@replace='" value "']"),LV_Delete(LV_GetNext()),rem.ParentNode.RemoveChild(rem)
	return
	7GuiClose:
	7GuiEscape:
	hwnd({rem:7})
	return
}