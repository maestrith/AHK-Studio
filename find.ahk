find(){
	static
	sc:=csc(),order:=[],file:=current(2).file,infopos:=positions.ssn("//*[@file='" file "']"),last:=ssn(infopos,"@search").text,search:=last?last:"Type in your query here",ea:=settings.ea("//search/find"),newwin:=new windowtracker(5),value:=[]
	order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.textrange(order.MinIndex(),order.MaxIndex()):last
	for a,b in ea
		value[a]:=b?"Checked":""
	newwin.Add(["Edit,gfindcheck w500 vfind r1,,w","TreeView,w500 h300 AltSubmit gstate,,wh","Checkbox,vregex " value.regex ",Regex Search,y","Checkbox,vgr x+10 " value.gr ",Greed,y","Checkbox,xm vcs " value.cs ",Case Sensitive,y","Checkbox,vsort gfsort " value.sort ",Sort by Segment,y","Checkbox,vallfiles " value.allfiles ",Search in All Files,y","Button,gsearch Default,   Search   ,y","Button,gcomment,Toggle Comment,y"])
	newwin.Show("Search")
	ControlSetText,Edit1,%last%,% hwnd([5])
	ControlSend,Edit1,^a,% hwnd([5])
	return
	findcheck:
	ControlGetText,Button,Button6,% hwnd([5])
	if (Button!="search")
		ControlSetText,Button6,Search,% hwnd([5])
	return
	search:
	ControlGetText,Button,Button6,% hwnd([5])
	if (InStr(button,"search")){
		ea:=newwin[],count:=0
		if !find:=ea.find
			return
		infopos.setattribute("search",find),foundinfo:=[]
		Gui,5:Default
		GuiControl,5:+g,SysTreeView321
		GuiControl,5:-Redraw,SysTreeView321
		list:=ea.allfiles?files.sn("//file/@file"):sn(current(1),"descendant::file/@file"),contents:=update("get").1,TV_Delete()
		pre:="m`nO",pre.=ea.cs?"":"i",pre.=ea.greed?"":"U",parent:=0,ff:=ea.regex?find:"\Q" find "\E"
		while,l:=list.item(A_Index-1){
			out:=contents[l.text],found:=1,r:=0,fn:=l.text
			SplitPath,fn,file
			while,found:=RegExMatch(out,pre ")(^.*" ff ".*$)",pof,found){
				if (ea.sort&&lastl!=fn)
					parent:=TV_Add(fn)
				np:=found=1?0:StrPut(SubStr(out,1,found),"utf-8")-1-(StrPut(SubStr(pof.1,1,1),"utf-8")-1)
				fpos:=1
				while,fpos:=RegExMatch(pof.1,pre ")[^.*]?(" ff ")",loof,fpos){
					add:=loof.Pos(1)-1,foundinfo[TV_Add(loof.1 " : " Trim(pof.1,"`t"),parent)]:={start:np+add,end:np+add+StrPut(loof.1,"Utf-8")-1,file:l.text}
					fpos+=StrLen(loof.1)
				}
				found:=pof.Pos(1)+pof.len(1)-1
				lastl:=fn,count++
			}
		}
		WinSetTitle,% hwnd([5]),,Find : %count%
		if TV_GetCount()
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		SetTimer,findlabel,-200
		GuiControl,5:+gstate,SysTreeView321
	}else if (Button="jump"){
		ea:=foundinfo[TV_GetSelection()],sc:=csc(),tv(files.ssn("//*[@file='" ea.file "']/@tv").text)
		Sleep,100
		sc.2160(ea.start,ea.end),sc.2169
		if(v.options.auto_close_find)
			hwnd({rem:5})
	}else{
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
		SetTimer,findlabel,-200
	}
	return
	state:
	if(A_GuiEvent="DoubleClick"){
		ea:=foundinfo[TV_GetSelection()],sc:=csc(),tv(files.ssn("//*[@file='" ea.file "']/@tv").text)
		Sleep,100
		return sc.2160(ea.start,ea.end),sc.2169,hwnd({rem:5})
	}if(A_GuiEvent=="f")
		return
	sel:=TV_GetSelection()
	Gui,5:TreeView,SysTreeView321
	if refreshing
		return
	ControlGetFocus,focus,% hwnd([5])
	SetTimer,findlabel,-200
	return
	findlabel:
	Gui,5:Default
	sel:=TV_GetSelection()
	if !TV_GetCount()
		Buttontext:="Search"
	else if TV_GetChild(sel)
		Buttontext:=TV_Get(sel,"E")?"Contract":"Expand"
	else if(TV_GetCount()&&TV_GetChild(sel)=0)
		Buttontext:="Jump"
	ControlSetText,Button6,%Buttontext%,% hwnd([5])
	return
	fsort:
	ControlSetText,Button6,Search,% hwnd([5])
	goto,search
	return
	5GuiEscape:
	5GuiClose:
	Gui,5:Submit,NoHide
	ea:=newwin[]
	settings.add({path:"search/find",att:{regex:ea.regex,cs:ea.cs,sort:ea.sort,gr:ea.gr,allfiles:ea.allfiles}}),foundinfo:=""
	positions.ssn("//*[@file='" file "']/@search").text:=ea.find
	hwnd({rem:5})
	return
	comment:
	sc:=csc()
	toggle_comment_line()
	return
}