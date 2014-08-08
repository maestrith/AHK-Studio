Personal_Variable_List(){
	static
	qf:=setup(6)
	Gui,Add,ListView,w200 h400,Variables
	Gui,Add,Edit,w200 vvariable
	Gui,Add,Button,gaddvar Default,Add
	Gui,Add,Button,x+10 gvdelete,Delete Selected
	ControlFocus,Edit1,% hwnd([6])
	Gui,Show,,Variables
	vars:=settings.sn("//Variables/*")
	while,vv:=vars.item(A_Index-1)
		LV_Add("",vv.text)
	ControlFocus,Edit1,% hwnd([6])
	return
	vdelete:
	while,LV_GetNext(){
		LV_GetText(string,LV_GetNext())
		this:=settings.ssn("//Variable[text()='" string "']")
		this.parentnode.removechild(this)
		LV_Delete(LV_GetNext())
	}
	return
	addvar:
	Gui,6:Submit,Nohide
	if !variable
		return
	if !settings.ssn("//Variables/Variable[text()='" variable "']")
		settings.add({path:"Variables/Variable",text:variable,dup:1}),LV_Add("",variable)
	settings.Transform()
	ControlSetText,Edit1,,% hwnd([6])
	return
	6GuiClose:
	6GuiEscape:
	keywords(),hwnd({rem:6})
	refreshthemes()
	return
}