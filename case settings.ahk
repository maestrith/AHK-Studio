Custom_case_settings(){
	static ccs
	setup(29)
	Gui,Add,Text,,Enter a space delimited list of words in whatever case you like
	Gui,Add,Edit,w500 h200 gupdateccs vccs,% settings.ssn("//custom_case_settings").text
	Gui,Show,% Center(29),Custom Case Settings
	return
	updateccs:
	Gui,29:Submit,Nohide
	if !custom:=settings.ssn("//custom_case_settings")
		custom:=settings.add2("custom_case_settings")
	custom.text:=ccs
	return
	29GuiClose:
	29GuiEscape:
	hwnd({rem:29}),keywords()
	return
}