upload(winname="Upload"){
	static
	uphwnd:=setup(10)
	window({win:10,gui:["Text,Section,Version:","Edit,w200 vversion x+5 ys-2","text,x+5,.","Edit,x+5 w100 vincrement","UpDown,gincrement Range0-2000 0x80","Text,xs,Version Information:","Edit,w400 h400 vversioninfo"
	,"Text,Section,Upload directory:","Edit,vdir w200 x+10 ys-2","Text,section xm,Ftp Server:","DDL,x+10 ys-2 w200 vserver","Checkbox,vcompile xm,Compile","Checkbox,vgistversion xm Disabled,Update Gist Version","Checkbox,vupver,Upload without progress bar (a bit more stable)","Checkbox,vversstyle,Remove (Version=) from the " chr(59) "auto_version"
	,"Checkbox,vupgithub,Update GitHub","Button,w200 gupload1 xm Default,Upload"]})
	file:=ssn(current(1),"@file").text
	list:=settings.sn("//ftp/server/@name"),lst:="|Choose a server...|"
	while,ll:=list.item[A_Index-1]
		lst.="|" ll.text
	GuiControl,10:,ComboBox1,%lst%
	Gui,show,AutoSize,%winname%
	node:=vversion.ssn("//info[@file='" file "']")
	GuiControl,10:ChooseString,ComboBox1,% ssn(node,"@server").text
	list:={compile:"Button1",version:"Edit1",increment:"Edit2",dir:"Edit4",gistversion:"Button2",upver:"Button3",versstyle:"Button4",upgithub:"Button5"}
	for a,b in vversion.ea(node){
		GuiControl,10:,% list[a],%b%
	}
	GuiControl,10:,Edit3,% vversion.ssn("//info[@file='" file "']").text
	ControlFocus,Edit3,% hwnd([10])
	Send,^{Home}{Down}
	return
	upload1:
	w:=window({get:10})
	ControlGetText,server,ComboBox1,ahk_id%uphwnd%
	if (server="Choose a server..."||server="")
		return m("Please choose a server")
	gosub 10guiescape
	if w.compile
		compile()
	f:=new ftp(server)
	if f.Error
		return
	r:=f.put(file,w.dir,w.compile)
	if r
		m("Transfer complete")
	if w.upgithub
		github_repository()
	return
	10GuiEscape:
	10GuiClose:
	file:=ssn(current(1),"@file").text
	att:=[],win:=window({get:10})
	for a,b in win
		if a=versioninfo
			text:=b
	else
		att[a]:=b
	att.file:=file
	uq:=vversion.unique({path:"info",att:att,check:"file"}),uq.text:=text
	vversion.Transform(),vversion.save()
	hwnd({rem:10})
	ftp.cleanup()
	return
	increment:
	info:=window({get:10})
	ver:=info.version "." info.increment,
	search:=info.versioninfo
	if !RegExMatch(search,"\b" ver)
		ControlSetText,Edit3,% ver "`r`n`r`n" RegExReplace(info.versioninfo,"\n","`r`n"),% hwnd([10])
	ControlFocus,Edit3,% hwnd([10])
	Send,^{Home}{Down}
	return
}