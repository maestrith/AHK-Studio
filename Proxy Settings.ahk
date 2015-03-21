Proxy_Settings(){
	static
	setup(27)
	Gui,Add,Text,,Enter your proxy information eg. http://my.proxy.com:8080
	Gui,Add,Edit,w450 vproxy,% settings.ssn("//proxy").text
	Gui,Add,Button,gproxupdate Default,Update
	Gui,Show,% center(27),Proxy Settings
	return
	27GuiClose:
	27GuiEscape:
	hwnd({rem:27})
	return
	proxupdate:
	Gui,27:Submit,NoHide
	set:=settings.add({path:"proxy"}),set.text:=proxy
	hwnd({rem:27})
	return
}