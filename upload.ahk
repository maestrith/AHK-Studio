upload(winname="Upload"){
	static
	static ControlList:={compile:"Button3",version:"Edit1",dir:"Edit4",gistversion:"Button4",upver:"Button5",versstyle:"Button6",upgithub:"Button7"}
	uphwnd:=setup(10),lastver:=""
	list:=settings.sn("//ftp/server/@name"),lst:="Choose a server...|"
	while,ll:=list.item[A_Index-1]
		lst.="|" ll.text
	newwin:=new WindowTracker(10)
	newwin.Add(["Text,,Use Ctrl+Up/Down to increment the version`nF1 to build a version list","Text,Section,Version:","Edit,x+5 ys-2 w150 vversion,,w,1","Button,guladd x+5 -TabStop,Add Version,x","Text,xs,Versions:","TreeView,w360 h100 guplv AltSubmit -TabStop,,w","Button,xm gremver -TabStop,Remove Selected Version","Text,xs,Version Information:","Edit,xm w360 h200 -Wrap gupadd,,wh"
	,"Text,xm Section,Upload directory:,y","Edit,vdir w100 x+10 ys-2,,yw,1","Text,section xm,Ftp Server:,y","DDL,x+10 ys-2 w200 vserver," lst ",yw","Checkbox,vcompile xm,Compile,y","Checkbox,vgistversion xm Disabled,Update Gist Version,y","Checkbox,vupver,Upload without progress bar (a bit more stable),y","Checkbox,vversstyle,Remove (Version=) from the " chr(59) "auto_version,y"
	,"Checkbox,vupgithub,Update GitHub,y","Button,w200 gupload1 xm Default,Upload,y"])
	file:=ssn(current(1),"@file").text
	newwin.Show("Upload"),info:="",hotkeys([10],{"^up":"uup","^down":"udown",Delete:"uldel",Backspace:"uldel",F1:"compilever"})
	node:=vversion.ssn("//info[@file='" file "']")
	for a,b in vversion.ea(node)
		GuiControl,10:,% ControlList[a],%b%
	vers:=new versionkeep,node:=vers.node
	Gosub uploadpopulate
	LV_Modify(1,"Vis Focus Select")
	ControlFocus,Edit2,% hwnd([10])
	return
	uldel:
	ControlGetFocus,focus,% hwnd([10])
	if (Focus!="SysTreeView321"){
		ControlSend,%focus%,{%A_ThisHotkey%},% hwnd([10])
		Return
	}
	else
		goto remver
	Return
	uup:
	udown:
	uladd:
	if start:=vers.UpDown(10,"Edit1",A_ThisLabel)
		node:=vers.Add(start)
	goto uploadpopulate
	Return
	upadd:
	ControlGetText,cv,Edit1,% hwnd([10])
	if !ssn(node,"versions/version[@number='" cv "']"){
		Gosub uladd
		ControlFocus,Edit2,% hwnd([10])
	}
	ControlGetText,text,Edit2,% hwnd([10])
	set:=ssn(node,"versions/version[@version='" cv "']")
	vers.settext(cv,text)
	return
	upload1:
	info:=newwin[]
	if (info.server="Choose a server..."||info.server="")
		return m("Please choose a server")
	if info.compile
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
	26GuiClose:
	26GuiEscape:
	hwnd({rem:26})
	node:=vversion.ssn("//info[@file='" file "']")
	for a,b in newwin[]
		node.SetAttribute(a,b)
	ftp.cleanup(),hwnd({rem:10})
	return
	uploadpopulate:
	Gui,10:Default
	GuiControl,10:-Redraw,SysTreeView321
	list:=vers.list(),TV_Delete(),value:=newwin[].version
	while,ll:=list.item[A_Index-1]
		num:=ssn(ll,"@number").text,tv:=TV_Add(num),tt:=num=value?tv:tt
	GuiControl,10:+Redraw,SysTreeView321
	TV_Modify(_:=tt?tt:TV_GetChild(0),"Select Vis Focus")
	return
	uplv:
	if A_GuiEvent!=s
		return
	TV_GetText(ver,TV_GetSelection())
	ControlSetText,Edit2,% vers.getver(ver),% hwnd([10])
	ControlSetText,Edit1,%ver%,% hwnd([10])
	ControlSend,Edit2,^{End},% hwnd([10])
	return
	remver:
	Gui,10:Default
	node:=vversion.ssn("//info[@file='" file "']")
	TV_GetText(ver,TV_GetSelection())
	rem:=ssn(node,"versions/version[@number='" ver "']")
	rem.ParentNode.RemoveChild(rem)
	TV_Delete(TV_GetSelection())
	return
	compilever:
	Gui,10:Default
	TV_GetText(ver,TV_GetSelection())
	vertext:=vers.getver(ver)
	if (hwnd(26)=""&&vertext){
		compilever()
		ControlSetText,Edit1,%ver%`r`n%vertext%,% hwnd([26])
	}else if !vertext{
		m("Please select a version number to build a version list")
	}else if hwnd(26){
		ControlGetText,cvt,% Edit1,% hwnd([26])
		ControlSetText,Edit1,% cvt ver "`r`n" vertext,% hwnd([26])
	}
	return
}
compilever(){
	static
	Gui,26:+hwndhwnd
	Gui,26:Add,Edit,w500 h500
	Gui,26:Show,x0 y0 NA,Version
	hwnd(26,hwnd)
	return
}