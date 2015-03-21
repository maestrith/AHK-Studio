Widths(){
	static projectwidth,codewidth
	setup(24)
	WinGetPos,,,width,,% hwnd([1])
	Gui,Add,Text,,Project Explorer
	Gui,Add,Slider,Range0-%width% gprojectwidth vprojectwidth AltSubmit,% project:=settings.get("//gui/@projectwidth",200)
	check:=v.options.Hide_Project_Explorer?"Checked":""
	Gui,Add,Checkbox,ghpe %check%,Hide
	Gui,Add,Text,,Code Explorer
	Gui,Add,Slider,Range0-%width% gcodewidth vcodewidth AltSubmit,% code:=settings.get("//gui/@codewidth",200)
	check:=v.options.Hide_Code_Explorer?"Checked":""
	Gui,Add,Checkbox,ghce %check%,Hide
	Gui,Show,,GUI Widths
	return
	projectwidth:
	codewidth:
	Gui,24:Submit,NoHide
	value:=A_ThisLabel="projectwidth"?projectwidth:A_ThisLabel="codewidth"?codewidth:""
	attribute:=settings.Add({path:"gui"})
	attribute.SetAttribute(A_ThisLabel,value)
	Resize()
	return
	24GuiClose:
	24GuiEscape:
	hwnd({rem:24})
	return
	hce:
	return Label("Hide_Code_Explorer")
	hpe:
	return Label("Hide_Project_Explorer")
}
Label(label){
	SetTimer,%Label%,10
	sleep,11
	SetTimer,%label%,Off
}