tv(tv=0,open=""){
	static lastcurrent
	Gui,1:Default
	Gui,1:TreeView,% hwnd("fe")
	TV_Modify(tv,"Select Vis Focus")
	if !open
		return
	tv:
	if (A_GuiEvent="S"||open){
		if !v.startup
			getpos(),count:=0
		ei:=open?tv:a_eventinfo,sc:=csc()
		file:=files.ssn("//*[@tv='" ei "']")
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
					return m("error")
				goto tvtop
			}
			sc.2358(0,doc)
			fn:=ssn(file,"@file").text
			tt:=update({get:fn})
			length:=VarSetCapacity(text,strput(tt,"utf-8"))
			StrPut(tt,&text,length,"utf-8")
			sc.2037(65001),sc.2181(0,&text),set(),sc.2175
			file.SetAttribute("sc",doc)
		}else
		sc.2358(0,doc.text)
		marginwidth(sc)
		current(1).SetAttribute("last",ssn(file,"@file").text)
		current:=ssn(current(1),"@file").text
		GuiControl,1:+Redraw,% sc.sc
		setpos(ei)
		lastcurrent:=current
	}
	return
}