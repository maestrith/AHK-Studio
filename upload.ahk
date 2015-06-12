upload(winname="Upload"){
	static
	static ControlList:={compile:"Button1",dir:"Edit2",upver:"Button3",versstyle:"Button4",upgithub:"Button5"}
	uphwnd:=setup(10),lastver:="",compilever:="",list:=settings.sn("//ftp/server/@name"),lst:="Choose a server...|"
	while,ll:=list.item[A_Index-1]
		lst.="|" ll.text
	if list.length=1
		lst:=list.item[0].text "||"
	newwin:=new WindowTracker(10)
	vers:=new versionkeep(newwin),node:=vers.node
	newwin.add(["Text,xm Section,Upload directory:,y","Edit,vdir w100 x+10 ys-2,,yw,1","Text,section xm,FTP Server:,y","DDL,x+10 ys-2 w200 vserver," lst ",yw","Checkbox,vcompile xm,Compile,y","Checkbox,vgistversion xm Disabled,Update Gist Version,y","Checkbox,vupver,Upload without progress bar (a bit more stable),y","Checkbox,vversstyle,Remove (Version=) from the " chr(59) "auto_version,y","Checkbox,vupgithub,Update GitHub,y","Button,w200 gupload1 xm Default,Upload,y","Button,x+5 gverhelp -TabStop,Help,y"])
	file:=ssn(current(1),"@file").text
	newwin.Show("Upload")
	info:=""
	node:=vversion.ssn("//info[@file='" file "']")
	for a,b in vversion.ea(node)
		GuiControl,10:,% ControlList[a],%b%
	GuiControl,10:ChooseString,ComboBox1,% ssn(node,"@server").text
	vers.populate()
	TV_Modify(tv_getnext(0),"Select Vis Focus")
	ControlFocus,Edit1,% hwnd([10])
	return
	upload1:
	info:=newwin[]
	node:=vversion.ssn("//info[@file='" file "']")
	node.SetAttribute("versstyle",info.versstyle)
	if(info.server="Choose a server..."||info.server="")
		return m("Please choose a server")
	if(info.compile)
		compile()
	f:=new ftp(info.server)
	if f.Error
		return
	r:=f.put(file,info.dir,info.compile)
	if r
		m("Transfer complete")
	if info.upgithub
		github_repository()
	return
	10GuiEscape:
	10GuiClose:
	ToolTip,,,,2
	node:=vversion.ssn("//info[@file='" file "']")
	for a,b in newwin[]
		node.SetAttribute(a,b)
	ftp.cleanup(),hwnd({rem:10})
	return
	compilever:
	Gui,10:Default
	TV_GetText(ver,TV_GetSelection())
	WinGetPos,x,y,w,h,% hwnd([10])
	vertext:=vers.getver(ver)
	if (vertext)
		vertext:=ver "`r`n" Trim(vertext,"`r`n") "`r`n"
	else if !vertext
		m("Please select a version number to build a version list")
	if !compilever
		clipboard:=vertext,compilever:=1
	else
		Clipboard.=vertext
	ToolTip,%Clipboard%,%w%,0,2
	return
	clearver:
	clipboard:=""
	ToolTip,,,,2
	return
	wholelist:
	list:=sn(node,"versions/version")
	Clipboard:=""
	while,ll:=list.item[A_Index-1]
		Clipboard.=ssn(ll,"@number").text "`r`n" Trim(ll.text,"`r`n") "`r`n"
	m("Version list copied to your clipboard.","","",Clipboard)
	return
	verhelp:
	m("F1 to build a version list (will be copied to your Clipboard)`nF2 to clear the list`nF3 to copy your entire list to the Clipboard")
	return
}