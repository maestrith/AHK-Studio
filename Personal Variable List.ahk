Personal_Variable_List(){
	static
	newwin:=new windowtracker(6),newwin.Add(["ListView,w200 h400,Variables,wh","Edit,w200 vvariable,,yw","Button,gaddvar Default,Add,y","Button,x+10 gvdelete,Delete Selected,y"])
	newwin.Show("Variables",1),vars:=settings.sn("//Variables/*")
	ControlFocus,Edit1,% hwnd([6])
	while,vv:=vars.item(A_Index-1)
		LV_Add("",vv.text)
	ControlFocus,Edit1,% hwnd([6])
	return
	vdelete:
	while,LV_GetNext(){
		LV_GetText(string,LV_GetNext()),rem:=settings.ssn("//Variable[text()='" string "']")
		rem.parentnode.removechild(rem),LV_Delete(LV_GetNext())
	}
	return
	addvar:
	if !variable:=newwin[].variable
		return
	if !settings.ssn("//Variables/Variable[text()='" variable "']")
		settings.add({path:"Variables/Variable",text:variable,dup:1}),LV_Add("",variable)
	settings.Transform()
	ControlSetText,Edit1,,% hwnd([6])
	return
	6GuiClose:
	6GuiEscape:
	keywords(),hwnd({rem:6}),refreshthemes()
	return
}