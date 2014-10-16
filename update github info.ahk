update_github_info(){
	static
	;class-ify or remove
	info:=settings.ea("//github"),setup(25)
	controls:={owner:"Owner (GitHub Username)",email:"Email",name:"Your Full Name"}
	for a,b in {owner:100,email:200,name:100}{
		Gui,Add,Text,xm,% controls[a]
		Gui,Add,Edit,x+5 w%b% gupdate v%a%,% info[a]
	}
	Gui,Add,Text,xm,Github Token
	Gui,Add,Edit,xm w300 Password gupdate vtoken,% info.token
	Gui,Add,Button,ggettoken,Get A Token
	Gui,Show,,Github Information
	return
	update:
	Gui,25:Submit,NoHide
	if !hub:=settings.ssn("//github")
		hub:=settings.Add({path:"github"})
	for a,b in {owner:owner,email:email,name:name,token:token}
		hub.SetAttribute(a,b)
	return
	25GuiEscape:
	25GuiClose:
	hwnd({rem:25})
	if WinExist(hwnd([10]))
		WinActivate,% hwnd([10])
	return
	gettoken:
	Run,https://github.com/settings/applications
	return
}