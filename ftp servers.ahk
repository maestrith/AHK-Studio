ftp_servers(){
	static listview
	newwin:=new windowtracker(9)
	newwin.Add(["ListView,w300 h300 hwndlistview -Multi,Server|Username|Password|Port,wh","Button,gnewserver,New Server,y","Button,gdeleteserver,Delete Server,y"])
	ControlGet,listview,hwnd,,SysListView321,% hwnd([9])
	popftp()
	newwin.Show("FTP Server Settings")
	return
	9GuiEscape:
	9GuiClose:
	hwnd({rem:9})
	return
	newserver:
	address:=InputBox(listview,"Server Address","Input the address of the server")
	if ErrorLevel
		return
	if settings.ssn("//ftp/server[@name='" name "']")
		return m("Server Already Exists")
	username:=InputBox(listview,"Username","Username")
	if ErrorLevel
		return
	password:=InputBox(listview,"Password","Password")
	if ErrorLevel
		return
	port:=InputBox(listview,"Port","Port",21)
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