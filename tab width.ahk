tab_width(){
	static
	setup(23),width:=settings.ssn("//tab").text?settings.ssn("//tab").text:5
	Gui,Add,Text,,Enter a number for the tab width
	Gui,Add,Edit,w100 vtabwidth gtabwidth,%width%
	Gui,Show,,Tab Width
	return
	23GuiEscape:
	23GuiClose:
	hwnd({rem:23})
	return
	tabwidth:
	Gui,Submit,Nohide
	csc().2036(tabwidth)
	settings.Add({path:"tab",text:tabwidth})
	return
}