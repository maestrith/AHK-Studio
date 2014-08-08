ftp_servers(){
	setup(9)
	Gui,Add,ListView,w300 h300,Server|Username|Password|Port
	Gui,Add,Button,gnewserver,New Server
	Gui,Add,Button,gdeleteserver,Delete Server
	popftp()
	Gui,Show,,FTP Server Settings
	return
	9GuiEscape:
	9GuiClose:
	hwnd({rem:9})
	return
	newserver:
	InputBox,address,Server Address,Input the address of the server
	if ErrorLevel
		return
	if settings.ssn("//ftp/server[@name='" name "']")
		return m("Server Already Exists")
	InputBox,username,Username,Username
	if ErrorLevel
		return
	InputBox,password,Password,Password
	if ErrorLevel
		return
	InputBox,port,Port,Port,,,,,,,,21
	if ErrorLevel
		return
	settings.add({path:"ftp/server",att:{address:address,name:address,password:password,port:port,username:username},dup:1})
	popftp()
	return
	deleteserver:
	if !count:=LV_GetCount()
		return
	LV_GetText(server,count)
	server:=settings.ssn("//ftp/server[@name='" server "']")
	server.parentnode.removechild(server)
	popftp()
	return
}