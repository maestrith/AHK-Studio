QFS(){
	ControlGet,value,Checked,,%A_GuiControl%,% hwnd([1])
	settings.ssn("//Quick_Find_Settings").SetAttribute(clean(A_GuiControl),value)
	v.options[clean(A_GuiControl)]:=value,qf()
}