New_File_Template(){
	setup(28)
	Gui,Add,Edit,w500 r30,% settings.ssn("//template").text
	Gui,Show,% Center(28),New File Template
	return
	28GuiEscape:
	28GuiClose:
	ControlGetText,edit,Edit1,% hwnd([28])
	settings.Add({path:"template",text:edit})
	hwnd({rem:28})
	return
}