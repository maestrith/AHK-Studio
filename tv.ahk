tv(tv:=0,open:="",history:=""){
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	TV_Modify(tv,"Select Vis Focus")
	if !open
		return
	tv:
	if(A_GuiEvent="DoubleClick"){
		item:=files.ssn("//*[@tv='" A_EventInfo "']")
		if(item.nodename!="openfile")
			return
		open(ssn(item,"@file").text,1)
	}
	if(A_GuiEvent="S"||open){
		SetTimer,matchfile,Off
		if !v.startup
			getpos(),count:=0
		ei:=open?tv:a_eventinfo,sc:=csc(),file:=files.ssn("//*[@tv='" ei "']"),fn:=ssn(file,"@file").text
		if(file.nodename!="file")
			return
		if !ssn(file,"@tv").text
			return
		if !doc:=ssn(file,"@sc"){
			tvtop:
			Sleep,10
			GuiControl,1:-Redraw,% sc.sc
			doc:=sc.2375
			if !doc
				doc:=sc.2376(0,doc)
			if !(doc){
				count++
				if count=3
					return
				goto,tvtop
			}
			sc.2358(0,doc),tt:=update({get:fn}),length:=VarSetCapacity(text,strput(tt,"utf-8")),StrPut(tt,&text,length,"utf-8"),sc.2037(65001),sc.2181(0,&text),set(),sc.2175,dup:=files.sn("//file[@file='" fn "']")
			while,dd:=dup.item[A_Index-1]
				dd.SetAttribute("sc",doc)
		}else
			sc.2358(0,doc.text),marginwidth(sc),current(1).SetAttribute("last",fn)
		GuiControl,1:+Redraw,% sc.sc
		setpos(ei),uppos(),marginwidth(sc)
		if(history!=1)
			history(fn)
		WinSetTitle,% hwnd([1]),,AHK Studio - %fn%
		sc.4004("fold",[1])
		Sleep,150
		SetTimer,matchfile,-300
	}
	return
	matchfile:
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	sc:=csc()
	doc:=sc.2357(),tv:=files.ssn("//*[@tv='" TV_GetSelection() "']"),ea:=xml.ea(tv)
	if(doc!=ea.sc)
		tv(TV_GetSelection(),1)
	return
}