upload(winname="Upload"){
	static
	static ControlList:={compile:"Button2",version:"Edit1",increment:"Edit2",dir:"Edit4",gistversion:"Button3",upver:"Button4",versstyle:"Button5",upgithub:"Button6"}
	uphwnd:=setup(10),lastver:=""
	list:=settings.sn("//ftp/server/@name"),lst:="Choose a server...|"
	while,ll:=list.item[A_Index-1]
		lst.="|" ll.text
	newwin:=new WindowTracker(10)
	newwin.Add(["Text,Section,Version:","Edit,x+5 ys-2 w263 vversion,,w,1","text,x+5,.,x","Edit,x+5 w50,,x","UpDown,gincrement vincrement Range0-2000 0x80,,x,1","Text,xs,Version Information:","ListView,w100 h200 guplv AltSubmit NoSortHdr -TabStop,Version,h","Edit,x+10 w280 h200 -Wrap gupadd,,wh","Button,xm gremver -TabStop,Remove Selected Versions,y"
	,"Text,xm Section,Upload directory:,y","Edit,vdir w200 x+10 ys-2,,yw,1","Text,section xm,Ftp Server:,y","DDL,x+10 ys-2 w200 vserver," lst ",yw","Checkbox,vcompile xm,Compile,y","Checkbox,vgistversion xm Disabled,Update Gist Version,y","Checkbox,vupver,Upload without progress bar (a bit more stable),y","Checkbox,vversstyle,Remove (Version=) from the " chr(59) "auto_version,y"
	,"Checkbox,vupgithub,Update GitHub,y","Button,w200 gupload1 xm Default,Upload,y"])
	file:=ssn(current(1),"@file").text
	newwin.Show("Upload"),info:=""
	node:=vversion.ssn("//info[@file='" file "']")
	for a,b in vversion.ea(node)
		GuiControl,10:,% ControlList[a],%b%
	if !versions:=ssn(node,"versions"){
		if !FileExist("lib\version backup.xml")
			FileCopy,lib\version.xml,lib\version backup.xml,1
		info:=node.text,node.text:=""
		versions:=vversion.under({under:node,node:"versions"}),vn:="",top:=""
		for a,b in StrSplit(info,"`n","`r`n"){
			if !RegExReplace(b,"(\d|\.)"){
				vn:=b
				top:=vversion.under({under:versions,node:"version",att:{number:b}})
			}else{
				if !top
					top:=vversion.under({under:versions,node:"version",att:{number:"1.0"}})
				top.text:=top.text "`r`n" b
			}
		}
	}
	Gosub uploadpopulate
	LV_Modify(1,"Vis Focus Select")
	ControlFocus,Edit3,% hwnd([10])
	return
	upadd:
	ControlGetText,text,Edit3,% hwnd([10])
	info:=newwin[],ver:=info.version "." info.increment
	if !cnode:=ssn(node,"versions/version[@number='" ver "']")
		Goto increment
	cnode.text:=text
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
	r:=f.put(file,w.dir,w.compile)
	if r
		m("Transfer complete")
	if info.upgithub
		github_repository()		
	return
	10GuiEscape:
	10GuiClose:
	node:=vversion.ssn("//info[@file='" file "']")
	for a,b in newwin[]
		node.SetAttribute(a,b)
	ftp.cleanup(),hwnd({rem:10})
	return
	increment:
	info:=newwin[],ver:=info.version "." info.increment,cv:=RegExReplace(ver,"(\.|\D)"),list:=sn(node,"versions/version")
	node:=vversion.ssn("//info[@file='" file "']")
	if ssn(node,"versions/version[@number='" ver "']")
		Return
	root:=ssn(node,"versions"),new:=vversion.under({under:root,node:"version",att:{number:ver}})
	while,ll:=list.item[A_Index-1]{
		vv:=RegExReplace(ssn(ll,"@number").Text,"(\.|\D)")
		if (cv>vv){
			root.insertbefore(new,ll)
			Break
		}
	}
	uploadpopulate:
	Gui,10:Default
	list:=sn(node,"versions/*"),LV_Delete()
	while,ll:=list.item[A_Index-1]
		num:=ssn(ll,"@number").text,LV_Add("",num)
	LV_Modify(1,"Select Vis Focus AutoHDR")
	return
	uplv:
	if !LV_GetNext()
		return
	LV_GetText(ver,LV_GetNext()),main:=SubStr(ver,1,InStr(ver,".",0,0,1)-1),inc:=RegExReplace(ver,main ".")
	if (ver!=lastver)
		lastver:=ver
	else
		return
	if (main=""&&inc="")
		return
	for a,b in [main,inc]
		ControlSetText,Edit%A_Index%,%b%,% hwnd([10])
	info:=vversion.ssn("//info[@file='" file "']/versions/version[@number='" ver "']")
	GuiControl,10:-Redraw,Edit3
	text:=info.text?RegExReplace(info.text,"\n","`r`n") "`r`n":""
	ControlSetText,Edit3,% text,% hwnd([10])
	ControlFocus,Edit3,% hwnd([10])
	Sleep,100
	ControlSend,Edit3,^{End},% hwnd([10])
	GuiControl,10:+Redraw,Edit3
	return
	remver:
	node:=vversion.ssn("//info[@file='" file "']")
	while,LV_GetNext(){
		LV_GetText(vn,LV_GetNext())
		rem:=ssn(node,"versions/version[@number='" vn "']")
		rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
	}
	goto uploadpopulate
	return
}